"""
    const ICNOptimizer = CompositionalNetworks.AbstractOptimizer

An abstract type for optmizers defined to learn ICNs.
"""
const ICNOptimizer = CompositionalNetworks.AbstractOptimizer

"""
    struct ICNConfig{O <: ICNOptimizer}

A structure to hold the metric and optimizer configurations used in learning the weights of an ICN.
"""
struct ICNConfig{O <: ICNOptimizer}
    metric::Symbol
    optimizer::O
end
