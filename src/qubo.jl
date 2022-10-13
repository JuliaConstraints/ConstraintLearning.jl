function qubo(
    X,
    penalty::Function,
    dom_stuff = nothing;
    param = nothing,
    icn_conf = nothing,
    optimizer = GradientDescentOptimizer(),
    X_test = X,
)
    if icn_conf !== nothing
        penalty = icn(X, penalty; param, metric = icn_conf.metric, optimizer = icn_conf.optimizer)
    end
    return train(X, penalty, dom_stuff; optimizer, X_test)
end

function qubo(
    X,
    X̅,
    dom_stuff = nothing;
    icn_conf = nothing,
    optimizer = GradientDescentOptimizer(),
    param = nothing,
    X_test = union(X, X̅),
)
    X_train, penalty = make_set_penalty(X, X̅, param, icn_conf)
    return qubo(X_train, penalty, dom_stuff; icn_conf, optimizer, param, X_test)
end
