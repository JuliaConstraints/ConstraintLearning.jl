using DrWatson
@quickactivate "ICNBenchmarks"

function main()
    if isempty(ARGS)
        @warn "No arguments found\nUsage: julia -t auto main.jl \"concept\" \"params\""
        @info "To view the list of available concepts, use julia main.jl -show_concepts"
    else
        if (ARGS[1] == "-show-concepts")
            @info "Available concepts:\n"
            @info [concept[1:end-3] for concept in readdir() if concept!="main.jl"]
        else
            concept = ARGS[1]*".jl"
            if (concept ∉ readdir())
                @error "The provided concept name does not exist"
                exit()
            end
            if (Threads.nthreads() == 1)
                @warn "Currently using only one thread\n make sure to run the script using julia -t auto"
            end
            include(joinpath(projectdir("src"), "base_script.jl"))

            if (length(ARGS) > 1)
                for param in ARGS[2:end]
                    eval(Meta.parse(param))
                end
            end

            include(ARGS[1]*".jl")

        end
    end
end

main()