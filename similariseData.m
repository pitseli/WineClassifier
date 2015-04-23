function [newTrainingData] =  similariseData(trainingData, challengeData, margin)
% Remove the points from the training data which are not in the same 
% multi-dimensional space as the challenge data. In essence one
% tries to create a more biased fit to the challenge data. 
%    - trainingData = the training data matrix
%    - challengeData = the challenge data matrix of similar size
%    - margin = factor defining the margin of the space (0.1 default) 


if nargin == 0;
    % Load data if not provided
    run importData.m
    trainingData = normTrainingData;
    challengeData = normChallengeData;
elseif nargin <= 2;
    margin = 0.1;
    % Remove last columns
end

% Find the observations
indices = ones(5000,1);
for i = 1:11;
    mi = min(challengeData(:,i))*1.1;
    ma = sum(max(challengeData(:,i))*0.9);
    for n = 1:5000;
        if ((mi > trainingData(n,i)) || (ma < trainingData(n,i)))
            indices(n) = 0;
        end
    end
end
fprintf('%d rows deleted\\n',length(trainingData)-sum(indices))

% Delete them
newTrainingData = trainingData(logical(indices),:);

end