include("../src/base_script.jl")

ALL_PARAMETERS[:concept] = [(:minimum, 1)]

# NOTE - Please use clear_results=false (default) for the real experiments
# icn_benchmark(; clear_results=true)

icn_benchmark()
