
#using Pkg
#Pkg.add("DrWatson")

# Load DrWatson (scientific project manager)
using DrWatson
using Statistics

# Activate the ICNBenchmarks project
@quickactivate "ICNBenchmarks"

#Pkg.instantiate()
# Pkg.update()

# Load common code to all script in ICNBenchmarks
using ICNBenchmarks
using JSON
using Constraints
using CompositionalNetworks

#include(joinpath(projectdir("src"), "search_space.jl"))

function main(; clear_results=false)
    comps = Dict{Any,Any}()
    clear_results && rm(datadir("composition_results"); recursive=true, force=true)
    mkpath(datadir("composition_results"))
    Threads.@threads for file_name in cd(readdir, joinpath(datadir("compositions")))
        if startswith(file_name, "con=")
            json = JSON.parsefile(joinpath(datadir("compositions"), file_name))
            counter = 1
            while (haskey(json, string(counter)))
                path = joinpath(datadir("composition_results"), generate_file_name(json, counter))
                if isfile(path)
                    @warn "The result file already exist" path
                else
                    temp_concept, metric, comp, selection_rate, dom_size, search, complete_search_limit, solutions_limit, param = extract_data_from_json(
                        json, counter
                    )

                    @warn "describe data" extract_data_from_json(json, counter)

                    concept = Constraints.concept(BENCHED_CONSTRAINTS[temp_concept])

                    solutions, non_sltns, _ = search_space(
                        dom_size,
                        concept,
                        param;
                        search,
                        complete_search_limit,
                        solutions_limit,
                    )

                    icn_composition_string = comp[findfirst("function", comp)[1]:end]
                    icn_composition = eval(Meta.parse(icn_composition_string))
                    results = @timed loss(
                        solutions, non_sltns, icn_composition, eval(Meta.parse(metric)), dom_size, param; samples=nothing
                    )
                    normalised_results = normalise(Symbol(metric), results.value, dom_size)
                    push!(comps, "composition" => comp)
                    push!(comps, "composition_number" => counter)
                    push!(comps, "selection_rate" => selection_rate)
                    push!(comps, "time" => results.time)
                    push!(comps, "accuracy" => results.value)
                    push!(comps, "normalised" => normalised_results)
                    push!(comps, "mean" => mean(normalised_results))
                    push!(comps, "median" => median(normalised_results))
                    push!(comps, "std" => std(normalised_results, corrected=false))
                    push!(comps, "rsd" => rsd(normalised_results))
                    push!(comps, "var" => var(normalised_results, corrected=false))
                    push!(comps, "cov" => cov(normalised_results, corrected=false))
                    export_compositions(comps, path)
                    export_csv(comps, joinpath(datadir("composition_results"), "results.csv"))
                end
                counter += 1
            end
        end
    end

    return nothing
end

function extract_data_from_json(file, counter)
    concept = Symbol(file["params"]["concept"][1])
    
    metric = file["params"]["metric"]
    comp = file[string(counter)]["Julia"]
    selection_rate = file[string(counter)]["selection_rate"]
    dom_size = file["params"]["domains_size"]
    search = eval(Meta.parse(":" * file["params"]["search"]))
    complete_search_limit = file["params"]["complete_search_limit"]
    solutions_limit = file["params"]["sampling"]
    param = generate_param(file["params"]["concept"][2])


    return concept, metric,
    comp, selection_rate, dom_size, search, complete_search_limit, solutions_limit,
    param
end

function generate_param(param)
    # Generate an appropriate parameter for the concept if relevant
    param = if isnothing(param)
        nothing
    elseif param == 1
        rand(1:dom_size)
    else
        rand(1:dom_size, param)
    end
    return param
end

function export_compositions(comps, path)
    touch(path)
    return write(path, JSON.json(comps, 2))
end

# This function must be very bad performance wise, please tell me if you have better solutions :-)
function export_csv(comps, path)
    temp_dict = Dict{String, String}()
    delete!(comps, "composition")
    for column_name in collect(keys(comps))
        if isequal(column_name, "accuracy") || isequal(column_name, "normalised")
            value_str = "["
            for value in comps[column_name]
                value_str = string(value_str, string(value), ", ")
            end
            value_str = string(value_str[1:end-2], "]")
            temp_dict[column_name] = value_str
        else
            temp_dict[column_name] = string(comps[column_name])
        end
    end
    
    df = DataFrame(temp_dict)
    
    if isfile(path)
        @info "file already exists"
        CSV.write(path, df, append=true)
    else
        @info "file does not exist... creating a new one"
        CSV.write(path, df)
    end
        
end

function generate_file_name(file, counter)
    concept = file["params"]["concept"][1]
    symbols = file[string(counter)]["symbols"]
    file_name = concept
    for symbol in reverse(symbols)[1:end-1]
        file_name = string(file_name,"__",symbol[1])
    end
    for transformation in reverse(symbols[1])
            file_name = string(file_name,"__",transformation)
    end
    return string(file_name, ".json")
end

function loss(solutions, non_sltns, composition, metric, dom_size, param; samples=nothing)
    l = length(solutions)
    X = if isnothing(samples)
        l += length(non_sltns)
        Iterators.flatten((solutions, non_sltns))
    else
        l += samples
        Iterators.flatten((solutions, rand(non_sltns, samples)))
    end
    
    result =  map(x -> abs(Base.invokelatest(composition, x; param, dom_size) - metric(x, solutions)), X)
    return result
end

# relative standard deviation
rsd(results) = std(results, corrected=false)/mean(results) 


# normalise
normalise(metric, results, dom_size) = normalise(results, dom_size, Val(metric))
# divise par taille de variable * nombre de domaine pour manhattan
normalise(results, dom_size, ::Val{:manhattan}) = results / dom_size^2
# divise par taille de var pour hamming
normalise(results, dom_size, ::Val{:hamming}) = results / dom_size


main(;clear_results = true)
