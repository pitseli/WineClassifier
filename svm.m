%% Support Vector Machine
%[fixedAcidity,volatileAcidity,citricAcid,residualSugar,chlorides,
% freeSulfurDioxide,totalSulfurDioxide,density,pH,sulphates,alcohol];
% Set data
clear;clc;
load('data_both_final')
X = trainingData(:,1:11);
Y_quality = trainingData(:,12);
Y_type = trainingData(:,13);

VX = validateData(:,1:11);
VY_quality = validateData(:,12);
VY_type = validateData(:,13);

C = challengeData(:,1:11);

%% check the other svn methods on matlab
%% SVN classification by type
[nTtrainingError, nTvalidateError,nTaccuracy,score]=fitSVMmethods(X,Y_type, VX, VY_type);

%% svn by Quality oneVSall

nQtrainingError=-1*ones(4,7);
nQvalidateError=-1*ones(4,7);
nQaccuracy=-1*ones(4,7,2);
for ii=1:7
    Y_all=double(Y_quality==ii);
    VY_all=double(VY_quality==ii);
    
    [nQtrainingError(:,ii), nQvalidateError(:,ii), nQaccuracy(:,ii,:)]=fitSVMmethods(X,Y_all, VX, VY_all);
end


%predictedData=classifySVMmethods(X,Y_type, VX, VY_type, C)
%% ---------------------------------------
% SVN classification by type
[TtrainingError, TvalidateError, Taccuracy, tsvnmodel]=ttrySVMmethods(X,Y_type, VX, VY_type);

% svn by Quality oneVSall

QtrainingError=-1*ones(4,7);
QvalidateError=-1*ones(4,7);
Qaccuracy=-1*ones(4,7,2);
k=1;
for ii=1:7
    Y_all=double(Y_quality==ii);
    VY_all=double(VY_quality==ii);
    
    [QtrainingError(:,ii), QvalidateError(:,ii), Qaccuracy(:,ii,:), tmp]=ttrySVMmethods(X,Y_all, VX, VY_all);
    qsvnmodel(k)=tmp(1); qsvnmodel(k+1)=tmp(2); qsvnmodel(k+2)=tmp(3);qsvnmodel(k+3)=tmp(4);
    k=k+4;
end
