using ConstraintDomains
using ConstraintLearning
using QUBOConstraints
using Test

@testset "CompositionalNetworks.jl" begin
    println("\nICN: Test for All Different 4×4")
    domains = [domain([1,2,3,4]) for i in 1:4]
    compo = icn(domains, allunique)
    @test compo([1,2,3,3], dom_size = 4) > 0.0
end

@testset "QUBOConstraints.jl" begin
    println("\nQUBO: Test for All Different 3×3")
    all_different(x) = allunique(x)

    binary_all_different(x) = all_different(integerize(x))

    opt_all_different(x) = 0.

    function sat_all_different(X)
        if count(x -> x == sqrt(length(X)), integerize(X)) > 0
            return sqrt(length(X))
        elseif binary_all_different(X)
            return -1.
        else
            return 1.
        end
    end

    X_train = [collect(binarize(rand(0:2, 3))) for _ in 1:100]
    X_check = [collect(binarize(rand(0:2, 3))) for _ in 1:10000]
    qubo(X_train, sat_all_different; X_check)
end
