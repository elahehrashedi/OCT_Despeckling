% clear all;
% I=imread('nail.tif');
% I=double(I(:,:,1));
  I=wiener2(I,3);
 background = imopen(NLM_Img,strel('disk',100));

% background = imopen(I,strel('line', 5, 45));
figure;
imshow(NLM_Img ,[])
I2 = NLM_Img - background;
figure;imshow(I2,[])
% I2=rgb2gray(I2);I3 = imadjust(I2);
% figure;imshow(I3,[]);

% BW3 = bwmorph(I,'skel',Inf);
% BW3 = bwmorph(I,'remove');
% figure
% imshow(BW3)