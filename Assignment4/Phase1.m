function [  ] = Phase1( allData, groupIds )
%Phase1 Will execute all of the phase 2 operations and save output to file

    % Set up the output file
    phase1FileName = 'phase1Output.csv';
    dlmwrite(phase1FileName, ('groupId, dtAcc, dtPrec, dtRec, dtF1, dtROC, svmAcc, svmPrec, svmRec, svmF1, svmROC, nnAcc, nnPrec, nnRec, nnF1, nnROC'), '');

    % For each file we will split into test and train
    for fileIndex = 1:length(groupIds)
        currentFileId = groupIds(fileIndex,1);

        % Get all data for the file
        includeRowList = allData(:, 1) == currentFileId;    % True/False list if the row has the value from the current file
        dataFromFile = allData(includeRowList, :);             % Use the true/false list to select the rows we want

        % Determine the number of train and test rows
        numberOfTrainRows = ceil(length(dataFromFile) * .6);

        % Split 60% of records into train data
        trainData = dataFromFile(1:numberOfTrainRows,:);
        trainFeatureData = trainData(:, 3:end); % Feature data values
        trainClassifications = trainData(:, 2); % Single column containing the classification values

        % Take the rest as test data
        testData = dataFromFile(numberOfTrainRows + 1:end, :);
        testFeatureData = testData(:, 3:end); % TODO: Be sure to update this when the new grou column is added
        testClassifications = testData(:, 2); % TODO: Be sure to update this when the new grou column is added

        % This will hold all of the data for the file and will be appended to the output file
        metricsForFile = zeros(1, 16); 
        metricsForFile(1,1) = currentFileId;

        %
        % Decision Tree
        %

        % Train the decision tree for the data
        % TODO: There are many parameters that can be added here, add some, run it and see if the accuracy/precision/recall is increased
        %       Will need to run a good number of times to see what works best or if it doesn't make a difference.  Do same with SVM and NN.
        %       Be sure to understand the best parameters chosen as we will need to talk about them in the write up.
        decisionTree = fitctree(trainFeatureData, trainClassifications); % First parameter is the feature values, second are the classifications

        % Use the test data to predict
        [dtPredictedValues, scores] = predict(decisionTree, testFeatureData);

        % Analyze the performance of the predicted values
        [ dtAccuracy, dtPrecision, dtRecall, dtF1, dtROC ] = AnalyzePredictor(testClassifications, dtPredictedValues, scores(:, 2));

        % Add the values for the decision tree to the output matrix
        metricsForFile(1, 2) = dtAccuracy;
        metricsForFile(1, 3) = dtPrecision;
        metricsForFile(1, 4) = dtRecall;
        metricsForFile(1, 5) = dtF1;
        metricsForFile(1, 6) = dtROC;

        %
        % SVM
        %

        % Train an SVM
        svm = fitcsvm(trainFeatureData, trainClassifications, 'Standardize',true, 'KernelScale','auto'); % TODO: Play around/remove the values as needed

        % Use the test data to predict values
        [svmPredictedValues, scores] = predict(svm, testFeatureData);

        % Analyze the performance of the predicted values
        [ svmAccuracy, svmPrecision, svmRecall, svmF1, svmROC ] = AnalyzePredictor(testClassifications, svmPredictedValues, scores(:, 2));

        % Add the values for the decision tree to the output matrix
        metricsForFile(1, 7) = svmAccuracy;
        metricsForFile(1, 8) = svmPrecision;
        metricsForFile(1, 9) = svmRecall;
        metricsForFile(1, 10) = svmF1;
        metricsForFile(1, 11) = svmROC;

        % 
        % Neural Network
        %

        % TODO: Create the neural network
        %{
        % Create and train a neural network using the NN toolbox
        nn = % Some neural network created using the toolbox

        % Use the test data to predict values
        [nnPredictedValues, scores] = predict(nn, testFeatureData); % Needs to return the predictions and the probability scores

        % Analyze the performance of the predicted values
        [ nnAccuracy, nnPrecision, nnRecall, nnF1, nnROC ] = AnalyzePredictor(testClassifications, nnPredictedValues, scores(:, 2)); % Make sure to pass the probability that "1" is given

        % Add the values for the decision tree to the output matrix
        metricsForFile(1, 12) = nnAccuracy;
        metricsForFile(1, 13) = nnPrecision;
        metricsForFile(1, 14) = nnRecall;
        metricsForFile(1, 15) = nnF1;
        metricsForFile(1, 16) = nnROC;    
        %}

        % After performing analysis of the three different methods, write to the output file
        dlmwrite(phase1FileName, metricsForFile, 'delimiter', ',', '-append', 'precision', 13);

    end
end

