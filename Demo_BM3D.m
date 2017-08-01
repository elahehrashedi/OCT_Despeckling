clear all
close all
clc
% mainImg = 255 * im2double(imread('245.tif')) ;
mainImg =  im2double(imread('245.tif')) ;
[M,N] = size(mainImg);
% PSNR = 20;
% noisyImg = mainImg +(10^(-PSNR/20))*randn(M,N);
addpath(genpath('BM3D'))
%% BM3D Implementation
sigma = 20;
mainImg = mainImg(:,:,1);
[~, BM3D_Img] = BM3D(mainImg, mainImg,sigma);

figure; 
%subplot(121); imshow(mainImg)
%subplot(122); imshow(BM3D_Img,[])