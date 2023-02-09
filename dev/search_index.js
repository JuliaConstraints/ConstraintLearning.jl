var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = ConstraintLearning","category":"page"},{"location":"#ConstraintLearning","page":"Home","title":"ConstraintLearning","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for ConstraintLearning.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [ConstraintLearning]","category":"page"},{"location":"#ConstraintLearning.ICNConfig","page":"Home","title":"ConstraintLearning.ICNConfig","text":"struct ICNConfig{O <: ICNOptimizer}\n\nA structure to hold the metric and optimizer configurations used in learning the weigths of an ICN.\n\n\n\n\n\n","category":"type"},{"location":"#ConstraintLearning.ICNConfig-Tuple{}","page":"Home","title":"ConstraintLearning.ICNConfig","text":"ICNConfig(; metric = :hamming, optimizer = ICNGeneticOptimizer())\n\nConstructor for ICNConfig. Defaults to hamming metric using a genetic algorithm.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.ICNGeneticOptimizer-Tuple{}","page":"Home","title":"ConstraintLearning.ICNGeneticOptimizer","text":"ICNGeneticOptimizer(; kargs...)\n\nDefault constructor to learn an ICN through a Genetic Algorithm. Default kargs TBW.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.ICNLocalSearchOptimizer","page":"Home","title":"ConstraintLearning.ICNLocalSearchOptimizer","text":"ICNLocalSearchOptimizer(options = LocalSearchSolvers.Options())\n\nDefault constructor to learn an ICN through a CBLS solver.\n\n\n\n\n\n","category":"type"},{"location":"#ConstraintLearning.ICNOptimizer","page":"Home","title":"ConstraintLearning.ICNOptimizer","text":"const ICNOptimizer = CompositionalNetworks.AbstractOptimizer\n\nAn abstract type for optmizers defined to learn ICNs.\n\n\n\n\n\n","category":"type"},{"location":"#ConstraintLearning.QUBOGradientOptimizer-Tuple{}","page":"Home","title":"ConstraintLearning.QUBOGradientOptimizer","text":"QUBOGradientOptimizer(; kargs...)\n\nA QUBO optimizer based on gradient descent. Defaults TBW\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.QUBOOptimizer","page":"Home","title":"ConstraintLearning.QUBOOptimizer","text":"const QUBOOptimizer = QUBOConstraints.AbstractOptimizer\n\nAn abstract type for optimizers used to learn QUBO matrices from constraints.\n\n\n\n\n\n","category":"type"},{"location":"#CompositionalNetworks.optimize!-Tuple{Any, Any, Any, Any, Any, ICNGeneticOptimizer}","page":"Home","title":"CompositionalNetworks.optimize!","text":"CompositionalNetworks.optimize!(icn, solutions, non_sltns, dom_size, metric, optimizer::ICNGeneticOptimizer; parameters...)\n\nExtends the optimize! method to ICNGeneticOptimizer.\n\n\n\n\n\n","category":"method"},{"location":"#CompositionalNetworks.optimize!-Tuple{Any, Any, Any, Any, Any, ICNLocalSearchOptimizer}","page":"Home","title":"CompositionalNetworks.optimize!","text":"CompositionalNetworks.optimize!(icn, solutions, non_sltns, dom_size, metric, optimizer::ICNLocalSearchOptimizer; parameters...)\n\nExtends the optimize! method to ICNLocalSearchOptimizer.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning._optimize!-NTuple{7, Any}","page":"Home","title":"ConstraintLearning._optimize!","text":"_optimize!(icn, X, X_sols; metric = hamming, pop_size = 200)\n\nOptimize and set the weigths of an ICN with a given set of configuration X and solutions X_sols.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.domain_size-Tuple{Number}","page":"Home","title":"ConstraintLearning.domain_size","text":"domain_size(ds::Number)\n\nExtends the domain_size function when ds is number (for dispatch purposes).\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.generate_population-Tuple{Any, Any}","page":"Home","title":"ConstraintLearning.generate_population","text":"generate_population(icn, pop_size\n\nGenerate a pôpulation of weigths (individuals) for the genetic algorithm weigthing icn.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.icn-Tuple{Any, Any}","page":"Home","title":"ConstraintLearning.icn","text":"icn(X,X̅; kargs..., parameters...)\n\nTBW\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.loss-Tuple{Any, Any, Any}","page":"Home","title":"ConstraintLearning.loss","text":"loss(x, y, Q)\n\nLoss of the prediction given by Q, a training set y, and a given configuration x.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.make_df-NTuple{5, Any}","page":"Home","title":"ConstraintLearning.make_df","text":"make_df(X, Q, penalty, binarization, domains)\n\nDataFrame arrangement to ouput some basic evaluation of a matrix Q.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.make_set_penalty-Tuple{Any, Any}","page":"Home","title":"ConstraintLearning.make_set_penalty","text":"make_set_penalty(X, X̅, args...; kargs)\n\nReturn a penalty function when the training set is already split into a pair of solutions X and non solutions X̅.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.make_training_sets-NTuple{4, Any}","page":"Home","title":"ConstraintLearning.make_training_sets","text":"make_training_sets(X, penalty, args...)\n\nReturn a pair of solutions and non solutions sets based on X and penalty.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.mutually_exclusive-Tuple{Any, Any}","page":"Home","title":"ConstraintLearning.mutually_exclusive","text":"mutually_exclusive(layer, w)\n\nConstraint ensuring that w encode exclusive operations in layer.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.no_empty_layer-Tuple{Any}","page":"Home","title":"ConstraintLearning.no_empty_layer","text":"no_empty_layer(x; X = nothing)\n\nConstraint ensuring that at least one operation is selected.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.optimize!-NTuple{8, Any}","page":"Home","title":"ConstraintLearning.optimize!","text":"optimize!(icn, X, X_sols, global_iter, local_iter; metric=hamming, popSize=100)\n\nOptimize and set the weigths of an ICN with a given set of configuration X and solutions X_sols. The best weigths among global_iter will be set.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.parameter_specific_operations-Tuple{Any}","page":"Home","title":"ConstraintLearning.parameter_specific_operations","text":"parameter_specific_operations(x; X = nothing)\n\nConstraint ensuring that at least one operation related to parameters is selected if the error function to be learned is parametric.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.predict-Tuple{Any, Any}","page":"Home","title":"ConstraintLearning.predict","text":"predict(x, Q)\n\nReturn the predictions given by Q for a given configuration x.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.preliminaries-Tuple{Any, Any, Any}","page":"Home","title":"ConstraintLearning.preliminaries","text":"preliminaries(args)\n\nPreliminaries to the training process in a QUBOGradientOptimizer run.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.qubo","page":"Home","title":"ConstraintLearning.qubo","text":"qubo(X,X̅; kargs..., parameters...)\n\nTBW\n\n\n\n\n\n","category":"function"},{"location":"#ConstraintLearning.sub_eltype-Tuple{Any}","page":"Home","title":"ConstraintLearning.sub_eltype","text":"sub_eltype(X)\n\nReturn the element type of of the first element of a collection.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.train!-NTuple{9, Any}","page":"Home","title":"ConstraintLearning.train!","text":"train!(Q, X, penalty, η, precision, X_test, oversampling, binarization, domains)\n\nTraining inner method.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.train-Union{Tuple{D}, Tuple{Any, Any, Vector{D}}} where D<:ConstraintDomains.DiscreteDomain","page":"Home","title":"ConstraintLearning.train","text":"train(X, penalty[, d]; optimizer = QUBOGradientOptimizer(), X_test = X)\n\nLearn a QUBO matrix on training set X for a constraint defined by penalty with optional domain information d. By default, it uses a QUBOGradientOptimizer and X as a testing set.\n\n\n\n\n\n","category":"method"},{"location":"#ConstraintLearning.δ-Tuple{Any}","page":"Home","title":"ConstraintLearning.δ","text":"δ(X[, Y]; discrete = true)\n\nCompute the extrema over a collection Xor a pair of collection(X, Y)`.\n\n\n\n\n\n","category":"method"}]
}
