summaryCSV = csvread('Data\summary.csv',1,0);
outputFileName = 'sensorData.csv';
statisticsFileName = 'statisticsData.csv';

%Write the headers to the output file
dlmwrite(outputFileName, ('isEating, action, fileId, area, sensor'), '');
dlmwrite(statisticsFileName, ('fileId, isEating, sensor, min, max, avg, std, rms, slope, maxMinDiff, dwt'), '');
dlmwrite('pcaMatrix.csv', ('isEating, maxMin, dwt, slope, fourier, median'), '');

% For each carry frame (start, end, area)x
% Mark whether the frame is eating or noneating
for videoIndex = 1:length(summaryCSV)
    recordId = summaryCSV(videoIndex,2);
    numberOfFrames = summaryCSV(videoIndex, 3);
    duration = summaryCSV(videoIndex, 4);
    fps = summaryCSV(videoIndex, 5);

    % Determine the time of the last video frame
    videoEndTime = round(recordId + ( duration * 1000 ));
    
    % Read in the IMU and EMD files
    imuData = csvread(strcat('Data\IMU\', num2str(recordId), '_IMU.txt'));
    emgData = csvread(strcat('Data\EMG\', num2str(recordId), '_EMG.txt'));
    annotationData = csvread(strcat('Data\Annotation\', num2str(recordId), '.txt'));
    
    % Determine the difference between the end video and end sensor time
 %   lastImuTime = imuData(length(imuData) - 1, 1);
 %   lastEmgTime = emgData(length(emgData) - 1, 1);
 %   sensorLastTime = round((lastImuTime + lastEmgTime) / 2);
    
 %   differenceBetweenTimes = sensorLastTime - videoEndTime; % This is right?

    % For each annotation
    previousEndTime = -1;
    for annotationIndex = 1:length(annotationData)
        startCarryFrame = annotationData(annotationIndex, 1);
        stopCarryFrame = annotationData(annotationIndex, 2);
        areaNumber = annotationData(annotationIndex, 3);
        
        % Determine the time frame interval to get data between
        startCarryTime = recordId + (startCarryFrame / fps) * 1000;
        stopCarryTime = recordId + (stopCarryFrame / fps) * 1000;
        
        % Get the imu and emg data for eating frames
        eatingImuData = getValuesBetweenTimes(imuData, startCarryTime, stopCarryTime);
        eatingEmgData = getValuesBetweenTimes(emgData, startCarryTime, stopCarryTime);
        
        % Write the eating data to the file
        transposeAndWriteToFile(outputFileName, eatingImuData, eatingEmgData, 1, annotationIndex, recordId, areaNumber);
    
        % Get the noneating data and write to file
        if previousEndTime ~= -1
            nonEatingImuData = getValuesBetweenTimes(imuData, previousEndTime, startCarryTime);
            nonEatingEmgData = getValuesBetweenTimes(emgData, previousEndTime, startCarryTime);
            transposeAndWriteToFile(outputFileName, nonEatingImuData, nonEatingEmgData, 0, annotationIndex, recordId, areaNumber);
        end
        previousEndTime = stopCarryTime;
    end
end

