function transposeAndWriteToFile( outputFileName, imuMatrix, emgMatrix, isEating, actionNumber, fileId, areaNumber )

statisticsFileName = 'statisticsData.csv';

%TRANSPOSEANDWRITETOFILE Summary of this function goes here
    %   Detailed explanation goes here
    
    % Remove the ID column from the matrices
    imuMatrix(:, 1) = [];
    emgMatrix(:, 1) = [];
    
    % Transpose the matrices
    xposedImuMatrix = transpose(imuMatrix);
    xposedEmgMatrix = transpose(emgMatrix);
    
    % Concatenate them underneath each other
    % NOTE: Extracted code from online
    sa=size(xposedImuMatrix);
    sb=size(xposedEmgMatrix);
    tempmat=NaN(sa(1)+sb(1),max([sa(2) sb(2)]));
    tempmat(1:sa(1),1:sa(2))=xposedImuMatrix;
    tempmat(sa(1)+1:end,1:sb(2))=xposedEmgMatrix;
    tempmat(isnan(tempmat))=0; % Replace NaN with 0
    sensorDataForAction = tempmat;
    
    % Shift to make more columns
    sensorDataForAction =  [zeros(size(sensorDataForAction, 1), 5) sensorDataForAction];
    
    % Add the classification (1 = eating, 0 = noneating)
    sensorDataForAction(:, 1) = isEating;
    
    % Add the action number
    sensorDataForAction(:, 2) = actionNumber;

    % Add the file id
    sensorDataForAction(:, 3) = fileId;

    % Add the area number
    sensorDataForAction(:, 4) = areaNumber;

    % Add the sensor numbers
    for transposeRow = 1:size(sensorDataForAction, 1)
        sensorDataForAction(transposeRow, 5) = transposeRow; 
    end
    
    % Write the new action rows to the csv file
    dlmwrite(outputFileName, sensorDataForAction, 'delimiter', ',', '-append', 'precision', 13);
    
    % 
    % Create a new matrix with summary statistics for the data
    %
    
    dataStatistics = zeros(18,11);
    
    for sensorIndex = 1:size(sensorDataForAction, 1)
        
        sensorData = sensorDataForAction(sensorIndex, 6:end);
        trimmedSensorData = sensorData(sensorData ~= 0);
        
        % Remove outliers
        IQR = iqr(trimmedSensorData);
        firstQuantile = prctile(trimmedSensorData, 25);
        thirdQuantile = prctile(trimmedSensorData, 75);
        trimmedSensorData = trimmedSensorData(trimmedSensorData < thirdQuantile + 1.5 * IQR);
        trimmedSensorData = trimmedSensorData(trimmedSensorData > firstQuantile - 1.5 * IQR);
        timeValues = (1:length(trimmedSensorData));
        
        minValue = min(trimmedSensorData);
        maxValue = max(trimmedSensorData);
        avgValue = mean(trimmedSensorData);
        stdValue = std(trimmedSensorData);
        rmsValue = rms(trimmedSensorData);
        slopeValue = transpose(timeValues) \ transpose(trimmedSensorData);
        maxMinDiff = maxValue - minValue;
        
        dwtValue = dwt(trimmedSensorData(1, 4:size(trimmedSensorData,2)),'db1', 'mode','sym');
        
        try
            dataStatistics(sensorIndex, :) = [fileId, isEating, sensorIndex, minValue, maxValue, avgValue, stdValue, rmsValue, slopeValue, maxMinDiff, dwtValue];
        catch e
            disp(e);
        end
    end
    
    dlmwrite(statisticsFileName, dataStatistics, 'delimiter', ',', '-append', 'precision', 13);

end
