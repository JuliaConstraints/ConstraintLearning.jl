
#using Pkg
#Pkg.add("DrWatson")

# Load DrWatson (scientific project manager)
using DrWatson

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

function main()
    comps = Dict{Any,Any}()
    mkpath(datadir("composition_results"))
    for file_name in cd(readdir, joinpath(datadir("compositions")))
        if startswith(file_name, "con=")
            json = JSON.parsefile(joinpath(datadir("compositions"), file_name))
            counter = 1
            while (haskey(json, string(counter)))
                path = joinpath(datadir("composition_results"), file_name)
                path = "$(path[1:end-5])_$counter.json"
                if isfile(path)
                    @warn "The result file already exist" file_name
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
                        solutions, non_sltns, icn_composition, metric, dom_size, param; samples=nothing
                    )
                    push!(comps, "composition" => comp)
                    push!(comps, "composition_number" => counter)
                    push!(comps, "selection_rate" => selection_rate)
                    push!(comps, "time" => results.time)
                    push!(comps, "accuracy" => results.value)
                    export_compositions(comps, path)
                end
                counter += 1
            end
        end
    end
end

function extract_data_from_json(file, counter)
    concept = Symbol(file["params"]["concept"][1])
    
    metric = eval(Meta.parse(file["params"]["metric"]))
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
```
test
```
# Here I'm not sure if the formula σ is correct to calculate precision as a %
# Since the term precision I'm familiar with is a classification metric
function loss(solutions, non_sltns, composition, metric, dom_size, param; samples=nothing)
    l = length(solutions)
    X = if isnothing(samples)
        l += length(non_sltns)
        Iterators.flatten((solutions, non_sltns))
    else
        l += samples
        Iterators.flatten((solutions, rand(non_sltns, samples)))
    end

    σ = sum(
        x -> 1 - (abs(composition(x; param, dom_size) - metric(x, solutions))) / dom_size, X
    )
    return σ / l
end
# divise par taille de variable * nombre de domaine pour manhattan
# divise par taille de var pour hamming

main()
