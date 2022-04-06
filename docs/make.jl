using ConstraintLearning
using Documenter

DocMeta.setdocmeta!(ConstraintLearning, :DocTestSetup, :(using ConstraintLearning); recursive=true)

makedocs(;
    modules=[ConstraintLearning],
    authors="azzaare <jf@baffier.fr> and contributors",
    repo="https://github.com/JuliaConstraints/ConstraintLearning.jl/blob/{commit}{path}#{line}",
    sitename="ConstraintLearning.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaConstraints.github.io/ConstraintLearning.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaConstraints/ConstraintLearning.jl",
    devbranch="main",
)
