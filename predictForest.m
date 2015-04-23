% Random Forest: predictForest
% author: Gavriela Vranou, 467614
% last edit: 17.11.2014

% Given a trained TreeBagger object B, and pairs of observations X with their true respective labels Y
% it returns the estimated labels and statistics as created by the confusionmatStats.m

function [Ynew, stats]=predictForest(B,X,Y)
% [Estimated, score, stdevs]=predict(B,X) but the scores and stdevs are not currently used
[Ynew,~,~] = predict(B,X);
if strcmp(B.Method,'classification')
    Ynew=str2num(cell2mat(Ynew));
else
    Ynew=round(Ynew); % round the prediction to the closest integer
end
stats=confusionmatStats(Y,Ynew);
end