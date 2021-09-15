# This files stores constraints or concepts that are not yet available within usual_constraints

# Sample for all_different
# const all_different = Constraint(
#     concept = concept_all_different,
#     error = make_error(:all_different),
#     syms = Set([:permutable]),
# )

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


## Minimum
concept_minimum(x; param) = minimum(x) < param

const _minimum = Constraint(
    concept = concept_no_overlap,
    error = make_error(:minimum),
)

push!(BENCHED_CONSTRAINTS, :minimum => _minimum)
