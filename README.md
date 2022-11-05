# ConstraintLearning

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaConstraints.github.io/ConstraintLearning.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaConstraints.github.io/ConstraintLearning.jl/dev)
[![Build Status](https://github.com/JuliaConstraints/ConstraintLearning.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaConstraints/ConstraintLearning.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaConstraints/ConstraintLearning.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaConstraints/ConstraintLearning.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)
[![PkgEval](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/C/ConstraintLearning.svg)](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/report.html)



This code base is using the Julia Language and [DrWatson](https://juliadynamics.github.io/DrWatson.jl/stable/) to make a reproducible scientific project named
> ConstraintLearning

The code regarding Interpretable Compositional Networks (ICN) is authored by Jean-François BAFFIER, Khalil CHRIT, Florian RICHOUX, Pedro PATINHO, Salvador ABREU.

The code regarding Interpretable Compositional Networks (ICN) is authored by Jean-François BAFFIER, Florian RICHOUX, Philippe CODOGNET.

To (locally) reproduce this project, do the following:

0. Download this code base. Notice that raw data are typically not included in the
   git-history and may need to be downloaded independently.
1. Open a Julia console and do:
   ```julia
   julia> using Pkg
   julia> Pkg.add("DrWatson") # install globally, for using `quickactivate`
   julia> Pkg.activate("path/to/this/project")
   julia> Pkg.instantiate()
   ```

This will install all necessary packages for you to be able to run the scripts and
everything should work out of the box, including correctly finding local paths.

## Citing

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).
