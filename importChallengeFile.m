%%@author Gabriela Vranou
% date: 05.10.2014

function data = importChallengeFile(filename, startRow, endRow)
% Challenge csv file has an added field id, and both quality and type are
% NaN values. This function omits the id field, and replaces the NaN values with zeroes.

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end
% Format string for each line of text:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%s%s%[^\n\r]';
% Open the text file.
fileID = fopen(filename,'r');
% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.

%% Allocate imported array to column variable names
%id = dataArray{:, 1};
fixedAcidity = dataArray{:, 2};
volatileAcidity = dataArray{:, 3};
citricAcid = dataArray{:, 4};
residualSugar = dataArray{:, 5};
chlorides = dataArray{:, 6};
freeSulfurDioxide = dataArray{:, 7};
totalSulfurDioxide = dataArray{:, 8};
density = dataArray{:, 9};
pH = dataArray{:, 10};
sulphates = dataArray{:, 11};
alcohol = dataArray{:, 12};
quality = double(strcmp(dataArray{:, 13},'NaN'));
type1 =  double(strcmp(dataArray{:, 13},'NaN'));

data = [fixedAcidity,volatileAcidity,citricAcid,residualSugar,chlorides,freeSulfurDioxide,totalSulfurDioxide,density,pH,sulphates,alcohol,quality,type1];
