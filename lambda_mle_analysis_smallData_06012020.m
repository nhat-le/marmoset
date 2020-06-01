%% Load data
load CricketFilt.mat
load hazard_vals.mat

RT = RTFilt;
SD = SDFilt;

%% Get the data
partitions = 1:6:numel(RT);
splits = cell(1, numel(partitions));
for i = 1:numel(partitions)-1
    splits{i} = partitions(i) : partitions(i+1) - 1;
end
splits{end} = partitions(end) : numel(RT);

%% Parameter fitting
lambda0 = 0.5;
sigma_r0 = 0.3;
m0 = -0.5;
c0 = 1;
mu0 = 1.5;
Nbootstraps = 300;
x0D = [lambda0, sigma_r0, m0, c0];
x0S = [sigma_r0, m0, c0];

%% Perform the analysis for all splits...
params_static = cell(1, numel(splits));
flags_static = cell(1, numel(splits));
llvals_static = cell(1, numel(splits));

params_dynamic = cell(1, numel(splits));
flags_dynamic = cell(1, numel(splits));
llvals_dynamic = cell(1, numel(splits));

bootstraps_all = cell(1, numel(splits));

for i = 1:numel(splits)
    fprintf('Doing split %d of %d...\n', i, numel(splits));
    [bootstraps, paramsS, flagsS, llvalsS, paramsD, flagsD, llvalsD] = find_mle_bootstraps_static_dynamic(splits{i}, RT, SD, ...
        Nbootstraps, x0S, x0D, tvals, hsvals);
    bootstraps_all{i} = bootstraps;
    
    params_dynamic{i} = paramsD;
    flags_dynamic{i} = flagsD;
    llvals_dynamic{i} = llvalsD;
    
    params_static{i} = paramsS;
    flags_static{i} = flagsS;
    llvals_static{i} = llvalsS;
end

% save('mle_bootstraps_split6.mat', 'params_all', 'flags_all', 'splits');
save('mle_bootstraps_static_dynamic_sub_hazard_scaledd_filt06012020.mat', 'params_dynamic', 'flags_dynamic',...
    'llvals_dynamic', 'params_static', 'flags_static', 'llvals_static', 'splits', 'bootstraps_all');
%%
%xcurr = x_update(xprev_filt, 0.9, 1.5);

function [bootstraps, fit_paramsS, flagsS, llvalsS, fit_paramsD, flagsD, llvalsD] = find_mle_bootstraps_static_dynamic(split, rtdata, sddata, ...
    Nbootstraps, x0S, x0D, tvals, hsvals)
rng(123)
RTSingle = cell2mat(rtdata(split));
SDSingle = cell2mat(sddata(split));
xprev = SDSingle(1,:);
sd = SDSingle(2,:);
rt = RTSingle(2,:);

% Filter nagative reaction times
sd_filt = sd(rt > 0);
xprev_filt = xprev(rt > 0);
rt_filt = rt(rt > 0);

% Scale xprev and sd
% sdmin = min([sd_filt xprev_filt]);
% sdmax = max([sd_filt xprev_filt]);
% Scale the range of stimulus durations to 0.5 to 2.5
% slope = 2 / (sdmax - sdmin);
% intercept = 2.5 - slope * sdmax;
% sd_filt = sd_filt * slope + intercept;
% xprev_filt = xprev_filt * slope + intercept;

data = [xprev_filt; rt_filt; sd_filt];


bootstraps = get_bootstrap_samples(data, Nbootstraps);

%%
% Doing bootstrap
fit_paramsS = nan(Nbootstraps, 3);
flagsS = nan(Nbootstraps, 1);
llvalsS = nan(Nbootstraps, 1); % log-likelihood

fit_paramsD = nan(Nbootstraps, 4);
flagsD = nan(Nbootstraps, 1);
llvalsD = nan(Nbootstraps, 1); % log-likelihood

options = optimset('MaxFunEvals', 3000);

f = waitbar(0, 'Fitting...');
for i = 1:Nbootstraps
    waitbar(i / Nbootstraps, f, 'Fitting...');
    sample = bootstraps{i};
    
    mu0 = 1.5; %median(sample(3,:));
    fprintf('mu0 = %.2f\n', mu0);
    optim_function(x0D, sample(1,:), sample(2,:), sample(3,:), mu0, tvals, hsvals);
    [xs, fvals, exits] = ...
        fminsearch(@(x) optim_function_static(x, sample(1,:), sample(2,:), sample(3,:), mu0, tvals, hsvals), ...
            x0S, options);
    
    [xd, fvald, exitd] = ...
        fminsearch(@(x) optim_function(x, sample(1,:), sample(2,:), sample(3,:), mu0, tvals, hsvals), ...
            x0D, options);

    fit_paramsS(i, :) = xs;
    flagsS(i) = exits;
    llvalsS(i) = -fvals;
    
    fit_paramsD(i, :) = xd;
    flagsD(i) = exitd;
    llvalsD(i) = -fvald;
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
options = optimset('MaxFunEvals', 3000, 'PlotFcns',@optimplotfval);

f = waitbar(0, 'Fitting...');
for i = 1:Nbootstraps
    waitbar(i / Nbootstraps, f, 'Fitting...');
    sample = bootstraps{i};
    if static
        [x, fval, exit] = ...
            fminsearch(@(x) optim_function_static(x, sample(1,:), sample(2,:), sample(3,:), mu0, tvals, hsvals), ...
                x0, options);
    else
        [x, fval, exit] = ...
            fminsearch(@(x) optim_function(x, sample(1,:), sample(2,:), sample(3,:), mu0, tvals, hsvals), ...
                x0, options);
    end
    fit_params(i, :) = x;
    flags(i) = exit;
    llvals(i) = -fval;
end

close(f);


end


function L = optim_function_static(x, xprev, rt, sd, mu0, tvals, hsvals)
lambda = 1;
sigma_r = x(1);
m = x(2);
c = x(3);
L = -obs_log_likelihood(xprev, rt, sd, lambda, mu0, sigma_r, m, c, tvals, hsvals);

end


    
function L = optim_function(x, xprev, rt, sd, mu0, tvals, hsvals)
lambda = x(1);
sigma_r = x(2);
m = x(3);
c = x(4);
L = -obs_log_likelihood(xprev, rt, sd, lambda, mu0, sigma_r, m, c, tvals, hsvals);

end


function L = obs_log_likelihood(xprev, rt, sd, lambda, mu0, sigma_r, m, c, tvals, hsvals)
% Mean of posterior distribution
xcurr = x_update(xprev, lambda, mu0);

% Hazard rate
%hr = normpdf(sd, xcurr, sigma_x) ./ (1 - normcdf(sd, xcurr, sigma_x));
hr = interp1(tvals, hsvals, sd + 1.5 - xcurr);
% for i = 1:numel(sd)
%     hr(i) = interp1(tvals - 1.5 + xcurr(i), hsvals, sd(i), [], 1e-10);
% end

hr = max(hr, 1e-10);

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

xcurr = (1-lambda) * mu0 + lambda * xprev;

end