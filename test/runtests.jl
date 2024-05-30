using Test
using TestItemRunner
using TestItems

@testset "Package tests: ConstraintLearning" begin
    include("Aqua.jl")
    include("TestItemRunner.jl")
end
