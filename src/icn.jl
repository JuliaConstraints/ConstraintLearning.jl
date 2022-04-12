# function icn(domains, penalty, param, ::Val{:ga})
#     return composition(explore_learn_compose(domains, penalty, param)[1])
# end

function icn(
    domains::Vector{D},
    penalty::F,
    param = nothing;
    optimiser = :ga,
    X_test = nothing,
) where {D <: AbstractDomain, F <: Function}
    return composition(explore_learn_compose(domains, penalty, param)[1])
end

function icn(
    X,
    X̅,
    param = nothing;
    discrete = true,
    dom_size = δ(Iterators.flatten(X), Iterators.flatten(X̅), discrete),
    optimiser = :ga,
    X_test = nothing
)
    return composition(learn_compose(X, X̅, dom_size; param)[1])
end

function icn(
    X,
    penalty::F,
    param = nothing;
    discrete = true,
    dom_size = δ(Iterators.flatten(X), discrete),
    optimiser = :ga,
    X_test = nothing,
) where {F <: Function}
    solutions, non_sltns = make_training_sets(X, penalty, param)
    return icn(solutions, non_sltns, param; dom_size, optimiser, X_test)
end

function icn(
    X,
    penalty::Vector{T},
    param = nothing;
    discrete = true,
    dom_size = δ(Iterators.flatten(X), discrete),
    optimiser = :ga,
    X_test = nothing,
) where {T <: Real}
    solutions, non_sltns = make_training_sets(X, penalty, param)
    return icn(solutions, non_sltns, param; dom_size, optimiser, X_test)
end
