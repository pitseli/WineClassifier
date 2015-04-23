%% Predicting quality (7 class) and type (2 class) with a NN
%   We try to find the neural network that best predicts
%   resp. quality and type of the validation set and then
%   output the results on the challenge dataset.

% Load data
clear
load('NEWdata_both_final')
X = trainingData(:,1:11);
Y_quality = trainingData(:,12);
Y_type = trainingData(:,13);

VX = validateData(:,1:11);
VY_quality = validateData(:,12);
VY_type = validateData(:,13);

CX = testData(:,1:11);
CY_quality = testData(:,12);
CY_type = testData(:,13);

%% Search for the optimum size
% Parameters
L = 2; % layers
N = 50; % nodes
fscore_quality = zeros(L,N);
fscore_type = zeros(L,N);
for l = 1:L
    h = zeros(1,l);
    for n = 1:N
        h = h .* 0 + n;
        
        % Initialise them
        net_quality = feedforwardnet(h);
        net_type = feedforwardnet(h);
        % Train them
        [net_quality,tr_quality] = train(net_quality,X',Y_quality');
        [net_type,tr_type] = train(net_type,X',Y_type');
        % Save performance
        P_quality = round(net_quality(VX'));
        P_type = round(net_type(VX'));
        % Performance
        stats_quality = confusionmatStats(VY_quality,P_quality);
        fscore_quality(l,n) = mean(stats_quality.Fscore);
        stats_type = confusionmatStats(VY_type,P_type);
        fscore_type(l,n) = mean(stats_type.Fscore);
    end
end
error_quality = 1-fscore_quality;
error_type = 1-fscore_type;

% Find the best
[val, l] = min(error_type);
[val2, l2] = min(error_quality);

[ans, n] = min(val); % type
n
l = l(n)
[ans, n2] = min(val2); % quality
n2
l2 = l2(n2)
    


%% Winning sizes
% Some initial performance

net_quality = feedforwardnet([n2 n2]);
net_type = feedforwardnet([n n]);
% Train them
net_quality = train(net_quality,X',Y_quality');
net_type = train(net_type,X',Y_type');

% Prediction of the challenge dataset
P_quality = net_quality(CX');
P_type = net_type(CX');
stats_type = confusionmatStats(CY_type,round(P_type'));
stats_type.Fscore
stats_quality = confusionmatStats(CY_quality,round(P_quality'));
stats_quality.Fscore
