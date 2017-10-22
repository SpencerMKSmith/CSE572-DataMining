function [ return_matrix ] = getValuesBetweenTimes( matrix, startTime, stopTime )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

startTimeIndex = -1;
stopTimeIndex = -1;
% Get the data between the start and stop times

% Find the start and stop indexes to get the data between
for rowIndex = 1:length(matrix)
    rowTimeStamp = matrix(rowIndex,1);

    % If we past the start time, set the index
    if rowTimeStamp < startTime 
        startTimeIndex = rowIndex;
    end

    % If we pass the stop time, set the index
    if stopTime < rowTimeStamp
        stopTimeIndex = rowIndex;
        break;
    end
end

% Edge case where the calculated start time is after the first capture time
% of the sensor
if startTimeIndex == -1
    startTimeIndex = 1;
end

return_matrix = matrix(startTimeIndex:stopTimeIndex, :);

end

