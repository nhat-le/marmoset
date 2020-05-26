function samples = get_bootstrap_samples(data, Nsamples)
% data: M features x N data points
% Returns: an Nsamples cell array, each with M features x N data points

samples = cell(Nsamples, 1);
N = size(data, 2);
for i = 1:Nsamples
    idx = randsample(N, N, true);
    samples{i} = data(:, idx);    
end