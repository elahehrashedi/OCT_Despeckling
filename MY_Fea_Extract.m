function Feature = MY_Fea_Extract(I)
% I is input ROI image in double format
% Following is an example:
% I = im2double(imread('circuit.tif'));
% f = MY_Fea_Extract(I);
GLCM = graycomatrix(I,'offset', [0 1]);
GLCM0 = graycoprops(GLCM,{'all'});  % 0 degree
GLCM0.SD_x = std(GLCM,[],2);
GLCM0.SD_y = std(GLCM);
GLCM0.Entropy = entropy(GLCM);

GLCM = graycomatrix(I,'offset', [-1 1]);
GLCM45 = graycoprops(GLCM,{'all'}); % 45
GLCM45.SD_x = std(GLCM,[],2);
GLCM45.SD_y = std(GLCM);
GLCM45.Entropy = entropy(GLCM);

GLCM = graycomatrix(I,'offset', [-1 0]);
GLCM90 = graycoprops(GLCM,{'all'}); % 90 
GLCM90.SD_x = std(GLCM,[],2);
GLCM90.SD_y = std(GLCM);
GLCM90.Entropy = entropy(GLCM);

GLCM = graycomatrix(I,'offset', [-1 -1]);
GLCM135 = graycoprops(GLCM,{'all'});% 135
GLCM135.SD_x = std(GLCM,[],2);
GLCM135.SD_y = std(GLCM);
GLCM135.Entropy = entropy(GLCM);

Feature = [std(I(:)); mean(I(:));entropy(I); median(I(:)); skewness(I(:));...
    kurtosis(I(:)); var(I(:)); ...
    GLCM0.Contrast; GLCM0.Correlation; GLCM0.Energy; GLCM0.Homogeneity;...
    GLCM0.Entropy; ...
    GLCM45.Contrast; GLCM45.Correlation; GLCM45.Energy; GLCM45.Homogeneity;...
    GLCM45.Entropy; ...
    GLCM90.Contrast; GLCM90.Correlation; GLCM90.Energy; GLCM90.Homogeneity;...
    GLCM90.Entropy; ...
    GLCM135.Contrast; GLCM135.Correlation; GLCM135.Energy; GLCM135.Homogeneity;...
    GLCM135.Entropy];
end

