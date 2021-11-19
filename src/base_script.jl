using Pkg
Pkg.add("DrWatson")

# Load DrWatson (scientific project manager)
using DrWatson

using SharedArrays

# Activate the ICNBenchmarks project
@quickactivate "ICNBenchmarks"

# Pkg.instantiate()

# Load common code to all script in ICNBenchmarks
using ICNBenchmarks
