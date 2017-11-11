
% Read in all of the feature values
allData = csvread('completeFeatureMatrix.csv', 1);
classifications = allData(:,2);
featureValues = allData(:,3:end);

% Read in the group data
groupMappings = importGroupMapping();

% Here add a column to allData that will hold the groupId
% TODO: See above

% Here loop through each row in allData (NOT GROUP MAPPING).  Get the file Id, find the corresponding groupId from the groupMappings
%   and set the value in the new column (Be sure to convert to number as the matrix is numeric i.e Group_01 -> 1)
% TODO: See above

% Get each fileId
% TODO: Change to groupIds, we want to take each groupId, just refactor "fileIds" to "groupIds" and point to the new column
%       instead of column 1
fileIds = unique(allData(:,1));


%
% PHASE 1
%
Phase1(allData, fileIds); % TODO: Change to groupIds


%
% PHASE 2
%
Phase2(allData, fileIds); % TODO; Change to groupIds





