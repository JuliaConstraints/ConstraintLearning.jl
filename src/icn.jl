"""
    icn(X,X̅; kargs..., parameters...)

TBW
"""
function icn(
    X,
    X̅;
    discrete = true,
    dom_size = δ(Iterators.flatten(X), Iterators.flatten(X̅); discrete),
    metric = :hamming,
    optimizer = ICNGeneticOptimizer(),
    X_test = nothing,
    parameters...
)
    lc = learn_compose(
        X,
        X̅,
        dom_size;
        metric,
        optimizer,
        X_test,
        parameters...
    )[1]
    return composition(lc)
end

function icn(
    domains::Vector{D},
    penalty::F;
    configurations = nothing,
    discrete = true,
    dom_size = nothing,
    metric=:hamming,
    optimizer = ICNGeneticOptimizer(),
    X_test = nothing,
    parameters...
) where {D <: AbstractDomain, F <: Function}
    if isnothing(configurations)
        configurations = explore(domains, penalty; parameters...)
    end

    if isnothing(dom_size)
        dom_size = δ(
            Iterators.flatten(configurations[1]),
            Iterators.flatten(configurations[2]);
            discrete,
        )
    end

    return icn(
        configurations[1],
        configurations[2];
        discrete,
        dom_size,
        metric,
        optimizer,
        X_test,
        parameters...
    )
end

function icn(
    X,
    penalty::F;
    discrete = true,
    dom_size = δ(Iterators.flatten(X); discrete),
    metric = :hamming,
    optimizer = ICNGeneticOptimizer(),
    X_test = nothing,
    parameters...
) where {F <: Function}
    solutions, non_sltns = make_training_sets(X, penalty, dom_size; parameters...)
    return icn(
        solutions,
        non_sltns;
        discrete,
        dom_size,
        metric,
        optimizer,
        X_test,
        parameters...
    )
end
