
% Read in all of the feature values
allData = csvread('completeFeatureAfterMapping.csv', 1);
classifications = allData(:,2);
featureValues = allData(:,3:end);

% Get each fileId
groupIds = unique(allData(:,8));

%
% PHASE 1
%
Phase1(allData, groupIds);


%
% PHASE 2
%
Phase2(allData, groupIds);

%
% Post Analysis
%

% Read the file and calculate the averages over all groups for phase 1
phase1FileName = 'phase1Output.csv';
phase1Data = csvread(phase1FileName, 1);
colAverages = mean(phase1Data);
dlmwrite(phase1FileName, colAverages, 'delimiter', ',', '-append', 'precision', 13);

% Read the file and calculate the averages for phase 2
% Write the averages as the last row in the file
phase2FileName = 'phase2Output.csv';
phase2Data = csvread(phase2FileName, 1);
colAverages = mean(phase2Data);
dlmwrite(phase2FileName, colAverages, 'delimiter', ',', '-append', 'precision', 13);





