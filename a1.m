clc; 
clear all;
close all;
tic

%% Browse an image in the PC
[filename,pathname]=uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*','All Files' },'mytitle',...
'Select an Image');
B= imread(fullfile(pathname,filename)); 
orig_I=im2double(B);
orig_I=orig_I(:,:,1);

[~,y,cropped_I,rect]=imcrop(orig_I,[])  %% cropped image

   [R,C]=size(cropped_I);
   num_of_regions = 5 ;
  %% input images
orig_I_norm_log=orig_I;
cropped_I_norm_log=cropped_I;
orig_I_norm_unlog=MatrixNorm(unlogOCT(orig_I));
cropped_I_norm_unlog=MatrixNorm(unlogOCT(cropped_I));

orig_I_norm_unlog=255*orig_I_norm_unlog/max(orig_I_norm_unlog(:));
cropped_I_norm_unlog=255*cropped_I_norm_unlog/max(cropped_I_norm_unlog(:));
% Despeckling
% Original Images

nof=10;  %number_of_filters


% sigma = 25;
Options.kernelratio=4;
Options.windowratio=4;
Options.verbose=true;
Options.filterstrength=0.15;

addpath(genpath('NLMF'));
orig_NLM = NLMF_zhengguo(orig_I_norm_unlog,Options); %% F_1

% orig_NLM = NLmeansfilter(orig_I_norm_unlog,4,4,2);  


orig_ann = fdenoiseNeural(orig_I_norm_unlog, 25,{});%F 2

filtered_org(:,:,1)=orig_NLM;
filtered_org(:,:,2)=orig_ann;
 
addpath(genpath('TVGP.v2.0'))
verbose = 0;
GapTol = 10.^-3;
NIT = 1000;
lbd =  [0.03, 0.04, 0.05, 0.06];
for Ind = 1 : length(lbd) 
[M,N] = size(orig_I_norm_unlog);

[orig_TV, w1, w2, Energy, Dgap, TimeCost, itr] = ...
      TV_PDHG(zeros(M,N),zeros(M,N),double(orig_I_norm_unlog),lbd(Ind),NIT,GapTol,verbose);%F 3,4,5,6
  filtered_org(:,:,Ind+2) = orig_TV;
  
end

sigma =  [20, 40, 60];
for Ind = 1 : length(lbd) 
[M,N] = size(orig_I_norm_unlog);
addpath(genpath('BM3D'))
[~, orig_BM3D] = BM3D(orig_I_norm_unlog, orig_I_norm_unlog,sigma); %% %% F_,7,8,9
 filtered_org(:,:,Ind+6) = orig_BM3D;
end
 %% %% F_


%% cropped Images


addpath(genpath('NLMF'));
cropped_NLM = NLMF_zhengguo(cropped_I_norm_unlog,Options); %% F'_1

% orig_NLM = NLmeansfilter(orig_I_norm_unlog,4,4,2);  


cropped_ann = fdenoiseNeural(cropped_I_norm_unlog, 25,{});%F' 2

filtered_cropped(:,:,1)=cropped_NLM;%% %% F'_1
filtered_cropped(:,:,2)=cropped_ann; %% %% F'_2

for Ind = 1 : length(lbd) 
[M,N] = size(cropped_I_norm_unlog);

[cropped_TV, w1, w2, Energy, Dgap, TimeCost, itr] = ...
      TV_PDHG(zeros(M,N),zeros(M,N),double(cropped_I_norm_unlog),lbd(Ind),NIT,GapTol,verbose);%F' 3,4,5,6
  filtered_cropped(:,:,Ind+2) = orig_TV;
  
end

for Ind = 1 : length(lbd) 
[M,N] = size(cropped_I_norm_unlog);
addpath(genpath('BM3D'))
[~, cropped_BM3D] = BM3D(cropped_I_norm_unlog, cropped_I_norm_unlog,sigma); %% %% F'_,7,8,9
 filtered_cropped(:,:,Ind+6) = orig_BM3D;
end



close all
imshow(cropped_I_norm_unlog,[]);
%% select 5 ROI
prompt = {'Enter ROI size, x:','Enter ROI size, y'};
dlg_title = 'Please choose 5 Signal ROIs';
num_lines = 1;
defaultans = {'20','20'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
ROI_coordinates=(str2num(cell2mat(answer)))';
ROI_x=ROI_coordinates(1);
ROI_y=ROI_coordinates(2);



ROI1=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
ROI2=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
ROI3=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
ROI4=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
ROI5=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);

ROI_B=zeros(ROI_x+2,ROI_y+2,nof);

