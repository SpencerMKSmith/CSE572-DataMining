function [ accuracy, precision, recall, F1, ROC ] = AnalyzePredictor( trueClassifications, predictionValues, probabilityScores )
%AnalyzePredictor Recieves the predictionValues which is a nx1 matrix
%                 of classification values from a predictor and a
%                 trueClassifications nx1 matrix which are the true
%                 classifications for the observations.

% Returns:  Precision:  TP / (TP + FP) --> Correctly Classified Positive Samples / All samples that are predicted positive
%           Recall:     TP / (TP + FN) --> Correctly Classified Positive Samples / All samples that are actually positive
%           F1 score:   (2rp) / (r + p)
%           ROC:        Calculate the area under the curve of the ROC curve

    analyzer = classperf(trueClassifications, predictionValues); % This function will return an object with the classification performance
    accuracy = analyzer.CorrectRate;                        % He didn't ask for this, but it is the most used metric
    precision = analyzer.PositivePredictiveValue;           % PositivePredictiveValue is the precision value, as decribed above
    recall = analyzer.Sensitivity;                          % Sensitivity is the recall value, as described above
    F1 = (2 * recall * precision) / (recall + precision);   % From slides
    [~, ~, ~, ROC] = perfcurve(trueClassifications, probabilityScores, 1);       % This function will calculate the AUC of the ROC curve (area under the curve)
end

