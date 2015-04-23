% Random Forest: Both Classifying Trees and Regression Trees
% author: Gavriela Vranou, 467614
% last edit: 17.11.2014

function [maxfscore, bestsetup, bestB]=findOptimalTreeSetup(X,Y,VX,VY,method)
%% TreeBagger Options
% NTrees: number of decision trees
% method: regression or classification
% NVarToSample: all | integerValue Number of variables to select at random for each decision
%               split. Default 1/3 of variables or sqrt
% MinLeaf: Minimum number of observations per tree leaf. Default 5
% Prior: Prior probabilities for each class. empirical or uniform

%% Available on both Classification and Regression
% CrossVal: off | on grows a cross-validated decision tree with 10 folds
% KFold: Default 10
% Holdout 0 | scalar in range [0,1]
% Leaveout off | on

% MergeLeaves off | on  merges leaves that originate from the same parent
%       node, and that give a sum of risk values greater or equal to the
%       risk associated with the parent node.
% Prune off | on
% Surrogate off | on | all | integerValue (default 10)

%% Classification: fitctree options
% AlgorithmForCategorical: 'Exact' | 'PullLeft' | 'PCA' | 'OVAbyClass'
% PruneCriterion: error | impurity
% ScoreTransform: none | doublelogit | invlogit | ismax | sign | symmetric | symmetriclogit | symmetricmax
% SplitCriterion: 'gdi' (Gini's diversity index), 'twoing' for the twoing rule, or 'deviance' for maximum deviance reduction (also known as cross entropy).

%% Regression: fitrtree options
% PruneCriterion: mse (mean squared error)
% QEToler: 1e-6 (default) Quadratic error tolerance
% SplitCriterion: MSE

myntrees=[10;25;40;60;80;100;125;150];
mysample=1:11;
myminleaf=1:8;
Kfold=[1;5;10];
myprior={'empirical','uniform'};
MergeLeaves={'on','off'};	% in our experiments, we avoided Pruning and merging of leaves
Prune={'on','off'}; 
mysurrogate={'on','off','all'}; % as there were no missing values, this parameter wasn't used

% Classification
PruneCriterionC={'error','impurity'};
mysplitCriterionC={'gdi','twoing','deviance'};

% Regression
PruneCriterionR={'mse'};
SplitCriterionR={'MSE'};

maxfscore=-1; bestsetup=[1,1,1,1,1,1];bestB=[]; % initialisation of the temporary variables
if method==1
    %% Run classification Trees
    for ii=1:size(myntrees,1)
        for jj=1:size(mysample,1)
            for mm=1:size(myminleaf,1)
                for pp=1:size(myprior,2)
                    for ss=1:size(mysurrogate,2)
                        for sp=1:size(mysplitCriterionC,2)
                            %% Prune off
                            B=TreeBagger(myntrees(ii),X,Y, 'method','classification','OOBPred','on',...
                                'NVarToSample',mysample(jj),'MinLeaf',myminleaf(mm),...
                                'Prior',myprior{pp},'Surrogate',mysurrogate{ss},...
                                'SplitCriterion',mysplitCriterionC{sp},'Prune','off');
                            [~, stats]=predictForest(B,VX,VY);
                            if mean(stats.Fscore)>maxfscore
							% the first 3 values are the actual values used, while the last 3 are indexes
							% in order to have a one datatype vector
                                bestsetup=[myntrees(ii),mysample(jj),myminleaf(mm),pp,ss,sp];
                                maxfscore=mean(stats.Fscore);
                                bestB=B;
                            end
                       end
                   end
               end
            end
       end
    end
else
    maxfscore=-1; bestsetup=[1,1,1,1];bestB=[]; % regression returns a smaller setup vector
    %% Run regression Trees
    for ii=1:size(myntrees,1)
        for jj=1:size(mysample,1)
            for mm=1:size(myminleaf,1)
                for ss=1:size(mysurrogate,2)
                    %% Prune off
                    B=TreeBagger(myntrees(ii),X,Y, 'method','regression','OOBPred','on',...
                        'NVarToSample',mysample(jj),'MinLeaf',myminleaf(mm),...
                        'Surrogate',mysurrogate{ss},'Prune','off');
                    [~, stats]=predictForest(B,VX,VY);
                    if mean(stats.Fscore)>maxfscore
                        bestsetup=[myntrees(ii),mysample(jj),myminleaf(mm),ss];
                        maxfscore=mean(stats.Fscore);
                        bestB=B;
                    end
                end
            end
        end
    end
end


%% ------------- Discarded pruning code -------------
% %% Prune on: error
% B=TreeBagger(NTrees(ii),X,Y, 'method','classification','OOBPred','on',...
%     'NVarToSample',NVarToSample(jj),'MinLeaf',MinLeaf(mm),...
%     'Prior',Prior{pp},'Surrogate',Surrogate{ss},...
%     'SplitCriterion',SplitCriterionC{sp},'Prune','on','PruneCriterion','error');
% [~, accuracy]=predictForest(B,VX,VY);
% if accuracy>maxaccuracy
%     bestsetup=sprintf('NTrees: %d method: classification, OOBPred: on, NVarToSample: %d, ',...
%         'MinLeaf: %d, Prior: %s, Surrogate: %s, SplitCriterion: %s Prune: error',...
%         NTrees(ii),NVarToSample(jj),MinLeaf(mm),Prior{pp},Surrogate{ss},SplitCriterionC{sp});
% end
%
% %% Prune on: impurity
% B=TreeBagger(NTrees(ii),X,Y, 'method','classification','OOBPred','on',...
%     'NVarToSample',NVarToSample(jj),'MinLeaf',MinLeaf(mm),...
%     'Prior',Prior{pp},'Surrogate',Surrogate{ss},...
%     'SplitCriterion',SplitCriterionC{sp},'Prune','on','PruneCriterion','impurity');
% [~, accuracy]=predictForest(B,VX,VY);
% if accuracy>maxaccuracy
%     bestsetup=sprintf('NTrees: %d method: classification, OOBPred: on, NVarToSample: %d, ',...
%         'MinLeaf: %d, Prior: %s, Surrogate: %s, SplitCriterion: %s Prune: impurity',...
%         NTrees(ii),NVarToSample(jj),MinLeaf(mm),Prior{pp},Surrogate{ss},SplitCriterionC{sp});
% end