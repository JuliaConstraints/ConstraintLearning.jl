struct QUBOGradientOptimizer <: QUBOConstraints.AbstractOptimizer
    binarization::Symbol
    η::Float64
    precision::Int
    oversampling::Bool
end

"""
    QUBOGradientOptimizer(; kargs...)

A QUBO optimizer based on gradient descent. Defaults TBW
"""
function QUBOGradientOptimizer(;
    binarization = :one_hot,
    η = .001,
    precision = 5,
    oversampling = false,
)
    return QUBOGradientOptimizer(binarization, η, precision, oversampling)
end

"""
    predict(x, Q)

Return the predictions given by `Q` for a given configuration `x`.
"""
predict(x, Q) = transpose(x) * Q * x

"""
    loss(x, y, Q)

Loss of the prediction given by `Q`, a training set `y`, and a given configuration `x`.
"""
loss(x, y, Q) = (predict(x, Q) .- y).^2

"""
    make_df(X, Q, penalty, binarization, domains)

DataFrame arrangement to ouput some basic evaluation of a matrix `Q`.
"""
function make_df(X, Q, penalty, binarization, domains)
	df = DataFrame()
	for (i,x) in enumerate(X)
		if i == 1
			df = DataFrame(transpose(x), :auto)
		else
			push!(df, transpose(x))
		end
	end

	dim = length(df[1,:])

    if binarization == :none
        df[!,:penalty] = map(r -> penalty(Vector(r)), eachrow(df))
        df[!,:predict] = map(r -> predict(Vector(r), Q), eachrow(df[:, 1:dim]))
    else
        df[!,:penalty] = map(
            r -> penalty(binarize(Vector(r), domains; binarization)),
            eachrow(df)
        )
        df[!,:predict] = map(
            r -> predict(binarize(Vector(r), domains; binarization), Q),
            eachrow(df[:, 1:dim])
        )
    end

	min_false = minimum(
        filter(:penalty => >(minimum(df[:,:penalty])), df)[:,:predict];
        init = typemax(Int)
    )
    df[!,:shifted] = df[:,:predict] .- min_false
    df[!,:accurate] = df[:, :penalty] .* df[:,:shifted] .≥ 0.

	return df
end

"""
    preliminaries(args)

Preliminaries to the training process in a `QUBOGradientOptimizer` run.
"""
function preliminaries(X, domains, binarization)
    if binarization==:none
        n = length(first(X))
        return X, zeros(n,n)
    else
        Y = map(x -> collect(binarize(x, domains; binarization)), X)
        n = length(first(Y))
        return Y, zeros(n,n)
    end
end

function preliminaries(X, _)
    n = length(first(X))
    return X, zeros(n,n)
end

"""
    train!(Q, X, penalty, η, precision, X_test, oversampling, binarization, domains)

Training inner method.
"""
function train!(Q, X, penalty, η, precision, X_test, oversampling, binarization, domains)
    θ = params(Q)
    try
        penalty(first(X))
    catch e
        if isa(e, UndefKeywordError)
            penalty = (x; dom_size = δ_extrema(Iterators.flatten(X)))-> penalty(x; dom_size)
        else
            throw(e)
        end
    end
    for x in (oversampling ? oversample(X, penalty) : X)
        grads = gradient(() -> loss(x, penalty(x), Q), θ)
        Q .-= η * grads[Q]
    end

    Q[:,:] = round.(precision*Q)

    df = make_df(X_test, Q, penalty, binarization, domains)
    return pretty_table(DataFrames.describe(df[!, [:penalty, :predict, :shifted, :accurate]]))
end

"""
    train(X, penalty[, d]; optimizer = QUBOGradientOptimizer(), X_test = X)

Learn a QUBO matrix on training set `X` for a constraint defined by `penalty` with optional domain information `d`. By default, it uses a `QUBOGradientOptimizer` and `X` as a testing set.
"""
function train(
    X,
    penalty,
    domains::Vector{D};
    optimizer = QUBOGradientOptimizer(),
    X_test = X,
) where {D <: DiscreteDomain}
    Y, Q = preliminaries(X, domains, optimizer.binarization)
    train!(
        Q, Y, penalty, optimizer.η, optimizer.precision, X_test,
        optimizer.oversampling, optimizer.binarization, domains
    )
    return Q
end

function train(
    X,
    penalty,
    dom_stuff = nothing;
    optimizer = QUBOGradientOptimizer(),
    X_test = X,
)
    return train(X, penalty, to_domains(X, dom_stuff); optimizer, X_test)
end

## SECTION - Test Items
@testitem "QUBOConstraints" tags =[:qubo, :gradient] default_imports=false begin
    using ConstraintLearning
    using QUBOConstraints

    X₃₃ = [rand(0:2, 3) for _ in 1:10]
    X₃₃_test = [rand(0:2, 3) for _ in 1:100]

    B₉ = [rand(Bool, 9) for _ in 1:10]
    B₉_test = [rand(Bool, 9) for _ in 1:2000]

    training_configs = [
        Dict(
            :info => "No binarization on ⟦0,2⟧³",
            :train => X₃₃,
            :test => X₃₃_test,
            :encoding => :none,
            :binarization => :none,
        ),
        Dict(
            :info => "Domain Wall binarization on ⟦0,2⟧³",
            :train => X₃₃,
            :test => X₃₃_test,
            :encoding => :none,
            :binarization => :domain_wall,
        ),
        Dict(
            :info => "One-Hot pre-encoded on ⟦0,2⟧³",
            :train => B₉,
            :test => B₉_test,
            :encoding => :one_hot,
            :binarization => :none,
        ),
    ]

    function all_different(x, encoding)
        encoding == :none && (return allunique(x))
        isv = if encoding == :one_hot
            mapreduce(i -> is_valid(x[i:i+2], Val(encoding)), *, 1:3:9)
        else
            mapreduce(i -> is_valid(x[i:i+1], Val(encoding)), *, 1:2:6)
        end
        if isv
            b = all_different(debinarize(x; binarization = encoding), :none)
            return b ? -1. : 1.
        else
            return length(x)
        end
    end

    function all_different(x, encoding, binarization)
        return all_different(x, encoding == :none ? binarization : encoding)
    end

    for config in training_configs
        println("\nTest for $(config[:info])")
        penalty = x -> all_different(x, config[:encoding], config[:binarization])
        optimizer = QUBOGradientOptimizer(; binarization = config[:binarization])
        qubo(config[:train], penalty; optimizer, X_test = config[:test])
        # qubo(config[:train], penalty; optimizer, X_test = config[:test], icn_conf = ICNConfig())
    end
end
