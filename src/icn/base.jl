const ICNOptimizer = CompositionalNetworks.AbstractOptimizer

struct ICNConfig{O <: ICNOptimizer}
    metric::Symbol
    optimizer::O
end
