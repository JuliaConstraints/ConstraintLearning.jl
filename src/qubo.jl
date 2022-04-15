function qubo(domains, penalty, param, ml, ::Val{:ga})
    f = icn(domains, penalty, param)
    return qubo(domains, f, param; ml)
end

function qubo(
    X_train,
    penalty,
    param = nothing;
    icn = :none,
    ml = :descent,
    opt = x -> 0.,
    X_check = X_train
)
    n = length(first(X_train))
    # N = n^2
    Q = zeros(n, n)
    return train!(Q, X_train, penalty, opt; X_check)
end

function qubo(
    domains::Vector{D},
    penalty::F,
    param = nothing;
    icn = :none,
    ml = :default,
    opt = x -> 0.,
    X_test = nothing,
)  where {D <: AbstractDomain, F <: Function}

end
