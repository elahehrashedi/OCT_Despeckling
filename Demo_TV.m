clear all
% close all
clc
noisy1 = 255 * im2double(imread('245.tif')) ;
noisy1 = noisy1(:,:,1);
% noisy1 = imresize(noisy1,[452,452]);
addpath(genpath('TVGP.v2.0'))
%%
verbose = 0;
GapTol = 10.^-3;
NIT = 1000;
lbd =  0.05;
[M,N] = size(noisy1);

[u, w1, w2, Energy, Dgap, TimeCost, itr] = ...
      TV_PDHG(zeros(M,N),zeros(M,N),double(noisy1),lbd,NIT,GapTol,verbose);

figure;
subplot(221); imshow(noisy1,[]);
subplot(222);imshow(u,[]); 
% title('denoising using TV-PDHG');
noisy1 = 255 * im2double(imread('Picture3.tif')) ;
noisy1 = noisy1(:,:,1);
% noisy1 = imresize(noisy1,[452,452]);
addpath(genpath('TVGP.v2.0'))
%%
verbose = 0;
GapTol = 10.^-3;
NIT = 1000;
lbd =  0.05;
[M,N] = size(noisy1);

[u, w1, w2, Energy, Dgap, TimeCost, itr] = ...
      TV_PDHG(zeros(M,N),zeros(M,N),double(noisy1),lbd,NIT,GapTol,verbose);

% figure;
subplot(223); imshow(noisy1,[]);
subplot(224);imshow(u,[]); 
% title('denoising using TV-PDHG');
