%%@author Gabriela Vranou
% date: 05.10.2014

function data = importTrainingFile(filename, startRow, endRow)
% Returns a matrix with its column vectors being the values of the
% following fields given on the csv file:
% fixedAcidity,volatileAcidity,citricAcid,residualSugar,chlorides,
% freeSulfurDioxide,totalSulfurDioxide,density,pH,sulphates,alcohol,quality,type
%
% Type is converted from the initial 'Red' 'White' values to 1,0
% respectively

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end
% Format string for each line of text:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%s%[^\n\r]';
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
fixedAcidity = dataArray{:, 1};
volatileAcidity = dataArray{:, 2};
citricAcid = dataArray{:, 3};
residualSugar = dataArray{:, 4};
chlorides = dataArray{:, 5};
freeSulfurDioxide = dataArray{:, 6};
totalSulfurDioxide = dataArray{:, 7};
density = dataArray{:, 8};
pH = dataArray{:, 9};
sulphates = dataArray{:, 10};
alcohol = dataArray{:, 11};
quality = dataArray{:, 12};
type1 =  double(strcmp(dataArray{:, 13},'Red'));

data = [fixedAcidity,volatileAcidity,citricAcid,residualSugar,chlorides,freeSulfurDioxide,totalSulfurDioxide,density,pH,sulphates,alcohol,quality,type1];
