% For MLE bootstrap analysis
% Nhat Le, 05.27.2020

%% Load results
load mle_bootstraps.mat
figure;
lambda_arr = zeros(1, 8);
lowers = zeros(1, 8);
uppers = zeros(1, 8);
lambda_cell = cell(1, 8);
for i = 1:8
    flags = flags_all{i};
    params = params_all{i};

    % Params for which flags = 0
    flags1 = flags(flags == 1, :);
    params1 = params(flags == 1, :);
    flags0 = flags(flags == 0, :);
    params0 = params(flags == 0, :);
    params2 = params(params(:, 1) >= 0 & params(:, 1) <= 2 & ...
        params(:, 2) >= 1 & params(:, 2) <= 3, :);


    lambdas = params1(:, 1);
    good_lambdas = lambdas(lambdas >= 0 & lambdas <= 1.1);
    lambda_cell{i} = good_lambdas;
    lambda_arr(i) = median(good_lambdas);
    lowers(i) = prctile(good_lambdas, 5);
    uppers(i) = prctile(good_lambdas, 95);
    % Scatter
    subplot(2, 4, i);
    scatter(params1(:, 1), params1(:, 2), 'b');
end

figure;
errorbar(1:8, lambda_arr, lambda_arr - lowers);
%hold on
%scatter(params0(:, 1), params0(:, 3), 'r');
%scatter(params2(:, 1), params2(:, 2), 'k');





%% Analyze lambda...
medians = nan(1, numel(splits));
means = nan(1, numel(splits));
stds = nan(1, numel(splits));
lowers = nan(1, numel(splits));
uppers = nan(1, numel(splits));
for i = 1:numel(splits)
    param_single = params_all{i};
    lambdas = param_single(:,4);
    %lambdas = lambdas(lambdas < 1 & lambdas > 0);
    lamb_median = median(lambdas);
    lamb_mean = mean(lambdas);
    lamb_std = std(lambdas);
    
    %5 and 95 percentiles
    lamb_lower = prctile(lambdas, 5);
    lamb_upper = prctile(lambdas, 95);
    
    medians(i) = lamb_median;
    lowers(i) = lamb_lower;
    uppers(i) = lamb_upper;
    means(i) = lamb_mean;
    stds(i) = lamb_std;
    
end

plot(medians)
hold on
plot(lowers)
plot(uppers)
%errorbar(1:numel(splits), means, stds);