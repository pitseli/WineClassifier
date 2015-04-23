%% Predicting quality (7 class) with kNN classification
%   Finding the optimal parameters for kNN classification of
%   wine-quality. Selecting the best one on the validation dataset
%   Then output the results on the challenge datset.

% Load data
clear
load('NEWdata_both_final')
X = trainingData(:,1:11);
Y_quality = trainingData(:,12);
Y_type = trainingData(:,13);

VX = validateData(:,1:11);
VY_quality = validateData(:,12);
VY_type = validateData(:,13);

CX = testData(:,1:11);
CY_quality = testData(:,12);

% All parameters:
breakTies = {'smallest','nearest','random'};
distances1 = {'cityblock', 'chebychev', 'euclidean', 'minkowski'};
distances2 = {'jaccard','cosine','mahalanobis','spearman'};
a = [distances1 distances2];
NSmethod = {'kdtree','exhaustive'};

% Look for the best
fscore = zeros(10,length(breakTies),length(distances1) + length(distances2));
for k = 1:10
    for b = 1:length(breakTies);
        br = breakTies{b};
        for i = 1: length(distances1) + length(distances2)
            if i <= length(distances1)
                meth = NSmethod{1};
            else 
                meth = NSmethod{2};
            end
            dist = a{i};
            knn = fitcknn(X,Y_quality,...
            'NumNeighbors',k,...
            'NSMethod',meth,...
            'Distance',dist,...
            'breakTies',br);
            P_quality = predict(knn, VX);
            stats = confusionmatStats(VY_quality,P_quality);
            fscore(k,b,i) = mean(stats.Fscore);
            disp(i)
        end
    end
end
err = 1-fscore;
[min_err, position] = min(err(:)); 
[k,b,i] = ind2sub(size(err),position);
% Display the best:
k
breakTies(b)
dist = a{i}

% Now get the performance on the challenge dataset
if i <= length(distances1)
    meth = NSmethod{1};
else 
    meth = NSmethod{2};
end
knn = fitcknn(X,Y_quality,...
        'NumNeighbors',k,...
        'NSMethod',meth,...
        'Distance',a{i},...
        'breakTies',br);
P_quality = predict(knn, CX);
stats = confusionmatStats(CY_quality,P_quality);
stats.Fscore
