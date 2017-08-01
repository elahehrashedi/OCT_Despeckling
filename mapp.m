%%% Main file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Matlab parameters
clc; close all; clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Parameters
window_size = 3;
nb_graylevels = 4;
distance = 1;
direction = [0 distance];
min_norm = 0;
max_norm = 255;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Start the counter time
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Read image
im_in  = double(imread('bcc_31.tif'));

%%% Convert the image in grayscale
 imgray_in = mat2gray(im_in);
%%% Resize the image
% imgray_in = imresize(imgray_in, 0.5);
%%% Compute parameters of image
[height_im, width_im] = size(imgray_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% R-IMG pre-allocation
contrast_rimg = zeros(height_im -(window_size-1),width_im -(window_size-1));
energy_rimg = zeros(height_im -(window_size-1),width_im -(window_size-1));
homogeneity_rimg = zeros(height_im -(window_size-1),width_im -(window_size-1));
entropy_rimg = zeros(height_im -(window_size-1),width_im -(window_size-1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Computation of stats')
%%% Create R-Img for each possible pixel
for row = ((window_size + 1)/2):(height_im - ((window_size - 1)/2))
for col = ((window_size + 1)/2):(width_im - ((window_size - 1)/2))
%%% Compute statistics for the new pixel
comatrix = graycomatrix(imgray_in((row - ((window_size -1)/2)):(row + ((window_size -1)/2)),(col - ((window_size - 1)/2)):(col + ((window_size -1)/2))),'NumLevels',nb_graylevels,'Offset',direction);
stats = graycoprops(comatrix,{'Contrast','Energy','Homogeneity'});
contrast_rimg((row - (window_size + 1)/2) + 1,(col - (window_size + 1)/2) + 1) = stats.Contrast;
energy_rimg((row - (window_size + 1)/2) + 1,(col - (window_size + 1)/2) + 1) = stats.Energy;
homogeneity_rimg((row - (window_size + 1)/2) + 1,(col - (window_size + 1)/2) + 1) = stats.Homogeneity;
% entropy_rimg((row - (window_size + 1)/2) + 1,(col - (window_size + 1)/2) + 1) = entropy_comp(comatrix);
end
end
disp('stats computed')
%%% Apply the normalization
%%% Normalize the matrix image between 0.0 and 1.0
contrast_rimg_abs_norm = mat2gray(contrast_rimg);
energy_rimg_abs_norm = mat2gray(energy_rimg);
homogeneity_rimg_abs_norm = mat2gray(homogeneity_rimg);
entropy_rimg_abs_norm = mat2gray(entropy_rimg);
%%% Normalize the matrix image between a minimum value and maximum value
contrast_rimg_min_max_norm = mat2gray(contrast_rimg,[min_norm max_norm]);
energy_rimg_min_max_norm = mat2gray(energy_rimg,[min_norm max_norm]);
homogeneity_rimg_min_max_norm = mat2gray(homogeneity_rimg,[min_norm max_norm]);
entropy_rimg_min_max_norm = mat2gray(entropy_rimg,[min_norm max_norm]);
%%% Normalize the matrix image between 0 and 255
contrast_rimg_0_255 = uint8(contrast_rimg_min_max_norm * 255);
energy_rimg_0_255 = uint8(energy_rimg_min_max_norm * 255);
homogeneity_rimg_0_255 = uint8(homogeneity_rimg_min_max_norm * 255);
entropy_rimg_0_255 = uint8(entropy_rimg_min_max_norm * 255);
%%% Stop the counter time
toc
%%% Plot image
figure;
subplot(2,2,1);
imshow(imgray_in,[]);
title('original image');
%%% Contrast
subplot(2,2,2);
imshow(contrast_rimg_abs_norm,[]);
title('Contrast image');
%%% Energy
subplot(2,2,3);
imshow(energy_rimg_abs_norm,[]);
title('Energy image');
%%% Homogeneity
subplot(2,2,4);
imshow(homogeneity_rimg_abs_norm,[]);
title('Homogeneity image');

figure;
subplot(2,2,1);
imshow(imgray_in,[]);
title('original');
%%% Contrast
subplot(2,2,2);
imshow(contrast_rimg_0_255,[]);
title('Contrast image');
%%% Energy
subplot(2,2,3);
imshow(energy_rimg_0_255,[]);
title('Energy image');
%%% Homogeneity
subplot(2,2,4);
imshow(homogeneity_rimg_0_255,[]);
title('Homogeneity image');
%% Entropy
subplot(2,2,4);
imshow(entropy_rimg_abs_norm);
title('Entropy image');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function to compute entropy statistic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [entropy] = entropy_comp (comatrix)
%%% Computation of the size of the comatrix
[height_im,width_im] = size(comatrix);
%%% Intialisation
entropy = 0;
for i = 1:height_im
for j = 1:width_im
if( comatrix(i,j)~= 0 )
entropy = entropy + (comatrix(i,j)*log2(comatrix(i,j)));
end
end
 end
entropy = - entropy;

