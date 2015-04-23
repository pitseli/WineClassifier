% Some true visualisation beauty here

%% Density plot types
% create name array
namesData = {'fixedAcidity','volatileAcidity','citricAcid',...
        'residualSugar','chlorides','freeSulfurDioxide',...
        'totalSulfurDioxide','density','pH','sulphates',...
        'alcohol','quality','type'};
% normalise?
for i = 1:11;
    subplot(3,4,i);
    h = histfit(trainingData(trainingData(:,13)==0,i),10);
    delete(h(1));
    hold on
    g = histfit(trainingData(trainingData(:,13)==1,i),10);
    delete(g(1));
    set(g(2),'color','g')
    if (i == 11)
        legend('Red','White');
    end
    title(strcat('Plot of :',namesData{i}));
    hold off
end

%% Desnity plot quality
for i = 1:11;
    subplot(3,4,i);
    h = histfit(trainingData(trainingData(:,12)==1,i),10);
    delete(h(1));
    hold on
    g = histfit(trainingData(trainingData(:,12)==2,i),10);
    delete(g(1));
    set(g(2),'color','g')
    g = histfit(trainingData(trainingData(:,12)==3,i),10);
    delete(g(1));
    set(g(2),'color','b')
        g = histfit(trainingData(trainingData(:,12)==4,i),10);
    delete(g(1));
    set(g(2),'color','c')
        g = histfit(trainingData(trainingData(:,12)==5,i),10);
    delete(g(1));
    set(g(2),'color','m')
        g = histfit(trainingData(trainingData(:,12)==6,i),10);
    delete(g(1));
    set(g(2),'color','y')
    g = histfit(trainingData(trainingData(:,12)==7,i),10);
    delete(g(1));
    set(g(2),'color','k')
    if (i == 11)
        legend('1','2','3','4','5','6','7');
    end
    title(strcat('Plot of :',namesData{i}));
    hold off
end

%% Plot some 3d stuff because that looks nice
namesData = {'fixedAcidity','volatileAcidity','citricAcid',...
        'residualSugar','chlorides','freeSulfurDioxide',...
        'totalSulfurDioxide','density','pH','sulphates',...
        'alcohol','quality','type'};
res = trainingData(:,4);
sul = trainingData(:,7);
den = trainingData(:,8);
S = ones(1,length(res))*3;
C = trainingData(:,13)-1;
scatter3(res,sul,den,S,C);
title('Type class');
xlabel('residualSugar')
ylabel('totalSulfurDioxide')
zlabel('density')

