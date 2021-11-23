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

# Helper function to open files in O_EXCL mode
function tryopen_exclusive(path::String, mode::Integer = 0o666)
    try
        return open(path, JL_O_RDWR | JL_O_CREAT | JL_O_EXCL, mode)
    catch ex
        (isa(ex, IOError) && ex.code == UV_EEXIST) || rethrow(ex)
    end
    return nothing
end