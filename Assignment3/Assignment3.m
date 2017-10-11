carryingFrame = csvread('1503525025300_carrying_frame.csv');
sensorData = csvread('1503525025300_label.csv',1 , 0);

% For each carry frame (start, end, area)
% Mark whether the frame is eating or noneating
previousEnd = -1;
for index = 1:length(carryingFrame)
    startFrame = carryingFrame(index,1);
    endFrame = carryingFrame(index, 2);
    areaNumber = carryingFrame(index, 3);

    % For each row between start and end mark as 1 meaning eating action
    for sensorRow = startFrame:endFrame
        sensorData(sensorRow, 20) = 1;
        sensorData(sensorRow, 21) = areaNumber;
    end
    
    if previousEnd ~= -1
       for sensorRow = (previousEnd+1):(startFrame-1)
          sensorData(sensorRow, 21) = areaNumber; 
       end
    end
    previousEnd = endFrame;
end

% Remove the rows after the last end eating
lastEndFrameNumber = carryingFrame( length(carryingFrame), 2);
sensorData = removerows(sensorData, (lastEndFrameNumber+1:length(sensorData)));

% Remove all frames before the first eating action because we don't
%   know what is happening
firstEatingFrame = carryingFrame(1,1);
sensorData = removerows(sensorData, (1:firstEatingFrame - 1)); % Remove rows 1 to first eating action

% Separate eating and non eating into two matrices
eatingMatrix = [];
nonEatingMatrix = [];
for index = 1:length(sensorData)
   currentRow = sensorData(index, :);
   isEating = currentRow(1, 20); % 0/1 Value if is eating frame
   
   if isEating == 1
      eatingMatrix = [eatingMatrix; currentRow]; 
   else
      nonEatingMatrix = [nonEatingMatrix; currentRow];
   end
end

transposeAndWriteToFile('eatingData.csv', eatingMatrix);
transposeAndWriteToFile('nonEatingData.csv', nonEatingMatrix);



