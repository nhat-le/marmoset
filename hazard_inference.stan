functions {
	real truncated_normal_rng(real mu, real sigma, real lb) {
	  real p_lb = normal_cdf(lb, mu, sigma);
	  real u = uniform_rng(p_lb, 1);
	  real y = mu + sigma * inv_Phi(u);
	  //print(p_lb, u, y);
	  return y;
	}
	
	vector[] test(vector[] input) {
		return input;
	}
}

data {
	int N;
	vector[N] stimdur;
	vector[N] xprev;
	vector[N] rt;
	//vector[N] stimdur_pcc;
	//vector[N] xprev_pcc;
	
	real mu0;
}

parameters {
	real<lower=0, upper=1> lambda;
	real m;
	real c;
	real<lower=0> sigma_x;
	real<lower=0> sigma_r;
	//real<lower=0> sigma_0;
}

transformed parameters {
	vector[N] xc = lambda * mu0 + (1 - lambda) * xprev;
	vector[N] hazard_numerator;
	vector[N] hazard_denominator;
	vector[N] hazard;
	vector[N] rmean;
	
	for (n in 1:N) {
		hazard_numerator[n] = normal_lpdf(stimdur[n] | xc[n], sigma_x);
		hazard_denominator[n] = log(1 - normal_cdf(stimdur[n], xc[n], sigma_x));
			//print(stimdur[n], " ", xc[n], " ", sigma_x);
		hazard[n] = - hazard_numerator[n] + hazard_denominator[n];
		rmean[n] = hazard[n] * m + c;
	}
}


model {
	// Priors
	lambda ~ beta(1.1, 1.1);
	m ~ normal(0, 1);
	c ~ normal(0, 1);
	sigma_x ~ lognormal(log(1), 2); 
	sigma_r ~ lognormal(log(0.3), 1);
	rt ~ normal(rmean, sigma_r);
}


