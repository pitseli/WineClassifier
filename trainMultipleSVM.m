% SVM OneVsAll: trainMultipleSVM
% author: Gavriela Vranou, 467614
% last edit: 17.11.2014

% Trains 7 different SVMs, one for each class with the provided kernel
% function and solver, and predicts the labels for training data,
% validation data and test data
function [Ynew,VYnew,TYnew]=trainMultipleSVM(kfunc,solver,X,Y,VX,VY,TX,TY)
trscore=-1*ones(size(X,1),7);
valscore=-1*ones(size(VX,1),7);
testscore=-1*ones(size(TX,1),7);

for ii=1:7
    % transforming the labels in order to be used on a binary classifier
    Y_all=double(Y==ii);
    
    svnmodel=modelSVM(X,Y_all,kfunc,solver);
    % training dataset
    [~, tmp] = predict(svnmodel,X);
    trscore(:,ii)=tmp(:,2);
    
    % validation dataset
    [~, tmp] = predict(svnmodel,VX);
    valscore(:,ii)=tmp(:,2);
    
    % test dataset
    [~, tmp] = predict(svnmodel,TX);
    testscore(:,ii)=tmp(:,2);
end
% classifies each observation on the class where the models reported
% highest score
[~,Ynew]=max(trscore,[],2);
[~,VYnew]=max(valscore,[],2);
[~,TYnew]=max(testscore,[],2);