% Read in the PCA matrices
twoClassPcaMatrix = csvread('pcaMatrix.csv', 1, 1);
eatingMatrix = csvread('eatingPcaMatrix.csv',1,1);
nonEatingMatrix = csvread('noneatingPcaMatrix.csv', 1, 1);

% Perform PCA on the two different classes
[coeff,score,latent,tsquared,explained,mu] = pca(eatingMatrix);
nonEatingMatrix * pca(nonEatingMatrix);

