%%@author Gabriela Vranou
% date: 05.10.2014

function [normTrainingData, normChallengeData]=normaliseData(trainingData, challengeData)
% Calculates the z-score of the datasets using the same mean and std
% acquired by the trainingData. The fields quality and type are not being
% normalised as they are labels and not chemical features of the data.

mu = mean(trainingData,1);
sigma = std(trainingData,1,1);
normTrainingData = (trainingData - repmat(mu,size(trainingData,1),1))./repmat(sigma,size(trainingData,1),1);
normTrainingData(:,12:13) = trainingData(:,12:13); % quality and type are not being normalised

%% normalise Challenge data with the same mean and standard deviation as derived from the training data
normChallengeData = (challengeData - repmat(mu,size(challengeData,1),1))./repmat(sigma,size(challengeData,1),1);
normChallengeData(:,12:13) = challengeData(:,12:13);

end