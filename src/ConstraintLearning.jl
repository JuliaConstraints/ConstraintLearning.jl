module ConstraintLearning

using ConstraintDomains
using CompositionalNetworks
using QUBOConstraints

export icn
export qubo

function qubo(domains, concept, param, ml, ::Val{:ga})
    f = icn(domains, concept, param, Val(:ga))
    return qubo(domains, f, param; ml)
end

function qubo(domains, f, param = nothing; icn = :none, ml = :descent)
    return nothing
end

function icn(domains, concept, param, ::Val{:ga})
    return composition(explore_learn_compose(domains, concept, param)[1])
end

function icn(domains, concept, param = nothing; optim = :ga)
    return icn(domains, concept, param, Val(optim))
end

end
