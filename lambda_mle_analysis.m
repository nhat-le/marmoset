%% Load data
load Cricket.mat

%% Get the data
RTSingle = cell2mat(RT(71:79));
SDSingle = cell2mat(SD(71:79));
xprev = SDSingle(1,:);
sd = SDSingle(2,:);
rt = RTSingle(2,:);

% Filter nagative reaction times
sd_filt = sd(rt > 0);
xprev_filt = xprev(rt > 0);
rt_filt = rt(rt > 0);

%% Parameter fitting
lambda0 = 0.5;
sigma_x0 = 1;
sigma_r0 = 0.3;
m0 = -0.5;
c0 = 1;
mu0 = 1.5;
Nbootstraps = 300;

x0 = [lambda0, sigma_x0, sigma_r0, m0, c0];

data = [xprev_filt; rt_filt; sd_filt];

bootstraps = get_bootstrap_samples(data, Nbootstraps);

%%
% Doing bootstrap
fit_params = nan(Nbootstraps, 5);
flags = nan(Nbootstraps, 1);
options = optimset('MaxFunEvals', 3000);

f = waitbar(0, 'Fitting...');
for i = 1:Nbootstraps
    waitbar(i / Nbootstraps, f, 'Fitting...');
    sample = bootstraps{i};
    [x, ~, exit] = ...
        fminsearch(@(x) optim_function(x, sample(1,:), sample(2,:), sample(3,:), mu0), ...
            x0, options);
    fit_params(i, :) = x;
    flags(i) = exit;
end

close(f);

    
function L = optim_function(x, xprev, rt, sd, mu0)
lambda = x(1);
sigma_x = x(2);
sigma_r = x(3);
m = x(4);
c = x(5);
L = -obs_log_likelihood(xprev, rt, sd, lambda, mu0, sigma_x, sigma_r, m, c);

end


function L = obs_log_likelihood(xprev, rt, sd, lambda, mu0, sigma_x, sigma_r, m, c)
% Mean of posterior distribution
xcurr = x_update(xprev, lambda, mu0);

% Hazard rate
hr = normpdf(sd, xcurr, sigma_x) ./ (1 - normcdf(sd, xcurr, sigma_x));

% Negative log
neglogHR = -log(hr);

% Mean rt
mu_rt = neglogHR * m + c;

% Log likelihood
L = sum(hr_log_likelihood(rt, mu_rt, sigma_r));
end


function L = hr_log_likelihood(rt, hr_mean, sigma_r)
L = log(normpdf(rt, hr_mean, sigma_r));
end


function xcurr = x_update(xprev, lambda, mu0)

xcurr = lambda * mu0 + (1 - lambda) * xprev;

end