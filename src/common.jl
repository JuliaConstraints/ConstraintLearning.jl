"""
    δ(X[, Y]; discrete = true)

Compute the extrema over a collection `X`` or a pair of collection `(X, Y)`.
"""
function δ(X; discrete = true)
    mn, mx = extrema(X)
    return mx - mn + discrete
end

function δ(X, Y; discrete = true)
    mnx, mxx = extrema(X)
    mny, mxy = extrema(Y)
    return max(mxx, mxy) - min(mnx, mny) + discrete
end

"""
    sub_eltype(X)

Return the element type of of the first element of a collection.
"""
sub_eltype(X) = eltype(first(T))

"""
    domain_size(ds::Number)

Extends the domain_size function when `ds` is number (for dispatch purposes).
"""
domain_size(ds::Number) = ds

"""
    make_training_sets(X, penalty, args...)

Return a pair of solutions and non solutions sets based on `X` and `penalty`.
"""
function make_training_sets(X, penalty, p, ds)
    f = isnothing(p) ? ((x; param = p) -> penalty(x)) : penalty

    solutions = Set{Vector{Int}}()
    non_sltns = Set{Vector{Int}}()

    foreach(
        c -> (cv = collect(c); push!(f(cv; param = p) ? solutions : non_sltns, cv)),
        X,
    )

    return solutions, non_sltns
end

# REVIEW - Is it correct? Make a CI test
function make_training_sets(X, penalty::Vector{T}, _) where {T <: Real}
    solutions = Set{Vector{Int}}()
    non_sltns = Set{Vector{Int}}()

    foreach(
        (c, p) -> (cv = collect(c); push!(p ? non_sltns : solutions, cv)),
        Iterators.zip(X, penalty),
    )

    return solutions, non_sltns
end

"""
    make_set_penalty(X, X̅, args...; kargs)

Return a penalty function when the training set is already split into a pair of solutions `X` and non solutions `X̅`.
"""
function make_set_penalty(X, X̅)
    penalty = x -> x ∈ X ? 1. : x ∈ X̅ ? 0. : 0.5
    X_train = union(X, X̅)
    return X_train, penalty
end

make_set_penalty(X, X̅, ::Nothing) = make_set_penalty(X, X̅)

function make_set_penalty(X, X̅, icn_conf; parameters...)
    penalty = icn(X, X̅; metric = icn_conf.metric, optimizer = icn.optimizer, parameters...)
    X_train = union(X, X̅)
    return X_train, penalty
end
