function [tTrFscore, tValFscore]=fitSVMmethods(X,Y, VX, VY)
%Y=Y_type; VY=VY_type;
tTrFscore=-1*ones(6,1);
tValFscore=-1*ones(6,1);

idx=find(Y==1);
vidx=find(VY==1);

%% Test 6 different models
try
    % linear kernel function (dot product)
    % Sequential Minimal Optimisation (SMO) method for separating the
    % hyperplane
    
    kfunc='linear'; solver='SMO';
    SVMModel = fitcsvm(X,Y,'Standardize',true,'KernelFunction',kfunc,...
        'KernelScale','auto','Solver',solver);
    [Ynew, ~] = predict(SVMModel,X);
    stats=confusionmatStats(Y(idx),Ynew(idx));
    tTrFscore(1)=mean(stats.Fscore);
    
    VYnew = predict(SVMModel,VX);
    stats=confusionmatStats(VY(vidx),VYnew(vidx));
    tValFscore(1)= mean(stats.Fscore);
catch e
end

try
    % linear kernel function (dot product)
    % Iterative Single Data Algorithm method for separating the hyperplane
    kfunc='linear'; solver='ISDA';
    SVMModel = fitcsvm(X,Y,'Standardize',true,'KernelFunction',kfunc,...
        'KernelScale','auto','Solver',solver);
    [Ynew, ~] = predict(SVMModel,X);
    stats=confusionmatStats(Y(idx),Ynew(idx));
    tTrFscore(2)=mean(stats.Fscore);
    
    VYnew = predict(SVMModel,VX);
    stats=confusionmatStats(VY(vidx),VYnew(vidx));
    tValFscore(2)= mean(stats.Fscore);
end
try
    % Gaussian Radial Basis Function kernel (RBF)
    % Sequential Minimal Optimisation (SMO) method for separating the
    % hyperplane
    kfunc='rbf'; solver='SMO';
    SVMModel = fitcsvm(X,Y, 'Standardize',true,'KernelFunction',kfunc,...
        'KernelScale','auto','Solver',solver);
    [Ynew, ~] = predict(SVMModel,X);
    stats=confusionmatStats(Y(idx),Ynew(idx));
    tTrFscore(3)=mean(stats.Fscore);
    
    VYnew = predict(SVMModel,VX);
    stats=confusionmatStats(VY(vidx),VYnew(vidx));
    tValFscore(3)= mean(stats.Fscore);
catch e
end
try
    % Gaussian Radial Basis Function kernel (RBF)
    % Iterative Single Data Algorithm method for separating the
    % hyperplane
    kfunc='rbf'; solver='ISDA';
    SVMModel = fitcsvm(X,Y,'Standardize',true,'KernelFunction',kfunc,...
        'KernelScale','auto','Solver',solver);
    [Ynew, ~] = predict(SVMModel,X);
    stats=confusionmatStats(Y(idx),Ynew(idx));
    tTrFscore(4)=mean(stats.Fscore);
    
    VYnew = predict(SVMModel,VX);
    stats=confusionmatStats(VY(vidx),VYnew(vidx));
    tValFscore(4)= mean(stats.Fscore);
catch e
end
try
    % Polynomial kernel of 3rd order
    % Sequential Minimal Optimisation (SMO) method for separating the
    % hyperplane
    kfunc='polynomial'; solver='SMO';
    SVMModel = fitcsvm(X,Y, 'Standardize',true,'KernelFunction',kfunc,'PolynomialOrder',3,...
        'KernelScale','auto','Solver',solver);
    [Ynew, ~] = predict(SVMModel,X);
    stats=confusionmatStats(Y(idx),Ynew(idx));
    tTrFscore(5)=mean(stats.Fscore);
    
    VYnew = predict(SVMModel,VX);
    stats=confusionmatStats(VY(vidx),VYnew(vidx));
    tValFscore(5)= mean(stats.Fscore);
catch e
end
try
    % Polynomial kernel of 3rd order
    % Iterative Single Data Algorithm method for separating the
    % hyperplane
    kfunc='polynomial'; solver='ISDA';
    SVMModel = fitcsvm(X,Y,'Standardize',true,'KernelFunction',kfunc,'PolynomialOrder',3,...
        'KernelScale','auto','Solver',solver);
    [Ynew, ~] = predict(SVMModel,X);
    stats=confusionmatStats(Y(idx),Ynew(idx));
    tTrFscore(6)=mean(stats.Fscore);
    
    VYnew = predict(SVMModel,VX);
    stats=confusionmatStats(VY(vidx),VYnew(vidx));
    tValFscore(6)= mean(stats.Fscore);
catch e
end