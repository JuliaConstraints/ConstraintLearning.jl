# TODO:: test learned configs against concrete instances, 
# outside of training sets, using bigger spaces than used in learning. 
# maybe use particular strategies for search space exploration, (latin hypercube sampling)

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

using CSV
using DataFrames

#include(joinpath(projectdir("src"), "search_space.jl"))

function main(; clear_results=false)
    comps = Dict{Any,Any}()
    clear_results && rm(datadir("composition_results"); recursive=true, force=true)
    mkpath(datadir("composition_results"))
    number_of_compositions = 0
    symbols_dict = Dict{String, Int64}()
    #Threads.@threads for some reason causes => nested task error: UndefRefError: access to undefined reference
    Threads.@threads for file_name in cd(readdir, joinpath(datadir("compositions")))
        if startswith(file_name, "con=")
            json = JSON.parsefile(joinpath(datadir("compositions"), file_name))
            counter = 1
            while (haskey(json, string(counter)))
                path = joinpath(datadir("composition_results"), generate_file_name(json, counter, symbols_dict))
                if isfile(path)
                    @warn "The result file already exist" path
                else
                    touch(path)

                    n_symbols, memoize, population, generations, icn_iterations, partial_search_limit, 
                    icn_time, maths, temp_concept, metric, comp, 
                    selection_rate, dom_size, search, complete_search_limit, 
                    solutions_limit, param = extract_data_from_json(
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
                    timed_loss = @timed loss( 
                        solutions, non_sltns, icn_composition, eval(Meta.parse(metric)), dom_size, param; samples=solutions_limit
                    )
                    results = timed_loss.value[1]
                    sol_length = timed_loss.value[2]
                    normalised_results = normalise(Symbol(metric), results, dom_size)
                    push!(comps, "icn_time" => icn_time)
                    push!(comps, "search" => search)
                    push!(comps, "concept" => temp_concept)
                    push!(comps, "complete_search_limit" => complete_search_limit)
                    push!(comps, "memoize" => memoize)
                    push!(comps, "sampling" => solutions_limit)
                    push!(comps, "population" => population)
                    push!(comps, "generations" => generations)
                    push!(comps, "icn_iterations" => icn_iterations)
                    push!(comps, "partial_search_limit" => partial_search_limit)
                    push!(comps, "maths" => maths)
                    push!(comps, "composition" => comp)
                    push!(comps, "composition_number" => counter)
                    push!(comps, "selection_rate" => selection_rate)
                    push!(comps, "time" => timed_loss.time/sol_length)
                    push!(comps, "accuracy" => results)
                    push!(comps, "normalised" => normalised_results)
                    push!(comps, "mean" => mean(normalised_results))
                    push!(comps, "median" => median(normalised_results))
                    push!(comps, "std" => std(normalised_results, corrected=false))
                    #push!(comps, "rsd" => rsd(normalised_results))
                    push!(comps, "var" => var(normalised_results, corrected=false))
                    push!(comps, "cov" => cov(normalised_results, corrected=false))
                    push!(comps, "symbols_count" => n_symbols)
                    export_compositions(comps, path)
                    export_csv(comps, joinpath(datadir("composition_results"), "results.csv"))
                end
                counter += 1
            end
            number_of_compositions += counter
            @info "number of compositions: " number_of_compositions
        end
    end

    export_symbols_dict(symbols_dict)

    return nothing
end

function extract_data_from_json(file, counter)
    symbols_count = length(file[string(counter)]["symbols"][1]) + 3
    icn_time = file["icn_time"]
    memoize = file["params"]["memoize"]
    population = file["params"]["population"]
    generations = file["params"]["generations"]
    icn_iterations = file["params"]["icn_iterations"]
    search = file["params"]["search"]
    partial_search_limit = file["params"]["partial_search_limit"]
    concept = Symbol(file["params"]["concept"][1])
    maths = file[string(counter)]["maths"]
    metric = file["params"]["metric"]
    comp = file[string(counter)]["Julia"]
    selection_rate = file[string(counter)]["selection_rate"]
    # Add 1 to dom_size to test using different spaces from training
    dom_size = file["params"]["domains_size"] + 1
    search = eval(Meta.parse(":" * file["params"]["search"]))
    complete_search_limit = file["params"]["complete_search_limit"]
    solutions_limit = file["params"]["sampling"]
    param = generate_param(file["params"]["concept"][2], dom_size)

    return symbols_count, memoize, population, generations, icn_iterations, partial_search_limit,
    icn_time, maths, concept, metric,comp, selection_rate, dom_size, 
    search, complete_search_limit, solutions_limit, param
end

function generate_param(param, dom_size)
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
    return write(path, JSON.json(comps, 2))
end

function export_symbols_dict(symbols_dict::Dict{String, Int64})
    path = joinpath(datadir("composition_results"), "sybols_dict.csv")
    
    CSV.write(path, DataFrame(symbols_dict))

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
        CSV.write(path, df, append=true)
    else
        CSV.write(path, df)
    end
        
end

function generate_file_name(file, counter, symbols_dict)
    concept = file["params"]["concept"][1]
    symbols = file[string(counter)]["symbols"]

    # sort transformation symbols to avoid duplicate compositions
    sort!(symbols[1])

    file_name = concept
    for symbol in reverse(symbols)[1:end-1]
        if symbol[1] ∉ keys(symbols_dict)
            push!(symbols_dict, symbol[1] => length(symbols_dict) + 1)
        end
        file_name = string(file_name,"_",symbols_dict[symbol[1]])
    end

    for transformation in reverse(symbols[1])
        if transformation ∉ keys(symbols_dict)
            push!(symbols_dict, transformation => length(symbols_dict) + 1)
        end
        file_name = string(file_name,"_",symbols_dict[transformation])
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
    
    for m ∈ methods(composition)
        Base.delete_method(m)
    end
    return result, l
end


# relative standard deviation
rsd(results) = std(results, corrected=false)/mean(results) 


# normalise
normalise(metric, results, dom_size) = normalise(results, dom_size, Val(metric))
# divise par taille de variable * nombre de domaine pour manhattan
normalise(results, dom_size, ::Val{:manhattan}) = results / dom_size^2
# divise par taille de var pour hamming
normalise(results, dom_size, ::Val{:hamming}) = results / dom_size

function count_compositions()
    total_compositions = 0
    unique_compositions = 0
    existing_comps = []
    for file_name in cd(readdir, joinpath(datadir("compositions")))
        if startswith(file_name, "con=")
            json = JSON.parsefile(joinpath(datadir("compositions"), file_name))
            unique_counter = 1
            counter = 1
            symbol_number = 1
            while (haskey(json, string(counter)))
                path = joinpath(datadir("composition_results"), generate_file_name(json, counter, symbols_dict))
                if path ∉ existing_comps
                    unique_counter += 1
                    push!(existing_comps, path)
                end
                counter += 1
            end
            total_compositions += counter
            unique_compositions += unique_counter
        end
        @info "current number of compositions: " total_compositions
        @info "current number of unique compositions: " unique_compositions
    end
    @info "total number of compositions: " total_compositions
    @info "total number of unique compositions: " unique_compositions
end

main(;clear_results = true)
