@testset "Aqua.jl" begin
    import Aqua
    import ConstraintLearning

    # TODO: Fix the broken tests and remove the `broken = true` flag
    Aqua.test_all(
        ConstraintLearning;
        ambiguities = (broken = true,),
        deps_compat = false,
        piracies = (broken = false,),
        unbound_args = (broken = false)
    )

    @testset "Ambiguities: ConstraintLearning" begin
        # Aqua.test_ambiguities(ConstraintLearning;)
    end

    @testset "Piracies: ConstraintLearning" begin
        # Aqua.test_piracies(ConstraintLearning;)
    end

    @testset "Dependencies compatibility (no extras)" begin
        Aqua.test_deps_compat(
            ConstraintLearning;
            check_extras = false            # ignore = [:Random]
        )
    end

    @testset "Unbound type parameters" begin
        # Aqua.test_unbound_args(ConstraintLearning;)
    end
end
