
using Pkg
Pkg.add("DrWatson")

# Load DrWatson (scientific project manager)
using DrWatson

# Activate the ICNBenchmarks project
@quickactivate "ICNBenchmarks"

Pkg.instantiate()
# Pkg.update()

# Load common code to all script in ICNBenchmarks
using ICNBenchmarks
using JSON

#include(joinpath(projectdir("src"), "search_space.jl"))


function main()
    comps = Dict{Any,Any}()
    mkpath(datadir("composition_results"))
    for file_name in cd(readdir,joinpath(datadir("compositions")))
        if startswith(file_name,"con=") 
            json = JSON.parsefile(joinpath(datadir("compositions"),file_name))
            counter = 1
            while (haskey(json, string(counter)))
                path = joinpath(datadir("composition_results"), file_name)
                path = "$(path[1:end-5])_$counter.json"
                if isfile(path)
                    @warn "The result file already exist" file_name
                else
                    concept, comp, selection_rate,
                     dom_size, search, complete_search_limit,
                      solutions_limit , param = extract_data_from_json(json, counter)
                    
                    solutions, non_sltns, _ = search_space(
                    dom_size,
                    concept,
                    param;
                    search=search,
                    complete_search_limit=complete_search_limit,
                    solutions_limit=solutions_limit,
                    )
                    
                    results = @timed loss(solutions, non_sltns, comp, metric, dom_size, param; samples=nothing)
                    push!(comps, "composition" => comp)
                    push!(comps, "composition_number" => counter)
                    push!(comps, "selection_rate" => selection_rate)
                    push!(comps, "time" => results.time)
                    push!(comps, "accuracy" => results.value)
                    export_compositions(comps, path)
                    counter += 1
                end
            end
        end
    end
end

function extract_data_from_json(file, counter)
    concept = eval(Meta.parse("(:"*file["params"]["concept"][1]*",nothing)"))
    
    concept = concept(BENCHED_CONSTRAINTS[Symbol(file["params"]["concept"][1])])
    comp = file[string(counter)]["Julia"]
    selection_rate = file[string(counter)]["selection_rate"]
    dom_size = file["params"]["domains_size"]
    search = eval(Meta.parse(":"*file["params"]["search"]))
    complete_search_limit = file["params"]["complete_search_limit"]
    solutions_limit = file["params"]["sampling"]
    param = generate_param(file["params"]["concept"][2])
    
    return concept, comp, selection_rate, dom_size,
     search, complete_search_limit, solutions_limit, param
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
    write(path, JSON.json(comps,2))
end

# Here I'm not sure if the formula σ is correct to calculate precision as a %
# Since the term precision I'm familiar with is a classification metric
function loss(solutions, non_sltns, composition, metric, dom_size, param; samples=nothing)
    X = if isnothing(samples)
        Iterators.flatten((solutions, non_sltns))
    else
        Iterators.flatten((solutions, rand(non_sltns, samples)))
    end
    σ = sum(x -> 1-(abs(composition(x; param, dom_size) - metric(x, solutions)))/dom_size, X)
    return σ/length(X)
end
# divise par taille de variable * nombre de domaine pour manhattan
# divise par taille de var pour hamming

main()