# Load distributed base_script
include(joinpath(dirname(@__DIR__), "src", "distributed_script.jl"))

@info "Using $(Distributed.nworkers()) workers"

if isempty(ARGS)
    compositions_benchmark(; clear_results=false)
elseif (ARGS[1] == "true")
    compositions_benchmark(; clear_results=true)
end
