function [ ] = Phase2( allData, groupIds )
%Phase2 Will execute all of the phase 2 operations

    % Set up the output file
    phase2FileName = 'phase2Output.csv';
    dlmwrite(phase2FileName, ('groupId, dtAcc, dtPrec, dtRec, dtF1, dtROC, svmAcc, svmPrec, svmRec, svmF1, svmROC, nnAcc, nnPrec, nnRec, nnF1, nnROC'), '');

    % Choose 10 groups to use as sampling
    trainingGroups = groupIds([1, 4, 5, 9, 12, 13, 17, 18, 20, 22, 32, 33], :); % Pretty much just random values, can be changed
    
    % Get all of the training data from the above groups
    trainingGroupRows = ismember(allData(:, 8), trainingGroups);    % True/False values of what rows to choose
    p2TrainingData = allData(trainingGroupRows, :);                 % Use the true/false list to select the rows we want
    p2TrainFeatureData = p2TrainingData(:, 3:7);
    p2TrainClassifications = p2TrainingData(:, 2);

    % Determine the test groups, simply the values that weren't selected above
    testGroups = groupIds(~ismember(groupIds, trainingGroups), :); 

    % First we will train each of the classifiers then we will run the test data from each group through them

    % Create the decision tree
    decisionTree2 = fitctree(p2TrainFeatureData, p2TrainClassifications); % First parameter is the feature values, second are the classifications

    % Create the SVM
    svm2 = fitcsvm(p2TrainFeatureData, p2TrainClassifications, 'Standardize',true, 'KernelScale','auto');

    % Train the NN
    nn = patternnet(20);
    %nn = configure(nn,transpose(p2TrainFeatureData), transpose(p2TrainClassifications));
    nn.trainParam.showWindow=0;
    nn = train(nn,transpose(p2TrainFeatureData), transpose(p2TrainClassifications));
    
    % For each test group
    for fileIndex = 1:length(testGroups)
        testGroupId = testGroups(fileIndex, 1);

        % This will hold output metrics for each test value
        phase2Metrics = zeros(1, 16); 
        phase2Metrics(1, 1) = testGroupId;

        % Get the test data for this group
        includeRowList = allData(:, 8) == testGroupId;    % True/False list if the row has the value from the current file
        p2TestData = allData(includeRowList, :);             % Use the true/false list to select the rows we want
        p2TestFeatures = p2TestData(:, 3:7);
        p2TestClassifications = p2TestData(:, 2);

        % Run the test data through each classifier and get metrics

        % Decision tree predictor
        [dtPredictedValues, scores] = predict(decisionTree2, p2TestFeatures);

        % Analyze the performance of the predicted values
        [ dtAccuracy, dtPrecision, dtRecall, dtF1, dtROC ] = AnalyzePredictor(p2TestClassifications, dtPredictedValues, scores(:, 2));

        % Add the values for the decision tree to the output matrix
        phase2Metrics(1, 2) = dtAccuracy;
        phase2Metrics(1, 3) = dtPrecision;
        phase2Metrics(1, 4) = dtRecall;
        phase2Metrics(1, 5) = dtF1;
        phase2Metrics(1, 6) = dtROC;

        % Run test data through SVM predictor

        % Use the test data to predict values
        [svmPredictedValues, scores] = predict(svm2, p2TestFeatures);

        % Analyze the performance of the predicted values
        [ svmAccuracy, svmPrecision, svmRecall, svmF1, svmROC ] = AnalyzePredictor(p2TestClassifications, svmPredictedValues, scores(:, 2));

        % Add the values for the decision tree to the output matrix
        phase2Metrics(1, 7) = svmAccuracy;
        phase2Metrics(1, 8) = svmPrecision;
        phase2Metrics(1, 9) = svmRecall;
        phase2Metrics(1, 10) = svmF1;
        phase2Metrics(1, 11) = svmROC;

        % Run test data through NN predictor

        % Use the test data to predict values
        scores = transpose(sim(nn, transpose(p2TestFeatures)));
        nnPredictedValues = round(scores);
        
        % Analyze the performance of the predicted values
        [ nnAccuracy, nnPrecision, nnRecall, nnF1, nnROC ] = AnalyzePredictor(p2TestClassifications, nnPredictedValues, scores); % Make sure to pass the probability that "1" is given

        % Add the values for the decision tree to the output matrix
        phase2Metrics(1, 12) = nnAccuracy;
        phase2Metrics(1, 13) = nnPrecision;
        phase2Metrics(1, 14) = nnRecall;
        phase2Metrics(1, 15) = nnF1;
        phase2Metrics(1, 16) = nnROC;    

        % After performing analysis of the three different methods, write to the output file
        dlmwrite(phase2FileName, phase2Metrics, 'delimiter', ',', '-append', 'precision', 13);
    end
end

