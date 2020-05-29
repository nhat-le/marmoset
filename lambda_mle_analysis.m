%% Load data
load Cricket.mat

%% Get the data
RTSingle = cell2mat(RT(1:10));
SDSingle = cell2mat(SD(1:10));
xprev = SDSingle(1,:);
sd = SDSingle(2,:);
rt = RTSingle(2,:);

partitions = 1:10:numel(RT);
splits = cell(1, numel(partitions));
for i = 1:numel(partitions)-1
    splits{i} = partitions(i) : partitions(i+1) - 1;
end
splits{end} = partitions(end) : numel(RT);



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
%% Perform the analysis for all splits...
params_static = cell(1, numel(splits));
flags_static = cell(1, numel(splits));
llvals_static = cell(1, numel(splits));

params_dynamic = cell(1, numel(splits));
flags_dynamic = cell(1, numel(splits));
llvals_dynamic = cell(1, numel(splits));

for i = 1:numel(splits)
    fprintf('Doing split %d of %d...\n', i, numel(splits));
    [params, flags, llvals] = find_mle_bootstraps(splits{i}, RT, SD, Nbootstraps, x0, mu0, 0);
    params_dynamic{i} = params;
    flags_dynamic{i} = flags;
    llvals_dynamic{i} = llvals;
    
    [params, flags, llvals] = find_mle_bootstraps(splits{i}, RT, SD, Nbootstraps, x0, mu0, 1);
    params_static{i} = params;
    flags_static{i} = flags;
    llvals_static{i} = llvals;
end

% save('mle_bootstraps_split6.mat', 'params_all', 'flags_all', 'splits');
save('mle_bootstraps_static_dynamic.mat', 'params_dynamic', 'flags_dynamic',...
    'llvals_dynamic', 'params_static', 'flags_static', 'llvals_static', 'splits');
%%
params_all = cell(1, numel(splits));
flags_all = cell(1, numel(splits));
for i = 2
    fprintf('Doing split %d of %d...\n', i, numel(splits));
    [params, flags, llvals] = find_mle_bootstraps(splits{i}, RT, SD, Nbootstraps, x0, mu0, 0);
    params_all{i} = params;
    flags_all{i} = flags;
end



function [fit_params, flags, llvals] = find_mle_bootstraps_static_dynamic(split, rtdata, sddata, ...
    Nbootstraps, x0, mu0, static)
RTSingle = cell2mat(rtdata(split));
SDSingle = cell2mat(sddata(split));
xprev = SDSingle(1,:);
sd = SDSingle(2,:);
rt = RTSingle(2,:);

% Filter nagative reaction times
sd_filt = sd(rt > 0);
xprev_filt = xprev(rt > 0);
rt_filt = rt(rt > 0);

data = [xprev_filt; rt_filt; sd_filt];

bootstraps = get_bootstrap_samples(data, Nbootstraps);

%%
% Doing bootstrap
fit_paramsS = nan(Nbootstraps, 5);
flagsS = nan(Nbootstraps, 1);
llvalsS = nan(Nbootstraps, 1); % log-likelihood

fit_paramsD = nan(Nbootstraps, 5);
flagsD = nan(Nbootstraps, 1);
llvalsD = nan(Nbootstraps, 1); % log-likelihood

options = optimset('MaxFunEvals', 3000);

f = waitbar(0, 'Fitting...');
for i = 1:Nbootstraps
    waitbar(i / Nbootstraps, f, 'Fitting...');
    sample = bootstraps{i};
    
    [xs, fvals, exits] = ...
        fminsearch(@(x) optim_function_static(x, sample(1,:), sample(2,:), sample(3,:), mu0), ...
            x0, options);
    
    [xd, fvald, exitd] = ...
        fminsearch(@(x) optim_function(x, sample(1,:), sample(2,:), sample(3,:), mu0), ...
            x0, options);

    fit_paramsS(i, :) = xs;
    flagsS(i) = exits;
    llvalsS(i) = -fvals;
    
    fit_paramsD(i, :) = xs;
    flagsD(i) = exits;
    llvalsD(i) = -fvals;
end

close(f);


end









function [fit_params, flags, llvals] = find_mle_bootstraps(split, rtdata, sddata, ...
    Nbootstraps, x0, mu0, static)
RTSingle = cell2mat(rtdata(split));
SDSingle = cell2mat(sddata(split));
xprev = SDSingle(1,:);
sd = SDSingle(2,:);
rt = RTSingle(2,:);

% Filter nagative reaction times
sd_filt = sd(rt > 0);
xprev_filt = xprev(rt > 0);
rt_filt = rt(rt > 0);

data = [xprev_filt; rt_filt; sd_filt];

bootstraps = get_bootstrap_samples(data, Nbootstraps);

%%
% Doing bootstrap
fit_params = nan(Nbootstraps, 5);
flags = nan(Nbootstraps, 1);
llvals = nan(Nbootstraps, 1); % log-likelihood
options = optimset('MaxFunEvals', 3000);

f = waitbar(0, 'Fitting...');
for i = 1:Nbootstraps
    waitbar(i / Nbootstraps, f, 'Fitting...');
    sample = bootstraps{i};
    if static
        [x, fval, exit] = ...
            fminsearch(@(x) optim_function_static(x, sample(1,:), sample(2,:), sample(3,:), mu0), ...
                x0, options);
    else
        [x, fval, exit] = ...
            fminsearch(@(x) optim_function(x, sample(1,:), sample(2,:), sample(3,:), mu0), ...
                x0, options);
    end
    fit_params(i, :) = x;
    flags(i) = exit;
    llvals(i) = -fval;
end

close(f);


end


function L = optim_function_static(x, xprev, rt, sd, mu0)
lambda = 1;
sigma_x = x(2);
sigma_r = x(3);
m = x(4);
c = x(5);
L = -obs_log_likelihood(xprev, rt, sd, lambda, mu0, sigma_x, sigma_r, m, c);

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