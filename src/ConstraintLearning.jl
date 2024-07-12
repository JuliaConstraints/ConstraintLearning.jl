module ConstraintLearning

# SECTION - imports
using ConstraintDomains
using Constraints
using LocalSearchSolvers

using CompositionalNetworks
using Dictionaries
using Evolutionary
using Memoization
using TestItems
using ThreadPools

using QUBOConstraints
using DataFrames
using Flux
using PrettyTables

import Flux.Optimise: update!
import Flux: params

import CompositionalNetworks: exclu, nbits_exclu, nbits, layers, compose, as_int

# SECTION - exports
export icn
export qubo

export ICNConfig
export ICNGeneticOptimizer
export ICNLocalSearchOptimizer
export ICNOptimizer

export QUBOGradientOptimizer
export QUBOOptimizer

# SECTION - includes common
include("common.jl")

# SECTION - ICN
include("icn/base.jl")
include("icn/genetic.jl")
include("icn/cbls.jl")
include("icn.jl")

# SECTION - QUBO
include("qubo/base.jl")
include("qubo/gradient.jl")
include("qubo.jl")

end
