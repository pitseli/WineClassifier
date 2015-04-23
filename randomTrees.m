%% Random Forest
% author: Gavriela Vranou
% last edit: 16.11.2014

clear;clc;format compact;
%% load data
load('NEWdata_both_final')
X = trainingData(:,1:11);
Y_quality = trainingData(:,12);
Y_type = trainingData(:,13);

VX = validateData(:,1:11);
VY_quality = validateData(:,12);
VY_type = validateData(:,13);

% Test data: challenge dataset
TX = testData(:,1:11);
TY_quality = testData(:,12);
TY_type = testData(:,13);

%% Compare various setups for the Random Forest
% ---------------------------- Classification Trees ----------------------------
% Type trees
tic
[maxfscoreT, bestsetupT, bestBT]=findOptimalTreeSetup(X,Y_type,VX,VY_type,1);
toc

% Type prediction on Test data
[TYnewT, statsTestType]=predictForest(bestBT,TX,TY_type);
stats=confusionmatStats(TY_type,TYnewT);
% Quality trees
tic
[maxfscoreQ, bestsetupQ, bestBQ]=findOptimalTreeSetup(X,Y_quality,VX,VY_quality,1);
toc
% Quality prediction on Test data
[TYnewQ, statsTestQ]=predictForest(bestBQ,TX,TY_quality);

% confusion matrices for Type and Quality
confusionmat(TY_type,TYnewT,'order',[0 1])
confusionmat(TY_quality,TYnewQ,'order',[1 2 3 4 5 6 7])

%% ------------------------------- Regression Trees -------------------------------
% Type trees
tic
[maxfscoreTR, bestsetupTR, bestRBT]=findOptimalTreeSetup(X,Y_type,VX,VY_type,2);
toc
% Type prediction on Test data
[TYnewTR, statsTestTypeR]=predictForest(bestRBT,TX,TY_type);

% Quality trees
tic
[maxfscoreQR, bestsetupQR, bestRBQ]=findOptimalTreeSetup(X,Y_quality,VX,VY_quality,2);
toc
% Quality prediction on Test data
[TYnewQR, statsTestQR]=predictForest(bestRBQ,TX,TY_quality);
% confusion matrices for Type and Quality
confusionmat(TY_type,TYnewTR,'order',[0 1])
confusionmat(TY_quality,TYnewQR,'order',[1 2 3 4 5 6 7])
%% =========================== FIND BEST MODEL ===================================
%% Classification Trees
% Type
maxF=0; maxB=[]; tsetup=[60 1 1 2 2 1]; 
for kk=1:500
    kk
    tic
    tB=randomForest(X,Y_type,tsetup);
    [~, stats]=predictForest(tB,VX,VY_type);
    if mean(stats.Fscore)>maxF
        maxF=mean(stats.Fscore); maxB=tB;
    end
    toc
end
% Quality
[Ynew_type,~]=predictForest(maxB,X,Y_type);
[VYnew_type,~]=predictForest(maxB,VX,VY_type);
[TYnew_type,~]=predictForest(maxB,TX,TY_type);

maxF=0; maxB=[]; qsetup=[100 1 1 2 2 1]; % Ntrees, Samples, MinLeaf, Surrogate off
for kk=1:500
    kk
    tic
    qB=randomForest(X,Y_quality,qsetup);
    [~, stats]=predictForest(qB,VX,VY_quality);
    if mean(stats.Fscore)>maxF
        maxF=mean(stats.Fscore); maxB=qB;
    end
    toc
end

[Ynew_quality,~]=predictForest(maxB,X,Y_quality);
[VYnew_quality,~]=predictForest(maxB,VX,VY_quality);
[TYnew_quality,~]=predictForest(maxB,TX,TY_quality);
% Save best forest
save('reportedRFClassify.mat','Ynew_type','VYnew_type', 'TYnew_type','Ynew_quality','VYnew_quality', 'TYnew_quality')

%% Regression Trees
% Type
maxF=0; maxB=[]; tsetup=[30 1 1 2]; 
for kk=1:500
    kk
    tic
    tB=randomForest(X,Y_type,tsetup);
    [~, stats]=predictForest(tB,VX,VY_type);
    if mean(stats.Fscore)>maxF
        maxF=mean(stats.Fscore); maxB=tB;
    end
    toc
end
% Quality
[Ynew_type,~]=predictForest(maxB,X,Y_type);
[VYnew_type,~]=predictForest(maxB,VX,VY_type);
[TYnew_type,~]=predictForest(maxB,TX,TY_type);

maxF=0; maxB=[];    qsetup=[90 1 1 2]; % Ntrees, Samples, MinLeaf, Surrogate off
for kk=1:500
    kk
    tic
    qB=randomForest(X,Y_quality,qsetup);
    [~, stats]=predictForest(qB,VX,VY_quality);
    if mean(stats.Fscore)>maxF
        maxF=mean(stats.Fscore); maxB=qB;
    end
    toc
end

[Ynew_quality,~]=predictForest(maxB,X,Y_quality);
[VYnew_quality,~]=predictForest(maxB,VX,VY_quality);
[TYnew_quality,~]=predictForest(maxB,TX,TY_quality);
% Save best forest
save('reportedRFRegression.mat','Ynew_type','VYnew_type', 'TYnew_type','Ynew_quality','VYnew_quality', 'TYnew_quality')
%%
confusionmat(TY_type,TYnew_type,'order',[0 1])
confusionmat(TY_quality,TYnew_quality,'order',[1 2 3 4 5 6 7])