function qubo(domains, penalty, param, ml, ::Val{:ga})
    f = icn(domains, penalty, param)
    return qubo(domains, f, param; ml)
end

function qubo(
    X,
    penalty,
    param = nothing;
    icn = nothing,
    optimizer = GradientDescentOptimizer(),
    X_check = X,
)
    n = length(first(X_train))
    # N = n^2
    Q = zeros(n, n)
    return train!(Q, X_train, penalty, opt; X_check)
end
