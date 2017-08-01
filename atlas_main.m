clc; clear all; close all;
   tic

% %     R  %number of rows of image (depth) 
% %     C  %number of columns of image 
% 
% %% Browse an image in the PC
[filename,pathname]=uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*','All Files' },'mytitle',...
'Select an Image');
B= imread(fullfile(pathname,filename)); 
Image=im2double(B);
%  Image=medfilt2(Image);
Image=Image(:,:,1);

%  [x,y,rect]=Image  %% cropped image

[R,C]=size(Image);

%%%%%%%%%%%%%%%%%%%%%%%% Skin Process code
% input images

Image_norm_unlog=mat2gray (10.^ ((Image)./10));
 Image_norm_unlog=mat2gray(Image);
%  Image_norm_unlog = im2double(imread('thumb.tif')) ;
% [M,N] = size( Image_norm_unlog);
% PSNR = 15;
% % noisyImg = mainImg +(10^(-PSNR/20))*randn(M,N);
% addpath(genpath('BM3D'))
% %% BM3D Implementation
% sigma = 15;
  Image_norm_unlog=  Image_norm_unlog(:,:,1);
% [psnr, BM3D_Img] = BM3D( Image_norm_unlog, Image_norm_unlog,sigma);
%  background = imopen(BM3D_Img,strel('disk',200));
% %  background = imopen(BM3D_Img,strel('line', 5, 100));
% % figure;
% % %  subplot(121);
% %  imshow(mainImg,[]);
% % % subplot(122);
% % imshow(BM3D_Img,[]); 
% % % title('denoising using NLM');

% I2 = BM3D_Img - background;

figure;
imshow(Image_norm_unlog,[])
 axis tight


%% Clustering

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_of_clusters=4;
%% select 4 ROI
prompt = {'Enter ROI size, x:','Enter ROI size, y'};
dlg_title = 'Please choose 5 Signal ROIs';
num_lines = 1;
defaultans = {'20','20'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
ROI_coordinates=(str2num(cell2mat(answer)))';
ROI_x=ROI_coordinates(1);
ROI_y=ROI_coordinates(2);
close all
imagesc(I2)
colormap('gray')
% contourf(Image_norm_unlog,4);axis ij;
axis tight;
% imshow(CF,[]);colormap(jet)

ROI1=zeros(ROI_x+2,ROI_y+2,num_of_clusters);
ROI2=zeros(ROI_x+2,ROI_y+2,num_of_clusters);
ROI3=zeros(ROI_x+2,ROI_y+2,num_of_clusters);
% ROI4=zeros(ROI_x+2,ROI_y+2,num_of_clusters);

%% regions for Signal
 %% 15 is the number of speckle reduction filters
    for j=1: 1 %% number of clusters
        %%% 1st ROI
        waitforbuttonpress
        point2 = get(gcf,'CurrentPoint') % button down detected
        rect = [point2(1,1) point2(1,2) ROI_x ROI_y]
        [r1] = dragrect(rect)
        point1 = get(gca,'CurrentPoint') % button down detected
        r2 = [point1(1,2) point1(1,1) ROI_x ROI_y]
        z = [r2(2) r2(2) r2(2)+r2(4) r2(2)+r2(4) r2(2)]
        x = [r2(1) r2(1)-r2(3) r2(1)-r2(3) r2(1) r2(1)]
        hold on
        plot(z,x,'y')
        text(r2(2)+r2(4)/2,r2(1)-r2(3)/2,'1','color','y','FontSize',20,'FontWeight','bold')
        r2=round(r2)+1;
        

        ROI1(:,:,j)=Image_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
           
        avg_1(:,:,j)=mean(ROI1(:,:,j),2);  %% an Aline (a vector of pixel values along the Z axis) is extracted from the region
        avg_smooth_1(:,:,j)=smooth(smooth(avg_1(:,:,j)));
        x_1=1:length(avg_1(:,:,j));
        % figure, plot(x,avg)
%% fitting a polynomial equation to the Aline
       [k1_1,k2_1]= polyfit(x_1,avg_1(:,:,j)',1);
        p1_1(:,:,j)=k1_1(1);  %%% the polynomiyal expression is as ax+b or x*k1(1)+k1(2)
        p2_1(:,:,j)=k1_1(2);
        Feature_1 = MY_Fea_Extract(ROI1(:,:,j));
        entropy_1(j)=entropy(ROI1(:,:,j));
        median_1(j)=median(median(ROI1(:,:,j)));
        std_1(j)=std2((ROI1(:,:,j)));
        mean_1(j)=mean2((ROI1(:,:,j)));
        SKness_1(j)=skewness(skewness(ROI1(:,:,j)));
        Kurt_1(j)=kurtosis(kurtosis(ROI1(:,:,j)));
        
        %% 2nd ROI
        waitforbuttonpress
        point2 = get(gcf,'CurrentPoint') % button down detected
        rect = [point2(1,1) point2(1,2) ROI_x ROI_y]
        [r1] = dragrect(rect)
        point1 = get(gca,'CurrentPoint') % button down detected
        r2 = [point1(1,2) point1(1,1) ROI_x ROI_y]
        z = [r2(2) r2(2) r2(2)+r2(4) r2(2)+r2(4) r2(2)]
        x = [r2(1) r2(1)-r2(3) r2(1)-r2(3) r2(1) r2(1)]
        hold on
        plot(z,x,'y')
        text(r2(2)+r2(4)/2,r2(1)-r2(3)/2,'2','color','y','FontSize',20,'FontWeight','bold')
        r2=round(r2)+1;
        ROI2(:,:,j)=Image_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));

        avg_2(:,:,j)=mean(ROI2(:,:,j),2);  %% an Aline (a vector of pixel values along the Z axis) is extracted from the region
        avg_smooth_2(:,:,j)=smooth(smooth(avg_2(:,:,j)));
        x_2=1:length(avg_2(:,:,j));
        % figure, plot(x,avg)
