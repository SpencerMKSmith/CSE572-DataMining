overall=csvread('noneatingPcaMatrix.csv',1,0);
overall=overall(:,2:end);
[coeff,score,latent]=pca(overall);
new_overall=overall*coeff;