%% regions for Signal
 %% 15 is the number of speckle reduction filters
    for j=1: num_of_regions %% number of clusters
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
        
        for i=1:nof-1
            ROI1(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
        end
            ROI1(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));

        %%% 2nd ROI
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

        for i=1: nof-1
            ROI2(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
        end
            ROI2(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));


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
        
        for i=1: nof-1
            ROI3(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
        end
            ROI3(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
    

        %%% 4th ROI
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
        text(r2(2)+r2(4)/2,r2(1)-r2(3)/2,'4','color','y','FontSize',20,'FontWeight','bold')
        r2=round(r2)+1;
         for i=1: nof-1
            ROI4(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
         end
            ROI4(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));

        %%% 5th ROI
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
        text(r2(2)+r2(4)/2,r2(1)-r2(3)/2,'5','color','y','FontSize',20,'FontWeight','bold')
        r2=round(r2)+1;
        for i=1: nof-1
            ROI5(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
        end
            ROI5(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
    
     end 


%% regions for background
%% regions for Signal
close all
imshow(orig_I_norm_unlog,[]);
 %% 15 is the number of speckle reduction filters
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
        for i=1: nof-1
            ROI_B(:,:,i)=filtered_org(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
        end
            ROI_B(:,:,nof)=orig_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
        
%% calculation of SNRs and CNRs and features for despeckled images and %%%nof original image


for i=1: nof %% 15 is the number of speckle reduction filters num_filters
    for j=1: num_of_regions %% number of clusters
        
        %%% SNR calculation
        Blinear=max(max(ROI1(:,:,i,j)));
        ROI_B_v=ROI_B(:,:,i);
        variance=var(ROI_B_v(:)); 
        SNR1(i,j)=((Blinear^2)/variance);

        Blinear=max(max(ROI2(:,:,i,j)));
        ROI_B_v=ROI_B(:,:,i);
        variance=var(ROI_B_v(:));  
        SNR2(i,j)=((Blinear^2)/variance);
    
        Blinear=max(max(ROI3(:,:,i,j)));
        ROI_B_v=ROI_B(:,:,i);
        variance=var(ROI_B_v(:)); 
        SNR3(i,j)=((Blinear^2)/variance);

        Blinear=max(max(ROI4(:,:,i,j)));
        ROI_B_v=ROI_B(:,:,i);
        variance=var(ROI_B_v(:));  
        SNR4(i,j)=((Blinear^2)/variance);


        Blinear=max(max(ROI5(:,:,i,j)));
        ROI_B_v=ROI_B(:,:,i);
        variance=var(ROI_B_v(:));  
        SNR5(i,j)=((Blinear^2)/variance);


        SNR(i,j)=10*log10((SNR1(i,j)+SNR2(i,j)+SNR3(i,j)+SNR4(i,j)+SNR5(i,j))/5);
%         SNR(i,j)=mean(SNR(i,j),2);
        
        %%% CNR calculation
        uo_1(i,j)=mean2(ROI1(:,:,i,j));
        Std_1(i,j)=std2(ROI1(:,:,i,j));
        ub=mean2(ROI_B(:,:,i));
        Sb=std2(ROI_B(:,:,i));
        CNR1(i,j)=(uo_1(i,j)-ub)/sqrt(Std_1(i,j)^2+ Sb^2);
        
        uo_2(i,j)=mean2(ROI2(:,:,i,j));
        Std_2(i,j)=std2(ROI2(:,:,i,j));
        Sb=std2(ROI_B(:,:,i));
        ub=mean2(ROI_B(:,:,i));
        CNR2(i,j)=(uo_2(i,j)-ub)/sqrt(Std_2(i,j)^2+Sb^2);
        
              
        uo_3(i,j)=mean2(ROI3(:,:,i,j));
        Std_3(i,j)=std2(ROI3(:,:,i,j));
        ub=mean2(ROI_B(:,:,i));
        Sb=std2(ROI_B(:,:,i));
        CNR3(i,j)=(uo_3(i,j)-ub)/sqrt(Std_3(i,j)^2+ Sb^2);
        
        
        uo_4(i,j)=mean2(ROI4(:,:,i,j));
        Std_4(i,j)=std2(ROI4(:,:,i,j));
        ub=mean2(ROI_B(:,:,i));
        Sb=std2(ROI_B(:,:,i));
        CNR4(i,j)=(uo_4(i,j)-ub)/sqrt(Std_4(i,j)^2+ Sb^2);
        
        uo_5(i,j)=mean2(ROI5(:,:,i,j));
        Std_5(i,j)=std2(ROI5(:,:,i,j));
        ub=mean2(ROI_B(:,:,i));
        Sb=std2(ROI_B(:,:,i));
        CNR5(i,j)=(uo_5(i,j)-ub)/sqrt(Std_5(i,j)^2+ Sb^2);
        
        CNR(i,j)=(CNR1(i,j)+CNR2(i,j)+CNR3(i,j)+CNR4(i,j)+CNR5(i,j))/5;
%            CNR(i,j)=mean(CNR(i,j),2);
        
        %ENL calculation
    ROI_1=ROI1(:,:,i);
    ROI_2=ROI2(:,:,i);
    ROI_3=ROI3(:,:,i);
    ROI_4=ROI4(:,:,i);
    ROI_5=ROI5(:,:,i);
    ROI_b=ROI_B(:,:,i);
        
    enl_1(i,j)=uo_1(i,j)/var(ROI_1(:));
    enl_2(i,j)=uo_2(i,j)/var(ROI_2(:));
    enl_3(i,j)=uo_3(i,j)/var(ROI_3(:));
    enl_4(i,j)=uo_4(i,j)/var(ROI_4(:));
    enl_5(i,j)= uo_5(i,j)/var(ROI_5(:));
    enl(i,j)=enl_1(i,j)+enl_2(i,j)+enl_3(i,j)+enl_4(i,j)+enl_5(i,j)/5;
    
%     SSIM

 mssim_1(i,j) = ssim(ROI_B(:,:,i), ROI1(:,:,i,j));
 mssim_2(i,j) = ssim(ROI_B(:,:,i), ROI2(:,:,i,j));
 mssim_3(i,j) = ssim(ROI_B(:,:,i), ROI3(:,:,i,j));
 mssim_4(i,j) = ssim(ROI_B(:,:,i), ROI4(:,:,i,j));
 mssim_5(i,j) = ssim(ROI_B(:,:,i), ROI5(:,:,i,j));
 mssim(i,j)=mssim_1(i,j)+mssim_2(i,j)+mssim_3(i,j)+mssim_4(i,j)+mssim_5(i,j)/5;
           
        %Feature extarct
      
Final_Out1(:,:,i,j)  = glrlm(ROI1(:,:,i,j));
Final_Out2(:,:,i,j)  = glrlm(ROI2(:,:,i,j));
Final_Out3(:,:,i,j)  = glrlm(ROI3(:,:,i,j));
Final_Out4(:,:,i,j)  = glrlm(ROI4(:,:,i,j));
Final_Out5(:,:,i,j)  = glrlm(ROI5(:,:,i,j));
GLR(:,:,i)=(Final_Out1(:,:,i,j)+Final_Out2(:,:,i,j)+Final_Out3(:,:,i,j)+Final_Out4(:,:,i,j)+Final_Out5(:,:,i,j))/5;

         STT1(:,:,i,j)=MY_Fea_Extract(ROI1(:,:,i,j));
         STT2(:,:,i,j)=MY_Fea_Extract(ROI2(:,:,i,j));
         STT3(:,:,i,j)=MY_Fea_Extract(ROI3(:,:,i,j));
         STT4(:,:,i,j)=MY_Fea_Extract(ROI4(:,:,i,j));
         STT5(:,:,i,j)=MY_Fea_Extract(ROI5(:,:,i,j));
%        STTF(:,:,i)=(STT1(:,:,i,j)+STT2(:,:,i,j)+STT3(:,:,i,j)+STT4(:,:,i,j)+STT5(:,:,i,j))/5;
         STTF(:,:,i)=(STT1(:,:,i,j)+STT2(:,:,i,j)+STT3(:,:,i,j)+STT4(:,:,i,j)+STT5(:,:,i,j))/5;
        
       FEBOTH=[GLR;STTF];

   
% EPI_1(i,j) = epi(ROI_B(:,:,i),ROI_1(:,i,j));
% EPI_2(i,j) = epi(ROI_B(:,:,i),ROI_2(:,i,j));
% EPI_3(i,j) = epi(ROI_B(:,:,i),ROI_3(:,i,j));
% EPI_4(i,j) = epi(ROI_B(:,:,i),ROI_4(:,i,j));
% EPI_5(i,j) = epi(ROI_B(:,:,i),ROI_5(:,i,j));
% EPI(i,j)=EPI_1(i,j)+EPI_2(i,j)+EPI_3(i,j)+EPI_4(i,j)+EPI_5(i,j)/5;

      end
end
enlf=mean(enl,2);
CNRF=mean(CNR,2);
SNRF=mean(SNR,2);
MSSIM=mean(mssim,2);
% EPIF=mean(EPI,2);
toc

