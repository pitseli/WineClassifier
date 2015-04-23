%%@author Gabriela Vranou
% date: 12.11.2014

% File does the exact same thing as importData, adjusted for the new test
% dataset, as challenge dataset changed: no id field, and type/quality have
% actual values now.

%% Import data from text file.
% Initialize variables.

filename = 'data_training_original.csv';
trainingData = importTrainingFile(filename);

filename = 'data_test_original.csv';
testData = importTrainingFile(filename);

%% Normalise data in [-1,1] using z-score. quality and type won't be altered
[normTrainingData, normTestData]=normaliseData(trainingData, testData);
save('NEWdata_both_normalised', 'normTrainingData', 'normTestData');

%% fit to space
fitTrainingData = similariseData(normTrainingData, normTestData);
save('NEWdata_both_fitted', 'fitTrainingData', 'normTestData');

%% Permute for validation
testData = normTestData;

size_validate = 1000;
p = randperm(length(fitTrainingData));
trainingData = fitTrainingData(p(size_validate:end),:);
validateData = fitTrainingData(p(1:size_validate),:); 

% create name array
namesData = {'fixedAcidity','volatileAcidity','citricAcid',...
        'residualSugar','chlorides','freeSulfurDioxide',...
        'totalSulfurDioxide','density','pH','sulphates',...
        'alcohol','quality','type'};

save('NEWdata_both_final', 'validateData', 'namesData', 'trainingData', 'testData');
%
clear
load('NEWdata_both_final')