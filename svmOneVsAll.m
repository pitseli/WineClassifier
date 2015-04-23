% SVM OneVsAll: Testing file used to compare svm settings and returns the optimal ones
% author: Gavriela Vranou, 467614
% last edit: 17.11.2014

clear;clc;format compact;
FINDOPTIMAL=false;
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

%% -------------------------- Compare SVM Models --------------------------
% if FINDOPTIMAL
% %% Compare 6 different SVM models using linear, polynomial and Radial Basis Function kernels
% % SVM classification by type
%     tic
%     [tTrFscore, tValFscore]=fitSVMmethods(X,Y_type,VX,VY_type);
%     toc
%     
%     % SVM classification by quality
%     qTrFscore=-1*ones(7,6); % 7 quality classes, 6 models
%     qValFscore=-1*ones(7,6);
%     parfor ii=1:7
%         % Returns the average F-scores for each class, for each model
%         ii
%         tic
%         % transforming the labels in order to train a binary classifier
%         Y_all=double(Y_quality==ii);
%         VY_all=double(VY_quality==ii);
%         [qTrFscore(ii,:), qValFscore(ii,:)]=fitSVMmethods(X,Y_all,VX,VY_all);
%         toc
%     end
% end
% after visual inspection of the mean f-scores, we noted that both the RBF and the polynomial with SMO
% and ISDA performed well, while the linear didn't work at all on quality.
% %% find optimal setup for predicting Type
% if FINDOPTIMAL
%     kfunc={'rbf','polynomial'}; solver={'SMO','ISDA'}; % they perform equally well
%     meanFScores=-1*ones(size(kfunc,2),size(solver,2));
%     for ii=1:size(kfunc,2)
%         for jj=1:size(solver,2)
%             tic
%             svnmodel=modelSVM(X,Y_type,kfunc{ii},solver{jj});
%             [Ynew,VYnew,TYnew,~,~,~]=performanceSVM(svnmodel,X,VX,TX);
%             stats=confusionmatStats(VY_type,VYnew);
%             toc
%             meanFScores(jj)=mean(stats.Fscore);
%         end
%     end
% end
% 
% %% find optimal setup for predicting Quality
% if FINDOPTIMAL
%     kfunc={'rbf','polynomial'}; solver={'SMO','ISDA'};
%     bestSetup=[1,1]; maxF=0;
%     for ii=1:size(kfunc,2)
%         for jj=1:size(solver,2)
%             tic
%             [Ynew,VYnew,TYnew]=trainMultipleSVM(kfunc{ii},solver{jj},X,Y_quality,VX,VY_quality,TX,TY_quality);
%             stats=confusionmatStats(VY_quality,VYnew);
%             toc
%             if mean(stats.Fscore)>maxF
%                 maxF=mean(stats.Fscore);
%                 bestSetup=[ii,jj];
%             end
%         end
%     end
% end

%% ============================ RBF svm ============================
% ============================== Type ==============================
% The optimal RBF model was reported to be the one using SMO
% Run 200 times to find the best predictor
bestY=zeros(size(Y_type));
bestVY=zeros(size(VY_type));
bestTY=zeros(size(TY_type));
maxF=0; kfunc='rbf'; solver='SMO';
for ii=1:200
    ii
    tic
    svnmodel=modelSVM(X,Y_type,kfunc,solver);
    [Ynew,VYnew,TYnew,~,~,~]=performanceSVM(svnmodel,X,VX,TX);
    stats=confusionmatStats(VY_type,VYnew); % find the best one given the validationSet
    toc
    if mean(stats.Fscore)>maxF
        maxF=mean(stats.Fscore);
        bestY=Ynew; bestVY=VYnew; bestTY=TYnew;
    end
end
% store the best predictions for each dataset
Ynew_type=bestY; VYnew_type=bestVY; TYnew_type=bestTY;
% ============================ Quality ============================
% The optimal was for RBF with SMO method
% Run 200 times to find the best predictor for Quality
bestY=zeros(size(Y_quality));
bestVY=zeros(size(VY_quality));
bestTY=zeros(size(TY_quality));
maxF=0; kfunc='rbf'; solver='SMO';
for ii=1:200
    ii
    tic
    [Ynew,VYnew,TYnew]=trainMultipleSVM(kfunc,solver,X,Y_quality,VX,VY_quality,TX,TY_quality);
    stats=confusionmatStats(TY_quality,TYnew);
    toc
    if mean(stats.Fscore)>maxF
        maxF=mean(stats.Fscore);
        bestY=Ynew; bestVY=VYnew; bestTY=TYnew;
    end
end
stats=confusionmatStats(TY_quality,bestTY);
Ynew_quality=bestY; VYnew_quality=bestVY; TYnew_quality=bestTY;

% save file
save('reportedSVMrbf.mat','Ynew_type','VYnew_type','TYnew_type','Ynew_quality','VYnew_quality','TYnew_quality');

%% ============================ POLYNOMIAL ============================
% =============================== Type ===============================
% Run 200 times to find the best predictor
bestY=zeros(size(Y_type));
bestVY=zeros(size(VY_type));
bestTY=zeros(size(TY_type));
maxF=0; kfunc='polynomial'; solver='SMO';
for ii=1:200
    ii
    tic
    svnmodel=modelSVM(X,Y_type,kfunc,solver);
    [Ynew,VYnew,TYnew,~,~,~]=performanceSVM(svnmodel,X,VX,TX);
    stats=confusionmatStats(VY_type,VYnew);
    toc
    if mean(stats.Fscore)>maxF
        maxF=mean(stats.Fscore);
        bestY=Ynew; bestVY=VYnew; bestTY=TYnew;
    end
end
Ynew_type=bestY; VYnew_type=bestVY; TYnew_type=bestTY;

% ============================ Quality ============================
% The optimal for polynomial was with SMO method
% run 200 times to find the best predictor for Quality
bestY=zeros(size(Y_quality));
bestVY=zeros(size(VY_quality));
bestTY=zeros(size(TY_quality));
maxF=0;
for ii=1:200
    ii
    tic
    [Ynew,VYnew,TYnew]=trainMultipleSVM('polynomial','SMO',X,Y_quality,VX,VY_quality,TX,TY_quality);
    stats=confusionmatStats(TY_quality,TYnew);
    toc
    if mean(stats.Fscore)>maxF
        maxF=mean(stats.Fscore);
        bestY=Ynew; bestVY=VYnew; bestTY=TYnew;
    end
end
stats=confusionmatStats(TY_quality,bestTY);
Ynew_quality=bestY; VYnew_quality=bestVY; TYnew_quality=bestTY;

% save file
save('reportedSVMpolynomial.mat','Ynew_type','VYnew_type','TYnew_type','Ynew_quality','VYnew_quality','TYnew_quality');