%% Load data
load Cricket.mat

%%
% Initial and default values
lambda = 0.9;
mu0 = 1.5;
sigma_x = 1;
sigma_r = 0.2;
m = 0.4;
c = 0.6;

%% Get the data
i = 1;
RTSingle = cell2mat(RT(1:10));
SDSingle = cell2mat(SD(1:10));
xprev = SDSingle(1,:);
sd = SDSingle(2,:);
% rt = RTSingle(2,:);


%xprevi = normrnd(3, 2, 200, 1);
%sdi = normrnd(3, 2, 200, 1);

%xprev = xprevi(xprevi > 0 & sdi > 0 & xprevi < 4 & sdi < 4);
%sd = sdi(xprevi > 0 & sdi > 0 & xprevi < 4 & sdi < 4);

% xprev = xprev(rt > 0);
% sd = sd(rt > 0);
% rt = rt(rt > 0);





%%
% Mean of posterior distribution
xcurr = x_update(xprev, lambda, mu0);

%%
% Hazard rate
hr = normpdf(sd, xcurr, sigma_x) ./ (1 - normcdf(sd, xcurr, sigma_x));

% Negative log
neglogHR = -log(hr);

% Mean rt
mu_rt = neglogHR * m + c;


%% Sample from normal(mu_rt, sigma_r)
rt_sampled = normrnd(mu_rt, sigma_r);

%% Find log likelihood
likelihood = normpdf(rt_sampled, mu_rt, sigma_r);

%% Parameter fitting

noise = 0.2;
xvalmeans = [];
xvalstds = [];
i = 0;
for sample_size = 100:100:800
    i = i + 1;
    fprintf('Trying sample size %d...\n', sample_size);
    xvals = [];
    for j = 1:100
        idx = randsample(numel(xprev), sample_size);
        lambda_i = lambda + rand * noise;
        sigma_xi = sigma_x+ rand * noise;
        sigma_ri = sigma_r+ rand * noise;
        mi = m+ rand * noise;
        ci = c+ rand * noise;
        x0 = [lambda_i, sigma_xi, sigma_ri, mi, ci];
        x = fminsearch(@(x) optim_function(x, xprev(idx), rt_sampled(idx), sd(idx), mu0), x0);
        xvals(j,:) = x;
    end
    xvalmeans(i,:) = mean(xvals);
    xvalstds(i,:) = std(xvals);
end
% Log likelihood
%%
%L = sum(hr_log_likelihood(rt, mu_rt, sigma_r));

Lopt = -obs_log_likelihood(xprev, rt_sampled, sd, lambda, mu0, sigma_x, sigma_r, m, c);
Lfound = -obs_log_likelihood(xprev, rt_sampled, sd, 0.2, mu0, 0.98, sigma_r, m, c);

fprintf('Lopt = %.4f, Lfound = %.4f\n', Lopt, Lfound);

% L = obs_log_likelihood(xprev, rt, sd, lambda, mu0, sigma_x, sigma_r, m, c);
% disp(L)

%% Parameter fitting
x0 = [lambda, sigma_x, sigma_r, m, c];
options = optimset('PlotFcns',@optimplotfval);

xvals = [];
for i = 1:numel(RT)
    disp(i);
    RTSingle = RT{i};
    SDSingle = SD{i};
    xprev = SDSingle(1,:);
    sd = SDSingle(2,:);
    rt = RTSingle(2,:);

    xprev = xprev(rt > 0);
    sd = sd(rt > 0);
    rt = rt(rt > 0);
    x = fminsearch(@(x) optim_function(x, xprev, rt, sd, mu0), x0);
    xvals(i,:) = x;
end
    
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