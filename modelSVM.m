% SVM OneVsAll: modelSVM
% author: Gavriela Vranou, 467614
% last edit: 17.11.2014

% Fits a model having a kfunc kernel (of the given order if it's a
% polynomial), using the given solver on the given observation,label pairs
function svnmodel=modelSVM(X,Y,kfunc,solver,order)
if nargin < 5 && strcmp(kfunc,'polynomial')
        order=3;
end
if strcmp(kfunc,'polynomial')
    svnmodel = fitcsvm(X,Y, 'Standardize',true,'KernelFunction',kfunc,'PolynomialOrder',order,...
        'KernelScale','auto','Solver',solver);
else
    svnmodel = fitcsvm(X,Y, 'Standardize',true,'KernelFunction',kfunc,...
        'KernelScale','auto','Solver',solver);
end