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
	
	// Data
	real r[N];
	vector[N] xc;
	vector[N] hazard_numerator;
	vector[N] hazard_denominator;
	vector[N] hazard;
	vector[N] rmean;
	
	xc = lambda * mu0 + (1 - lambda) * xprev;
	
	
	for (n in 1:N) {
		hazard_numerator[n] = normal_lpdf(stimdur[n] | xc[n], sigma_x);
		hazard_denominator[n] = log(1 - normal_cdf(stimdur[n], xc[n], sigma_x));
		hazard[n] = - hazard_numerator[n] + hazard_denominator[n];
		rmean[n] = hazard[n] * m + c;
		r[n] = normal_rng(rmean[n], sigma_r);
	}
}