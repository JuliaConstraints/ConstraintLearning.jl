function δ(X, discrete = true)
    mn, mx = extrema(X)
    return mx - mn + discrete
end

function δ(X, Y, discrete = true)
    mnx, mxx = extrema(X)
    mny, mxy = extrema(Y)
    return max(mxx, mxy) - min(mnx, mny) + discrete
end

sub_eltype(X) = eltype(first(T))

function make_training_sets(X, penalty, p)
    f = isnothing(param) ? ((x; param = p) -> penalty(x)) : penalty

    solutions = Set{Vector{Int}}()
    non_sltns = Set{Vector{Int}}()

    foreach(
        c -> (cv = collect(c); push!(f(cv; param) ? solutions : non_sltns, cv)),
        X,
    )

    return solutions, non_sltns
end

# REVIEW - Is it correct? Make a CI test
function make_training_sets(X, penalty::Vector{T}, p) where {T <: Real}
    f = isnothing(param) ? ((x; param = p) -> penalty(x)) : penalty

    solutions = Set{Vector{Int}}()
    non_sltns = Set{Vector{Int}}()

    foreach(
        (c, p) -> (cv = collect(c); push!(p ? non_sltns : solutions, cv)),
        Iterators.zip(X, penalty),
    )

    return solutions, non_sltns
end
