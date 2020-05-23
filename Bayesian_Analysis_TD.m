%% Bayesian Analysis TD
load E_E.mat

%%
Alld;
Allrt;

N = size(Alld(1,:));
sd_previous = Alld(1,:);

% Mapping from reaction time to 'expected' stimulus duration 
x = Allrt(2,:); y = Alld(2,:); 
sd_expectedCurrent = zeros(N);
sd_estimatedCurrent = zeros(N);
blur = 0.1;
for i = 1:N(2)
    rt_current = x(i);
    indices = nonzeros(abs(x - rt_current) < blur);
    sd_estimated = mean(y(indices));
    %  0.5 expect + 0.5 exact = estimated
    sd_expectedCurrent(i) = 2*sd_estimated - y(i);
    sd_estimatedCurrent(i) = sd_estimated;
end

% figure;
% plot(y,sd_estimatedCurrent,'.');
% plot(y,sd_expectedCurrent,'.');
% ylabel('expected sd');
% xlabel('actual sd');
% box off
% axis tight
% axis square
% set(gca,'FontSize', 18);

%% Setting up the least-squares problem
b = sd_expectedCurrent - sd_previous;
A = ones(N(2),2);
A(:,2) = 1* sd_previous;
%% Solving it
X = inv(A'*A) *A' * b';
delta_opt = X(1);
lambda_opt = X(2);
%% Deriving the parameters
alpha_opt = lambda_opt/(1-lambda_opt);
mu_0_opt = delta_opt/lambda_opt;

%% Hazard Calculation
for k = 1:1
    
global PHI
PHI = 0.26;

%% Theoretical hazard rate
pmax = 2.5;
pmin = 0.5;
nbins = 5000;
dt = 3/nbins;
t = linspace(0, 10, nbins);

% alpha = 1;

%% Obtain updated density function / updated mean for gaussian 
d = (pmax - pmin)/1000;
x = [0.5:d:2.5];
% 
pdfC = (alpha_opt / (1+alpha_opt)) * mu_0_opt; % contribution of static mean to update
PriorC = (1 / (1+alpha_opt)) * Alld(1,:); % contribution of prior to update
Updatedmu = pdfC + PriorC; % calculate new gaussian mean
sigma = 1; % set at 1 for now until I add noise to stop sigma from shrinking with more priors.
% create new pdf's from updated means of gaussians.

for i = 1:numel(Updatedmu)
Updatedmu(i)
y = normpdf(x,Updatedmu(i),sigma);
%     figure; plot(y)
end 

%% Convert y to scaled probability %%


f = ones(1, numel(t)) * 0.5;
f(t < pmin | t > pmax) = 0;

% Hazard rate
h = 1 ./ (pmax - t);
h(t < pmin | t > pmax) = 0;

%% Subjective hazard rate
% Make a basis and convolve to get 'blurred' density
fs = zeros(1, length(t)); %subjective hazard array
for l = 1:numel(t)
    r = 1 / PHI / t(l) / sqrt(2*pi) * exp(-(t - t(l)).^2 / 2 / PHI^2 / t(l)^2);
    fs(l) = r * f' * dt;
end

% Normalize
fs = fs / (nansum(fs) * dt);

% Cumulative
fs_cum = cumsum(fs(2:end)) * dt;

%% Subjective hazard
hs = fs(2:end) ./ (1 - fs_cum);

tvals = t(2:end-1);
hsvals = hs(1:end-1);
maxhs = findpeaks(hsvals);
hsvals = hsvals ./ maxhs;

hr = interp1(tvals, hsvals, Alld(2,:));
end














