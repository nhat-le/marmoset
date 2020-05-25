%% Load data
load Cricket.mat
late_exp_sessions = 70:79;
naive_sessions = 1:20;

naive_RTs = cell2mat(RT(naive_sessions));
lateexp_RTs = cell2mat(RT(late_exp_sessions));
naive_SDs = cell2mat(SD(naive_sessions));
lateexp_SDs = cell2mat(SD(late_exp_sessions));




%%
% Initial and default values
lambda = 0.2;
mu0 = 1.5;
sigma_x = 1;
sigma_r = 0.2;
m = 0.8;
c = 0;

%% Parameter fitting for pooled data
xvals = [];
pbar = ProgressBar(100, 'Updating...');
xvals = [];
options = optimset('PlotFcns',@optimplotfval);

epsilon = 0.01;
exitvals = [];
rng(123);
for j = 1:100
    pbar(j);
    x0 = [1+ rand * epsilon, 2+ rand * epsilon, 0.2+ rand * epsilon, 0+ rand * epsilon, 0.3+ rand * epsilon];
%     x0 = [lambda + rand * epsilon, ...
%         sigma_x+ rand * epsilon,...
%         sigma_r+ rand * epsilon,...
%         m + rand * epsilon,...
%         c+ rand * epsilon];
    options = optimset('PlotFcns',@optimplotfval);

    xprev = lateexp_SDs(1, lateexp_RTs(2,:) > 0);
    sd = lateexp_SDs(2, lateexp_RTs(2,:) > 0);
    rt = lateexp_RTs(2, lateexp_RTs(2,:) > 0);

    [x,f,exit] = fminsearch(@(x) optim_function(x, xprev, rt, sd, mu0), x0);
    xvals(j,:) = x;
    exitvals(j) = exit;
end

%%
% xvals = [];
% for i = 1:numel(RT)
%     disp(i);
%     RTSingle = RT{i};
%     SDSingle = SD{i};
%     xprev = SDSingle(1,:);
%     sd = SDSingle(2,:);
%     rt = RTSingle(2,:);
% 
%     xprev = xprev(rt > 0);
%     sd = sd(rt > 0);
%     rt = rt(rt > 0);
%     x = fminsearch(@(x) optim_function(x, xprev, rt, sd, mu0), x0);
%     xvals(i,:) = x;
% end
% 
% 
% %% Parameter fitting
% x0 = [lambda, sigma_x, sigma_r, m, c];
% options = optimset('PlotFcns',@optimplotfval);
% 
% xvals = [];
% for i = 1:numel(RT)
%     disp(i);
%     RTSingle = RT{i};
%     SDSingle = SD{i};
%     xprev = SDSingle(1,:);
%     sd = SDSingle(2,:);
%     rt = RTSingle(2,:);
% 
%     xprev = xprev(rt > 0);
%     sd = sd(rt > 0);
%     rt = rt(rt > 0);
%     x = fminsearch(@(x) optim_function(x, xprev, rt, sd, mu0), x0);
%     xvals(i,:) = x;
% end
    
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