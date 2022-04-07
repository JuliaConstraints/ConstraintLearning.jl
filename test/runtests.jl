using ConstraintDomains
using ConstraintLearning
using Test

@testset "ConstraintLearning.jl" begin
    domains = [domain([1,2,3,4]) for i in 1:4]
    compo = icn(domains, allunique)
    @test compo([1,2,3,3], dom_size = 4) > 0.0

end
