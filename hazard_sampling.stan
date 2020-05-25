functions {
	real truncated_normal_rng(real mu, real sigma, real lb) {
	  real p_lb = normal_cdf(lb, mu, sigma);
	  real u = uniform_rng(p_lb, 1);
	  real y = mu + sigma * inv_Phi(u);
	  //print(p_lb, u, y);
	  return y;
	}
}

data {
	int N;
	vector[N] stimdur;
	vector[N] xprev;
	real mu0;
}


generated quantities {
	//Parameters
	real<lower=0, upper=1> lambda;
	real m;
	real c;
	real<lower=0> sigma_x;
	real<lower=0> sigma_r;
	//real<lower=0> sigma_0;
	

	// Data
	real r[N];
	vector[N] xc;
	vector[N] hazard_numerator;
	vector[N] hazard_denominator;
	vector[N] hazard;
	vector[N] rmean;
	
	lambda = beta_rng(1.1, 1.1);
	m = normal_rng(0, 1);
	c = normal_rng(0, 1);
	//sigma_x = truncated_normal_rng(0, 1, 0);
	//sigma_r = truncated_normal_rng(0, 1, 0);
	sigma_x = lognormal_rng(log(1), 2); 
	sigma_r = lognormal_rng(log(0.3), 1);
	//sigma_0 = gamma_rng(3, 10);
	//sigma_r = sigma_0 * abs(c);
	
	
	
	xc = lambda * mu0 + (1 - lambda) * xprev;
	
	
	for (n in 1:N) {
		hazard_numerator[n] = normal_lpdf(stimdur[n] | xc[n], sigma_x);
		hazard_denominator[n] = log(1 - normal_cdf(stimdur[n], xc[n], sigma_x));
		//print(stimdur[n], " ", xc[n], " ", sigma_x);
		hazard[n] = - hazard_numerator[n] + hazard_denominator[n];
		rmean[n] = hazard[n] * m + c;
		r[n] = normal_rng(rmean[n], sigma_r);
	}
}
