function δ(X; discrete = true)
    mn, mx = extrema(X)
    return mx - mn + discrete
end

function δ(X, Y; discrete = true)
    mnx, mxx = extrema(X)
    mny, mxy = extrema(Y)
    return max(mxx, mxy) - min(mnx, mny) + discrete
end

sub_eltype(X) = eltype(first(T))

domain_size(ds::Number) = ds

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
function make_training_sets(X, penalty::Vector{T}, _, _) where {T <: Real}
    solutions = Set{Vector{Int}}()
    non_sltns = Set{Vector{Int}}()

    foreach(
        (c, p) -> (cv = collect(c); push!(p ? non_sltns : solutions, cv)),
        Iterators.zip(X, penalty),
    )

    return solutions, non_sltns
end

function make_set_penalty(X, X̅)
    penalty = x -> x ∈ X ? 1. : x ∈ X̅ ? 0. : 0.5
    X_train = union(X, X̅)
    return X_train, penalty
end

make_set_penalty(X, X̅, _, ::Nothing) = make_set_penalty(X, X̅)

function make_set_penalty(X, X̅, param, icn_conf)
    penalty = icn(X, X̅; param, metric = icn_conf.metric, optimizer = icn.optimizer)
    X_train = union(X, X̅)
    return X_train, penalty
end
