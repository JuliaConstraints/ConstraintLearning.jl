# Load distributed base_script
include(joinpath(dirname(@__DIR__), "src", "distributed_script.jl"))

@info "Using $(Distributed.nworkers()) workers"

compositions_benchmark(; clear_results=true)
