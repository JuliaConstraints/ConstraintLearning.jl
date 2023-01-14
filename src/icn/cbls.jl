struct ICNLocalSearchOptimizer <: ICNOptimizer
    options::LocalSearchSolvers.Options

    ICNLocalSearchOptimizer(options = LocalSearchSolvers.Options()) = new(options)
end

function mutually_exclusive(layer, w)
    x = as_int(w)
    l = length(layer)
    return iszero(x) ? 1.0 : max(0.0, x - l)
end

no_empty_layer(x; X = nothing) = max(0, 1 - sum(x))

parameter_specific_operations(x; X = nothing) = 0.0

function CompositionalNetworks.optimize!(
    icn, solutions, non_sltns, dom_size, param, metric, optimizer::ICNLocalSearchOptimizer
)
    @info "starting debug opt"
    m = model(; kind = :icn)
    n = nbits(icn)

    # All variables are boolean
    d = domain([false, true])

    # Add variables
    foreach(_ -> variable!(m, d), 1:n)

    # Add constraint
    start = 1
    for layer in layers(icn)
        if exclu(layer)
            stop = start + nbits_exclu(layer) - 1
            f(x; X = nothing) = mutually_exclusive(layer, x)
            constraint!(m, f, start:stop)
        else
            stop = start + length(layer) - 1
            constraint!(m, no_empty_layer, start:stop)
        end
        start = stop + 1
    end

    # Add objective
    inplace = zeros(dom_size, max_icn_length())

    function fitness(w)
        _w = BitVector(w)
        compo = compose(icn, _w)
        f = composition(compo)
        S = Iterators.flatten((solutions, non_sltns))
        @debug _w compo f S metric
        σ = sum(x -> abs(f(x; X=inplace, param, dom_size) - eval(metric)(x, solutions)), S)
        return  σ + regularization(icn) + weigths_bias(_w)
    end

    objective!(m, fitness)

    # Create solver and solve
    s = solver(m; options = optimizer.options)
    solve!(s)
    @info "pool" s.pool best_values(s.pool) best_values(s) s.pool.configurations

    # Return best values
    return has_solution(s), BitVector(collect(best_values(s)))
end