%% fitting a polynomial equation to the Aline
       [k1_2,k2_2]= polyfit(x_2,avg_2(:,:,j)',1);
        p1_2(:,:,j)=k1_2(1);  %%% the polynomiyal expression is as ax+b or x*k1(1)+k1(2)
        p2_2(:,:,j)=k1_2(2);
          Feature_2 = MY_Fea_Extract(ROI2(:,:,j));
%         entropy_2(j)=entropy(ROI2(:,:,j));
%         median_2(j)=median(median(ROI2(:,:,j)));
%         std_2(j)=std2((ROI2(:,:,j)));
%         mean_2(j)=mean2((ROI2(:,:,j)));
%         SKness_2(j)=skewness(skewness(ROI2(:,:,j)));
%         Kurt_2(j)=kurtosis(kurtosis(ROI2(:,:,j)));
% %        
%     
        %%% 3rd ROI
        waitforbuttonpress
        point2 = get(gcf,'CurrentPoint') % button down detected
        rect = [point2(1,1) point2(1,2) ROI_x ROI_y]
       [r1] = dragrect(rect)
        point1 = get(gca,'CurrentPoint') % button down detected
        r2 = [point1(1,2) point1(1,1) ROI_x ROI_y]
        z = [r2(2) r2(2) r2(2)+r2(4) r2(2)+r2(4) r2(2)]
        x = [r2(1) r2(1)-r2(3) r2(1)-r2(3) r2(1) r2(1)]
        hold on
        plot(z,x,'y')
        text(r2(2)+r2(4)/2,r2(1)-r2(3)/2,'3','color','y','FontSize',20,'FontWeight','bold')
        r2=round(r2)+1;
        
        ROI3(:,:,j)=Image_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
    
        avg_3(:,:,j)=mean(ROI3(:,:,j),2);  %% an Aline (a vector of pixel values along the Z axis) is extracted from the region
        avg_smooth_3(:,:,j)=smooth(smooth(avg_3(:,:,j)));
        x_3=1:length(avg_3(:,:,j));
        % figure, plot(x,avg)
%% fitting a polynomial equation to the Aline
        [k1_3,k2_3]= polyfit(x_3,avg_3(:,:,j)',2);
        p1_3(:,:,j)=k1_3(1);  %%% the polynomiyal expression is as ax+b or x*k1(1)+k1(2)
        p2_3(:,:,j)=k1_3(2);
             Feature_3 = MY_Fea_Extract(ROI3(:,:,j));
%         entropy_3(j)=entropy(ROI3(:,:,j));
%         median_3(j)=median(median(ROI3(:,:,j)));
%         std_3(j)=std2((ROI3(:,:,j)));
%         mean_3(j)=mean2((ROI3(:,:,j)));
%         SKness_3(j)=skewness(skewness(ROI3(:,:,j)));
%         Kurt_3(j)=kurtosis(kurtosis(ROI3(:,:,j)));
                
%         %%% 4th ROI
%         waitforbuttonpress
%         point2 = get(gcf,'CurrentPoint') % button down detected
%         rect = [point2(1,1) point2(1,2) ROI_x ROI_y]
%         [r1] = dragrect(rect)
%         point1 = get(gca,'CurrentPoint') % button down detected
%         r2 = [point1(1,2) point1(1,1) ROI_x ROI_y]
%         z = [r2(2) r2(2) r2(2)+r2(4) r2(2)+r2(4) r2(2)]
%         x = [r2(1) r2(1)-r2(3) r2(1)-r2(3) r2(1) r2(1)]
%         hold on
%         plot(z,x,'y')
%         text(r2(2)+r2(4)/2,r2(1)-r2(3)/2,'4','color','y','FontSize',20,'FontWeight','bold')
%         r2=round(r2)+1;
%         
%         ROI4(:,:,j)=Image_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
% 
%         avg_4(:,:,j)=mean(ROI4(:,:,j),2);  %% an Aline (a vector of pixel values along the Z axis) is extracted from the region
%         avg_smooth_4(:,:,j)=smooth(smooth(avg_4(:,:,j)));
%         x_4=1:length(avg_4(:,:,j));
%         % figure, plot(x,avg)
% %% fitting a polynomial equation to the Aline
%        [k1_4,k2_4]= polyfit(x_4,avg_4(:,:,j)',2);
%         p1_4(:,:,j)=k1_4(1);  %%% the polynomiyal expression is as ax+b or x*k1(1)+k1(2)
%         p2_4(:,:,j)=k1_4(2);
% %         entropy_4(j)=entropy(ROI4(:,:,j));
% %         median_4(j)=median(median(ROI4(:,:,j)));
% %         mean_4(j)=mean2((ROI4(:,:,j)));
% %         SKness_4(j)=skewness(skewness(ROI4(:,:,j)));
% %         std_4(j)=std2((ROI4(:,:,j)));
% %         Kurt_4(j)=kurtosis(kurtosis(ROI4(:,:,j)));
%      Feature_4 = MY_Fea_Extract(ROI4(:,:,j));
    end
    
    toc
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    %%attenuation and features

%  for i=1: 4 %% 12 is the number of speckle reduction filters
%     for j=1: 4 %% number of clusters
%         %%% SNR calculation
%      aa=ROI1(:,:,j);
%      avg=mean(aa,2);  %% an Aline (a vector of pixel values along the Z axis) is extracted from the region
%  avg_smooth=smooth(smooth(avg));
%  x=1:length(avg);
% % figure, plot(x,avg)
% %% fitting a polynomial equation to the Aline
% [k1,k2]= polyfit(x,avg',1);
% p1(j)=k1(1);  %%% the polynomiyal expression is as ax+b or x*k1(1)+k1(2)
% p2(j)=k1(2);

%     end
%  end
% figure;
% plot(p1)
% figure
% % subplot(121)
% % subplot(122)
% 
% plot(avg,'r')
% hold on
% plot(avg_smooth,'k')
% hold on
% plot(x,x*k1(1)+k1(2))

