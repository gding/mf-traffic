def mc_mpc_controller(g,x,horizon=30/0.1,time_step=0.1, num_runs=100):
	"""
	Find a "good" control input using a hybrid Monte Carlo / model predictive control approach

	Runs simulations and returns the first input of the run with the lowest cost

	horizon: forward simulation horizon. Equal to nb_iteration - current iteration

	num_runs: number of Monte Carlo simulations to run. Roughly proportional to
			  the amount of time there is to compute a control input.
	"""

    def random_controller(g,x):
    	"""
		Pick a random control input. Not generalized (for now?)
    	"""
    	matrix = g.get_adj_matrix()
    	u1 = np.random.random()
    	u2 = np.random.random()
    	matrix[0][1] = 1 - u1
    	matrix[0][2] = u1
	matrix[1][3] = 1 - u2
	matrix[1][4] = u2
	return matrix

    min_cost = np.inf
    good_u = None

    for _ in range(num_runs)
    	# maybe we want simulation_one_player to return (x,u)
        f_mc = g.simulation_one_player(x, horizon, time_step, random_controller, [6])
    	run_cost = get_cost(f_mc)

    	# if we've found a better trajectory...
    	if run_cost < min_cost
            # find the control input at the first iteratoin
            good_u = None
            # TODO. If input is returned as discussed in line 30 above, good_u = u[0,:,:] or something like that 
            min_cost = run_cost

	return good_u
