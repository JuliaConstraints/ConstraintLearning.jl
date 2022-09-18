function icn(
    X,
    X̅,
    param = nothing;
    discrete = true,
    dom_size = δ(Iterators.flatten(X), Iterators.flatten(X̅), discrete),
    metric=:hamming,
    optimizer = GeneticOptimizer(),
    X_test = nothing,
)
    lc = learn_compose(
        X,
        X̅,
        dom_size,
        param;
        metric,
        optimizer
    )[1]
    return composition(lc)
end

function icn(
    domains::Vector{D},
    penalty::F,
    param = nothing;
    complete_search_limit=1000,
    search=:flexible,
    solutions_limit=100,
    configurations=explore(
        domains, penalty, param; search, complete_search_limit, solutions_limit
    ),
    discrete=true,
    dom_size = δ(
        Iterators.flatten(configurations[1]),
        Iterators.flatten(configurations[2]),
        discrete,
    ),
    metric=:hamming,
    optimizer = GeneticOptimizer(),
    X_test = nothing,
) where {D <: AbstractDomain, F <: Function}
    return icn(
        configurations[1],
        configurations[2],
        param;
        discrete,
        dom_size,
        metric,
        optimizer,
        X_test,
    )
end

function icn(
    X,
    penalty::F,
    param = nothing;
    discrete = true,
    dom_size = δ(Iterators.flatten(X), discrete),
    metric=:hamming,
    optimizer = GeneticOptimizer(),
    X_test = nothing,
) where {F <: Function}
    solutions, non_sltns = make_training_sets(X, penalty, param)
    return icn(
        solutions,
        non_sltns,
        param;
        discrete,
        dom_size,
        metric,
        optimizer,
        X_test,
    )
end
