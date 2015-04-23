% Random Forest: Given a setup and pairs of data,labels, create a random forest
% author: Gavriela Vranou, 467614
% last edit: 17.11.2014

% Given a pair of observations X and their respective true labels Y, it constructs 
% a Random forest TreeBagger, with the parameters given on the setup vector
% setup = [NumberOfTrees, SampleToSplit, MinimumLeaf, IndexOfPrior, IndexOfSurrogateOptions, SplitCriterion]
% Prior can take one of the respective integer values of {empirical,uniform}
% Surrogate can take one of the respective integer values of {on, off, all}
% SplitCriterion can take one of the respective integer values of {gdi, twoing, deviance}
% For full description, see findOptimalTreeSetup.m and TreeBagger, fitctree, fitrtree documentation

function B=randomForest(X,Y,setup)
prior={'empirical','uniform'};
surrogate={'on','off','all'};
if size(setup,2)==6 % method=classification
    splitCriterionC={'gdi','twoing','deviance'};
    
    B=TreeBagger(setup(1),X,Y, 'method','classification','OOBPred','on',...
        'NVarToSample',setup(2),'MinLeaf',setup(3),...
        'Prior',prior{setup(4)},'Surrogate',surrogate{setup(5)},...
        'SplitCriterion',splitCriterionC{setup(6)},'Prune','off');
    
else % method = regression
    B=TreeBagger(setup(1),X,Y, 'method','regression','OOBPred','on',...
        'NVarToSample',setup(2),'MinLeaf',setup(3),...
        'Surrogate',surrogate{setup(4)},'Prune','off');
end

end
