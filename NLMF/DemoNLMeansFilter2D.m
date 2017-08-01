function DemoNLMeansFilter2D

I = im2double(imread('a.jpg')) ;
I = imresize( I, 0.25*size(I) ) ;
Options.kernelratio=4;
Options.windowratio=4;
Options.verbose=true;
Options.filterstrength=0.1;
J = NLMF_zhengguo(I,Options);
figure,
subplot(1,2,1),imshow(I); title('Noisy image')
subplot(1,2,2),imshow(J); title('NL-means image');