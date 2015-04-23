% SVM OneVsAll: performanceSVM 
% author: Gavriela Vranou, 467614
% last edit: 17.11.2014

% Given a trained model and 3 datasets, it predicts their labels
% and returns their scores.

function [Ynew,VYnew,TYnew, tscore, vscore, testScore]=performanceSVM(svmmodel,X,VX,TX)
% find how it performs on the training dataset
[Ynew, tscore] = predict(svmmodel,X);

% find how it performs on the validation dataset
[VYnew, vscore] = predict(svmmodel,VX);

% find how it performs on the validation dataset
[TYnew, testScore] = predict(svmmodel,TX);

end