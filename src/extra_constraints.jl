# This files stores constraints or concepts that are not yet available within usual_constraints
# The list is based on https://arxiv.org/abs/2009.00514

# SECTION - Generic constraints
# intension: predicate over variables (DONE)
# extension: supports or conflicts with a set of configurations

# SECTION - Constraints defined from Languages
# regular: recognize a regular automaton
# mdd: follow a multi-values decision diagram

# SECTION - Comparison-based Constraints
# all_different: done in Constraints.jl
# candidate: all_different_except (DONE)
# all_equal: done in Constraints.jl
# all_equal_param: done (not in XCSP3)
# ordered: increasing (current ordered in Constraints.jl), strictly_increasing (DONE), decreasing, strictly_decreasing

# SECTION - Counting and Summing Constraints
# sum or linear or linear_sum: sum_equal_param (DONE)
# candidate: more generic linear equation (DONE)
# count: count, among, at_least, at_most
# n_values: n_values, at_least_n_values, at_most_n_values
# candidate: n_values_except (ignores the values in except)
# cardinality: (global_)cardinality

# SECTION - Connection Constraints
# maximum: all values lower than param (DONE)

# minimum
concept_minimum(x; param) = minimum(x) < param

const _minimum = Constraint(
    concept = concept_minimum,
    error = make_error(:minimum),
)

push!(BENCHED_CONSTRAINTS, :minimum => _minimum)

# element: param ∈ values(variables)
# channel: if xᵢ = paramⱼ then xⱼ = paramᵢ

# SECTION - Packing and Scheduling Constraints
# no_overlap: disjunctive (no_overlap_1D), diffn (kD)
# cummulative: check pdf :p

# SECTION - Constraints on Graphs
# circuit: verify that the sequence of vertices forms a circuit (where xᵢ = j => (i,j)∈E)

# SECTION - Elementary Constraints
# instantiation: x == param

## no overlap 1D and 2D (commented)
function concept_no_overlap(x; param)
    for i in 1:(length(x)-1), j in i:length(x)
        x[i] + param > x[j] && x[j] + param > x[i] && return false
    end
    return true
end

# function concept_no_overlap(x; param::AbstractVector)
#     for i in 1:(length(x)-1), j in i:length(x)
#         x[i] + param[i] > x[j] && x[j] + param[j] > x[i] && return false
#     end
#     return true
# end

const no_overlap = Constraint(
    concept = concept_no_overlap,
    error = make_error(:no_overlap),
)

push!(BENCHED_CONSTRAINTS, :no_overlap => no_overlap)


## maximum
concept_maximum(x; param) = maximum(x) < param

const _maximum = Constraint(
    concept = concept_maximum,
    error = make_error(:maximum),
)

push!(BENCHED_CONSTRAINTS, :maximum => _maximum)

## intension
concept_intension(x; param::Function) = param(x)

const _intension = Constraint(
    concept = concept_intension,
    error = make_error(:intension),
)

push!(BENCHED_CONSTRAINTS, :intension => _intension)

## linear
concept_linear(x1, op1::Function, x2, op2::Funcion, param) = op2(op1(x1,x2),param) 

const _linear = Constraint(
    concept = concept_linear,
    error = make_error(:intension),
)

push!(BENCHED_CONSTRAINTS, :linear => _linear)

## all_different_except

concept_all_different_except(x, s) = allunique(filter(element -> element ∉ s , x))

const _all_different_except = Constraint(
    concept = concept_all_different_except,
    error = make_error(:all_different_except),
)

push!(BENCHED_CONSTRAINTS, :all_different_except => _all_different_except)


## strictly_increasing

concept_strictly_increasing(x; param=nothing) = issorted(x) && length(x) == length(Set(x))

const _strictly_increasing = Constraint(
    concept = concept_strictly_increasing,
    error = make_error(:strictly_increasing),
)

push!(BENCHED_CONSTRAINTS, :strictly_increasing => _strictly_increasing)

