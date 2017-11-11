
twoClassPcaFeatureValues = csvread('allPcaInputMatrix.csv', 1, 2);  % Read in all of the feature values
twoClassPcaMetaData = csvread('allPcaInputMatrix.csv', 1);          % Read in the whole matrix again
twoClassPcaMetaData = twoClassPcaMetaData(:,[1,2]);                 % Keep only the first two columns which are the fileId and classification (eating/noneating)

% Perform PCA and recreate the feature matrix
[coeff,score,latent] = pca(twoClassPcaFeatureValues);
twoClassPcaOutput = twoClassPcaFeatureValues * coeff;

% Append the metadata to the new feature values
completePcaOutput = horzcat(twoClassPcaMetaData, twoClassPcaOutput);

% Now write it back to a file
dlmwrite('completeFeatureMatrix.csv', ('fileId, isEating, maxMin, dwt, slope, fourier, median'), '');
dlmwrite('completeFeatureMatrix.csv', completePcaOutput, 'delimiter', ',', '-append', 'precision', 13);



