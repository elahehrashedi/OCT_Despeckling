clear all
close all
clc
mainImg = im2double(imread('153.tif')) ;

Options.kernelratio=4;
Options.windowratio=4;
Options.verbose=true;
Options.filterstrength=0.15;
addpath(genpath('NLMF'))
%% NLM Implementation
sigma = 25;
mainImg = mainImg(:,:,1);
NLM_Img = NLMF_zhengguo(mainImg,Options);

figure;
subplot(121); imshow(mainImg,[]);
subplot(122);imshow(NLM_Img,[]); 
title('denoising using NLM');