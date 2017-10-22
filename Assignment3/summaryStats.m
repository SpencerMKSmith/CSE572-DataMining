statisticsFileName = 'statisticsData.csv';

% After we finish everything, read in the stats and do some more
% analysis
statsFile = csvread(statisticsFileName, 1, 0);

eatingSummary = zeros(36, size(statsFile,2));
% nonEatingSummary = zeros(18, size(statsFile,2));

for rowIndex = 1:size(statsFile,1)
    row = statsFile(rowIndex, :);
    isEating = row(1,2);
    sensorNumber = row(1, 3);
    
    if sensorNumber == 0
       continue;
    end
   
    outputFileRow = sensorNumber * 2 + isEating;
    eatingSummary(outputFileRow, 1) = isEating;
    eatingSummary(outputFileRow, 2) = sensorNumber;
    eatingSummary(outputFileRow, 3) = eatingSummary(outputFileRow, 3) + 1;

    for statsIndex = 4:size(row, 2)
        value = row(1, statsIndex);
        eatingSummary(outputFileRow, statsIndex) = eatingSummary(outputFileRow, statsIndex) + value;
    end
end

% After looping through each, calculate average
for index = 2:size(eatingSummary, 1)
   n = eatingSummary(index, 3); 
   
   for column = 4:size(eatingSummary, 2)
      eatingSummary(index, column) = eatingSummary(index, column) / n;      
   end
   
end

dlmwrite("eatingStatistics.csv", eatingSummary, 'delimiter', ',', 'precision', 13);

