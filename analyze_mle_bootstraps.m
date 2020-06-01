% For MLE bootstrap analysis
% Nhat Le, 05.27.2020

%% Load results
load mle_bootstraps_static_dynamic_sub_hazard_scaledc_filt06012020.mat
Nsess = numel(splits);
figure;
hold on;
lambda_arr = zeros(1, Nsess);
lowers = zeros(1, Nsess);
uppers = zeros(1, Nsess);
lambda_cell = cell(1, Nsess);


for i = 1:Nsess
    flags = flags_dynamic{i};
    params = params_dynamic{i};

    % Params for which flags = 0
    flags1 = flags(flags == 1, :);
    params1 = params(flags == 1, :);
    flags0 = flags(flags == 0, :);
    params0 = params(flags == 0, :);
    params2 = params(params(:, 1) >= 0 & params(:, 1) <= 2 & ...
        params(:, 2) >= 1 & params(:, 2) <= 3, :);


    lambdas = params1(:, 1);
    good_lambdas = lambdas; %(lambdas >= 0 & lambdas <= 1.1);
    lambda_cell{i} = good_lambdas;
    lambda_arr(i) = median(good_lambdas);
    lambda_std(i) = std(good_lambdas);
    lowers(i) = prctile(good_lambdas, 5);
    uppers(i) = prctile(good_lambdas, 95);
    
    scatter(ones(1, numel(lambdas)) * i, lambdas);
    % Scatter
%     subplot(2, 4, i);
%     scatter(params1(:, 1), params1(:, 2), 'b');
end

errorbar(1:Nsess, lambda_arr, lambda_arr - lowers);
%hold on
%scatter(params0(:, 1), params0(:, 3), 'r');
%scatter(params2(:, 1), params2(:, 2), 'k');

%%
load mle_bootstraps_static_dynamic_sub_hazard_scaledc_filt06012020.mat
llmean_static = [];
llmean_dynamic = [];
figure;
hold on;
for i = 1:numel(llvals_static)
    llvalStatic = llvals_static{i};
    llvalDynamic = llvals_dynamic{i};
    flagStatic = flags_static{i};
    flagDynamic = flags_dynamic{i};
    
    llvalStatic = llvalStatic(flagStatic == 1 & flagDynamic == 1);
    llvalDynamic = llvalDynamic(flagStatic == 1 & flagDynamic == 1);
    llmean_static(i) = mean(llvalStatic);
    llmean_dynamic(i) = mean(llvalDynamic);
    scatter(ones(1, numel(llvalDynamic)) * i, llvalStatic - llvalDynamic);
    
end



%%
llvalStatic = llvals_static{2};
llvalDynamic = llvals_dynamic{2};








%% Analyze lambda...
medians = nan(1, numel(splits));
means = nan(1, numel(splits));
stds = nan(1, numel(splits));
lowers = nan(1, numel(splits));
uppers = nan(1, numel(splits));
for i = 1:numel(splits)
    param_single = params_dynamic{i};
    lambdas = param_single(:,1);
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