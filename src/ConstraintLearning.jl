module ConstraintLearning

# SECTION - imports
using ConstraintDomains

using CompositionalNetworks
using Dictionaries
using Evolutionary
using Memoization
using ThreadPools

using QUBOConstraints

# SECTION - usings
export icn
export qubo

export ICNConfig
export ICNGeneticOptimizer
export ICNOptimizer

# SECTION - includes common
include("common.jl")

# SECTION - ICN
include("icn/base.jl")
include("icn/genetic.jl")
include("icn.jl")

# SECTION - QUBO
include("qubo.jl")

end
