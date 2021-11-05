module ICNBenchmarks

# usings
using BenchmarkTools
using CompositionalNetworks
using ConstraintDomains
using Constraints
using CSV
using DataFrames
using DataVoyager
using Dictionaries
using DrWatson
using JSON
using Tables
using LatinHypercubeSampling

# imports
import Constraints: make_error

# constants
export ALL_PARAMETERS
export BENCHED_CONSTRAINTS

# others
export analyse_composition
export analyze_icn
export icn_benchmark
export search_space
export visualize_compositions
export visualize_icn

# includes
include("constants.jl")
include("search_space.jl")
include("extra_constraints.jl")
include("icn.jl")
include("analyze.jl")

end
