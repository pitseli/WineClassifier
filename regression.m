%% Predicting quality (7 class) and type (2 class) with logistic regress
% Type:
%  We construct one classifier 
% Quality:
%  We construct a oneVSrestclassifier
%  that creates a logistic classifier for each class
%  and the final result takes the maximum

% Some parameters
clear % to reuse variable names
amount_of_qualities = 7;
amount_of_types = 2;

% Load the Data
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

% Create models for each class
Bq = cell(1,amount_of_qualities);
Bt = cell(1,amount_of_types);
for i = 1:amount_of_qualities;
   Bq(i) = {glmfit(X, (Y_quality == i), ...
       'binomial', 'link', 'logit')};
end
for i = 1:amount_of_types;
   Bt(i) = {glmfit(X, (Y_type == i-1), ...
       'binomial', 'link', 'logit')};
end

% Validation
P = zeros(1000,amount_of_qualities);
for i = 1:amount_of_qualities;
   P(:,i) = glmval(Bq{i}, VX, 'logit');
end
[~,I] = max(P,[],2); %  the indices of the highest prob = class

% Challenge set
P_type = zeros(1000,amount_of_types);
P_quality = zeros(1000,amount_of_qualities);
for i = 1:amount_of_qualities;
    P_quality(:,i) = glmval(Bq{i}, CX, 'logit');
end
for i = 1:amount_of_types;
    P_type(:,i) = glmval(Bt{i}, CX, 'logit');
end

[~,P_quality] = max(P_quality,[],2);
[~, P_type] = max(P_type,[],2);
P_type = P_type - 1;
stats_type = confusionmatStats(CY_type,P_type);
stats_type.Fscore
stats_quality = confusionmatStats(CY_quality,P_quality);
stats_quality.Fscore

