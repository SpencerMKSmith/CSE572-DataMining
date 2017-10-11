function transposeAndWriteToFile( fileName, matrix )
    %TRANSPOSEANDWRITETOFILE Summary of this function goes here
    %   Detailed explanation goes here
    % Transpose
    currentArea = matrix(1,21);
    tempMatrix = [];
    eatingFinalMatrix = [0, 2000];
    nonEatingFinalMatrix = [];
    actionNumber = 1;
    dlmwrite(fileName, ('Action, Area, Sensor'), '');

    for index = 1:length(matrix)

        % If we are looking at the same area that we have been, add the
        %   row to the temp matrix
        if matrix(index, 21) == currentArea && index < length(matrix)
            tempMatrix = [tempMatrix; matrix(index, :)];
        else
            % Once we reach another area we want to transpose and store
            %   everything that we have in the temp matrix


            % Perform transpose
            tempTranspose = transpose(tempMatrix);

            % The area number will be
            areaNumber = tempTranspose(21, 1);

            tempTranspose = removerows(tempTranspose, 21);
            tempTranspose = removerows(tempTranspose, 20);
            tempTranspose = removerows(tempTranspose, 1);

            % Add three columns
            tempTranspose = [zeros(size(tempTranspose, 1), 3) tempTranspose];

            % Add meta data common to each frame
            tempTranspose(:,1) = actionNumber;
            tempTranspose(:,2) = areaNumber;

            for transposeRow = 1:size(tempTranspose, 1)
               tempTranspose(transposeRow, 3) = transposeRow; 
            end

            % Write the new action rows to the csv file
            dlmwrite(fileName, tempTranspose, 'delimiter', ',', '-append');

            % Reset the variables to start looking at the next matrix
            actionNumber = actionNumber + 1;
            tempMatrix = [];
            tempMatrix = [tempMatrix; matrix(index, :)];
            currentArea = matrix(index, 21);
        end
    end
end

