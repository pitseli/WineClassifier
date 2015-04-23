function [] = csvPrediction(predictedData)
% Create final csv with headers id, quality, type as required
% for the submission of the challengedataset
%   Input:
%   - predictedData in 1000x13 format (quality,type)
%   Output:
%   - None

headers = 'id,quality,type\n';
type = {'White','Red'}; % white 0, red 1

f = fopen('svnprediction-467614-467148.csv','w');
fprintf(f, headers);
for i = 1:length(predictedData)
    t = type(round(predictedData(i,2))+1);
    t2 = strcat(num2str(i),',',num2str(round(predictedData(i,1))),',',t,'\n')
    fprintf(f,t2);
end

fclose(f);