
% the starting point if StartDemo.m function
% StartDemo function calls main_fun_saba
% This is the Main_SABA_CNR file which is correct for CNR 03/13/2017 

function main_func_saba (src_path, result_path, image_filename, image_id, input_index, num_of_regions, nof)

    %load ROI
    ROI_filename = [result_path num2str(image_id) '_ROI.mat'];
    if exist(ROI_filename, 'file') == 2
        %it means there is already an ROI exist for this image
        display (sprintf('@@@@@@@@@@@@@ ROI exists for %s .',image_filename));
    else
        display (sprintf('@@@@@@@@@@@@@ ROI doesnt exists for %s . Please choose an ROI first',image_filename)); 
        return;
    end
    % if  workspace is already available for this image, then return
    % if you don't want to use previous workspace you ahve to delete it
    % manually
    Workspace_filename = [result_path num2str(image_id) '_Wspace.mat'];
    if exist(Workspace_filename, 'file') == 2
        %it means there is already workspace exist for this image
        display (sprintf('@@@@@@@@@@@@@ Workspace already exists for %s .',image_filename));
        return;
    end
    load (ROI_filename);

    %% Browse an image in the PC
    %[filename,pathname]=uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
    %    '*.*','All Files' },'mytitle',...
    %'Select an Image');
    B = imread(fullfile(src_path,image_filename)); 
    orig_I=im2double(B);
    orig_I=orig_I(:,:,1);

    cropped_I = orig_I (crop_rect(2):crop_rect(2)+crop_rect(4),crop_rect(1):crop_rect(1)+crop_rect(3));
    
    %imshow (cropped_I); title('running algorithm on Cropped Image');
    %[~,y,cropped_I,rect]=imcrop(orig_I,[])  %% cropped image
	%[R,C]=size(cropped_I);
	%num_of_regions = 5 ;
   
    %% input images
    %orig_I_norm_log=orig_I;
    %cropped_I_norm_log=cropped_I;
    orig_I_norm_unlog=MatrixNorm((orig_I));
    cropped_I_norm_unlog=MatrixNorm((cropped_I));
    % for SNR
    %orig_I_norm_unlog_SNR=MatrixNorm(unlogOCT(orig_I));
    %cropped_I_norm_unlog_SNR=MatrixNorm(unlogOCT(cropped_I));
      
    
    % Despeckling
    % Original Images

    %nof=27;  %number_of_filters

    orig_median_3=medfilt2(orig_I_norm_unlog,[3,3]);  %% F1
    orig_median_5=medfilt2(orig_I_norm_unlog,[5,5]);  %% F2
    orig_median_7=medfilt2(orig_I_norm_unlog,[7,7]);  %% F3
    orig_median_9=medfilt2(orig_I_norm_unlog,[9,9]);%% F4

    orig_mean_3 = Windowmeanfilter(orig_I_norm_unlog,3);  %% F5
    orig_mean_5 = Windowmeanfilter(orig_I_norm_unlog,5);  %% F6
    orig_mean_7 = Windowmeanfilter(orig_I_norm_unlog,7);  %% F7
    orig_mean_9 = Windowmeanfilter(orig_I_norm_unlog,9);  %% F8

    orig_Kuwahara_5 = Kuwahara(orig_I_norm_unlog,5);  %% F9
    orig_Kuwahara_9 = Kuwahara(orig_I_norm_unlog,9);  %% F10

    orig_SNN_3= snn_2(orig_I_norm_unlog,3);  %% F 11
    orig_SNN_5= snn_2(orig_I_norm_unlog,5);  %% F_12
    orig_SNN_7= snn_2(orig_I_norm_unlog,7);  %% F_13
    orig_SNN_9= snn_2(orig_I_norm_unlog,9);  %% F_14

    orig_Winer_3 = wiener2(orig_I_norm_unlog,3);  %% F 15
    orig_Winer_5 = wiener2(orig_I_norm_unlog,5);  %% F_16
    orig_Winer_7 = wiener2(orig_I_norm_unlog,7);  %% F_17
    orig_Winer_9 = wiener2(orig_I_norm_unlog,9);  %% F_18

    orig_Lee = myLee(orig_I_norm_unlog);  %% F_19
    orig_Lee_5 = myLee5(orig_I_norm_unlog);  %% F_20
    orig_Lee_7 = myLee7(orig_I_norm_unlog);  %% F_21
    orig_Lee_9 = myLee9(orig_I_norm_unlog);  %% F_22

    % orig_Wmedian = wmedian(orig_I_norm_unlog);  %% F_23

    sigma = 25;
    Options.kernelratio=4;
    Options.windowratio=4;
    Options.verbose=true;
    Options.filterstrength=0.15;

    addpath(genpath('NLMF'));
    orig_NLM = NLMF_zhengguo(orig_I_norm_unlog,Options); %% F_24
    %orig_NLM = NLMF_zhengguo(255*orig_I_norm_unlog,Options); %% F_24
    %orig_NLM = NLMF_zhengguo(orig_I,Options); %% F_24


    % orig_NLM = NLmeansfilter(orig_I_norm_unlog,4,4,2);  

    addpath(genpath('BM3D'))
    %[~, orig_BM3D] = BM3D(orig_I_norm_unlog, orig_I_norm_unlog,sigma); %% %% F_25
    [~, orig_BM3D] = BM3D(255*orig_I_norm_unlog, 255*orig_I_norm_unlog,sigma); %% %% F_25

    addpath(genpath('TVGP.v2.0'))
    verbose = 0;
    GapTol = 10.^-3;
    NIT = 1000;
    lbd =  0.05;
    [M,N] = size(orig_I_norm_unlog);

    [orig_TV, w1, w2, Energy, Dgap, TimeCost, itr] = ...
          TV_PDHG(zeros(M,N),zeros(M,N),255*double(orig_I_norm_unlog),lbd,NIT,GapTol,verbose);%F 26

      orig_ann = fdenoiseNeural(orig_I_norm_unlog, 25,{});%F 27
  
  

    filtered_org(:,:,1)=orig_median_3;
    filtered_org(:,:,2)=orig_median_5;
    filtered_org(:,:,3)=orig_median_7;
    filtered_org(:,:,4)=orig_median_9;

    filtered_org(:,:,5)=orig_mean_3;
    filtered_org(:,:,6)=orig_mean_5;
    filtered_org(:,:,7)=orig_mean_7;
    filtered_org(:,:,8)=orig_mean_9;

    filtered_org(:,:,9)=orig_Kuwahara_5;
    filtered_org(:,:,10)=orig_Kuwahara_9;

    filtered_org(:,:,11)=orig_SNN_3;
    filtered_org(:,:,12)=orig_SNN_5;
    filtered_org(:,:,13)=orig_SNN_7;
    filtered_org(:,:,14)=orig_SNN_9;

    filtered_org(:,:,15)=orig_Winer_3;
    filtered_org(:,:,16)=orig_Winer_5;
    filtered_org(:,:,17)=orig_Winer_7;
    filtered_org(:,:,18)=orig_Winer_9;

    filtered_org(:,:,19)=orig_Lee;
    filtered_org(:,:,20)=orig_Lee_5;
    filtered_org(:,:,21)=orig_Lee_7;
    filtered_org(:,:,22)=orig_Lee_9; 

    % filtered_org(:,:,23)=orig_Wmedian;

    filtered_org(:,:,23)=orig_NLM;
    filtered_org(:,:,24)=orig_TV;
    filtered_org(:,:,25)=orig_BM3D;
    filtered_org(:,:,26)=orig_ann; 


    %% cropped Images
    cropped_median_3=medfilt2(cropped_I_norm_unlog,[3,3]);  %% F'1
    cropped_median_5=medfilt2(cropped_I_norm_unlog,[5,5]);  %% F'2
    cropped_median_7=medfilt2(cropped_I_norm_unlog,[7,7]);  %% F'3
    cropped_median_9=medfilt2(cropped_I_norm_unlog,[9,9]);  %% F'4

    cropped_mean_3 = Windowmeanfilter(cropped_I_norm_unlog,3);  %% F'5
    cropped_mean_5 = Windowmeanfilter(cropped_I_norm_unlog,5);  %% F'6
    cropped_mean_7 = Windowmeanfilter(cropped_I_norm_unlog,7);  %% F'7
    cropped_mean_9 = Windowmeanfilter(cropped_I_norm_unlog,9);  %% F'8

    cropped_Kuwahara_5 = Kuwahara(cropped_I_norm_unlog,5);  %% F'9
    cropped_Kuwahara_9 = Kuwahara(cropped_I_norm_unlog,9);  %% F'10

    cropped_SNN_3= snn_2(cropped_I_norm_unlog,3);  %% F'11
    cropped_SNN_5 = snn_2(cropped_I_norm_unlog,5);  %% F'12
    cropped_SNN_7 = snn_2(cropped_I_norm_unlog,7);  %% F'13
    cropped_SNN_9 = snn_2(cropped_I_norm_unlog,9);  %% F'14

    cropped_Winer_3 =wiener2(cropped_I_norm_unlog,3);  %% F'15
    cropped_Winer_5 = wiener2(cropped_I_norm_unlog,5);  %% F'16
    cropped_Winer_7 = wiener2(cropped_I_norm_unlog,7);  %% F'17
    cropped_Winer_9 = wiener2(cropped_I_norm_unlog,9);  %% F'18

    cropped_Lee=myLee(cropped_I_norm_unlog);%% F'19
    cropped_Lee_5=myLee5(cropped_I_norm_unlog);%% F'20
    cropped_Lee_7=myLee7(cropped_I_norm_unlog);%% F'21
    cropped_Lee_9=myLee9(cropped_I_norm_unlog);%% F'22

    cropped_NLM = NLMF_zhengguo(255*cropped_I_norm_unlog,Options);
    %cropped_NLM = NLMF_zhengguo(cropped_I,Options);

    %[~,cropped_BM3D] = BM3D(cropped_I_norm_unlog, cropped_I_norm_unlog,sigma);
    [~,cropped_BM3D] = BM3D(255*cropped_I, 255*cropped_I,sigma);

    addpath(genpath('TVGP.v2.0'))
    verbose = 0;
    GapTol = 10.^-3;
    NIT = 1000;
    lbd =  0.05;
    [M,N] = size( cropped_I_norm_unlog);

    [cropped_TV, w1, w2, Energy, Dgap, TimeCost, itr] = ...
          TV_PDHG(zeros(M,N),zeros(M,N),double( cropped_I_norm_unlog),lbd,NIT,GapTol,verbose);%F 26

     cropped_ann = fdenoiseNeural(cropped_I_norm_unlog, 25,{});


    filtered_cropped(:,:,1)=cropped_median_3;
    filtered_cropped(:,:,2)=cropped_median_5;
    filtered_cropped(:,:,3)=cropped_median_7;
    filtered_cropped(:,:,4)=cropped_median_9;

    filtered_cropped(:,:,5)=cropped_mean_3;
    filtered_cropped(:,:,6)=cropped_mean_5;
    filtered_cropped(:,:,7)=cropped_mean_7;
    filtered_cropped(:,:,8)=cropped_mean_9;

    filtered_cropped(:,:,9)=cropped_Kuwahara_5;
    filtered_cropped(:,:,10)=cropped_Kuwahara_9;

    filtered_cropped(:,:,11)=cropped_SNN_3;
    filtered_cropped(:,:,12)=cropped_SNN_5;
    filtered_cropped(:,:,13)=cropped_SNN_7;
    filtered_cropped(:,:,14)=cropped_SNN_9;

    filtered_cropped(:,:,15)=cropped_Winer_3;
    filtered_cropped(:,:,16)=cropped_Winer_5;
    filtered_cropped(:,:,17)=cropped_Winer_7;
    filtered_cropped(:,:,18)=cropped_Winer_9;

    filtered_cropped(:,:,19)=cropped_Lee;
    filtered_cropped(:,:,20)=cropped_Lee_5;
    filtered_cropped(:,:,21)=cropped_Lee_7;
    filtered_cropped(:,:,22)=cropped_Lee_9;


    filtered_cropped(:,:,23)=cropped_NLM;
    filtered_cropped(:,:,24)=cropped_BM3D;
    filtered_cropped(:,:,25)=cropped_TV;
    filtered_cropped(:,:,26)=cropped_ann;


    close all
    imshow(cropped_I_norm_unlog,[]);

    %% select 5 ROI
    % prompt = {'Enter ROI size, x:','Enter ROI size, y'};
    % dlg_title = 'Please choose 5 Signal ROIs';
    % num_lines = 1;
    % defaultans = {'20','20'};
    % answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    % ROI_coordinates=(str2num(cell2mat(answer)))';
    % ROI_x=ROI_coordinates(1);
    % ROI_y=ROI_coordinates(2);

    
    % all other than SNR
    ROI1=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI2=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI3=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI4=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI5=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI_B=zeros(ROI_x+2,ROI_y+2,nof);
    
    try
        %% regions for Signal
        %% 15 is the number of speckle reduction filters
        for j=1: num_of_regions %% number of clusters        
            % ROI1---------------------------------------------------------------------------
            r2 = list_of_recs ((j-1)*num_of_regions+1,:);
            for i=1:nof-1
                ROI1(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
            end
                ROI1(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
            % ROI2---------------------------------------------------------------------------
            r2 = list_of_recs ((j-1)*num_of_regions+2,:);
            for i=1: nof-1
                ROI2(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
            end
                ROI2(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
            % ROI3---------------------------------------------------------------------------       
            r2 = list_of_recs ((j-1)*num_of_regions+3,:);
            for i=1: nof-1
                ROI3(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
            end
                ROI3(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
            % ROI4---------------------------------------------------------------------------       
            r2 = list_of_recs ((j-1)*num_of_regions+4,:);
             for i=1: nof-1
                ROI4(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
             end
                ROI4(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
            % ROI5---------------------------------------------------------------------------
            r2 = list_of_recs ((j-1)*num_of_regions+5,:);
            for i=1: nof-1
                ROI5(:,:,i,j)=filtered_cropped(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
            end
                ROI5(:,:,nof,j)=cropped_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));   
        end 


        %% regions for background
        %% regions for Signal
        close all
        imshow(orig_I_norm_unlog,[]);
        r2 = list_of_recs (num_of_regions*num_of_regions+1,:);
        for i=1: nof-1
            ROI_B(:,:,i)=filtered_org(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4),i);
        end
            ROI_B(:,:,nof)=orig_I_norm_unlog(r2(1)-r2(3): r2(1), r2(2): r2(2)+r2(4));
        
        %% calculation of SNRs and CNRs and features for despeckled images and %%%nof original image
    catch ME
        % if dimension mismatch
        display (sprintf('&&&&&&&&&&************=> do it again for this file : %s .',image_filename));
        return;
    end

    for i=1: nof %% 15 is the number of speckle reduction filters num_filters
        for j=1: num_of_regions %% number of clusters

            % %%% SNR calculation
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
            %CNR(i,j)=mean(CNR(i,j),2);

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
            enl(i,j)=(enl_1(i,j)+enl_2(i,j)+enl_3(i,j)+enl_4(i,j)+enl_5(i,j))/5;

            % SSIM

            MSSIM_median_3 = ssim(orig_I_norm_unlog, orig_median_3);
            MSSIM_median_5 = ssim(orig_I_norm_unlog, orig_median_5);
            MSSIM_median_7 = ssim(orig_I_norm_unlog, orig_median_7);
            MSSIM_median_9 = ssim(orig_I_norm_unlog, orig_median_9);

            MSSIM_mean_3 = ssim(orig_I_norm_unlog, orig_mean_3);
            MSSIM_mean_5 = ssim(orig_I_norm_unlog, orig_mean_5);
            MSSIM_mean_7 = ssim(orig_I_norm_unlog, orig_mean_7);
            MSSIM_mean_9 = ssim(orig_I_norm_unlog, orig_mean_9);

            MSSIM_Kuwahara_5=ssim(orig_I_norm_unlog, orig_Kuwahara_5);
            MSSIM_Kuwahara_9=ssim(orig_I_norm_unlog, orig_Kuwahara_9);

            MSSIM_SNN_3 = ssim(orig_I_norm_unlog, orig_SNN_3);
            MSSIM_SNN_5 = ssim(orig_I_norm_unlog, orig_SNN_5);
            MSSIM_SNN_7 = ssim(orig_I_norm_unlog, orig_SNN_7);
            MSSIM_SNN_9 = ssim(orig_I_norm_unlog, orig_SNN_9);

            MSSIM_Winer_3 = ssim(orig_I_norm_unlog, orig_Winer_3);
            MSSIM_Winer_5 = ssim(orig_I_norm_unlog, orig_Winer_5);
            MSSIM_Winer_7 = ssim(orig_I_norm_unlog, orig_Winer_7);
            MSSIM_Winer_9 = ssim(orig_I_norm_unlog, orig_Winer_9);

            MSSIM_Lee_3 = ssim(orig_I_norm_unlog, orig_Lee);
            MSSIM_Lee_5 = ssim(orig_I_norm_unlog, orig_Lee_5);
            MSSIM_Lee_7 = ssim(orig_I_norm_unlog, orig_Lee_7);
            MSSIM_Lee_9 = ssim(orig_I_norm_unlog, orig_Lee_9);

            MSSIM_NLM = ssim(orig_I_norm_unlog, orig_NLM);
            MSSIM_TV = ssim(orig_I_norm_unlog, orig_TV);
            MSSIM_BM3D = ssim(orig_I_norm_unlog, orig_BM3D);
            MSSIM_ann = ssim(orig_I_norm_unlog, orig_ann);
            MSSIM_org = ssim(orig_I_norm_unlog, orig_I_norm_unlog);

            %   EPI = epi(orig_I_norm_unlog, filtered_org(:,:,i));
            % orig_I_norm_unlog orig_mean_3 orn orig_TV orig_mean_5 Ella
            Mepi_median_3 = epi(orig_mean_5, orig_median_3);
            Mepi_median_5 = epi(orig_mean_5, orig_median_5);
            Mepi_median_7 = epi(orig_mean_5, orig_median_7);
            Mepi_median_9 = epi(orig_mean_5, orig_median_9);

            Mepi_mean_3 = epi(orig_mean_5, orig_mean_3);
            Mepi_mean_5 = epi(orig_mean_5, orig_mean_5);
            Mepi_mean_7 = epi(orig_mean_5, orig_mean_7);
            Mepi_mean_9 = epi(orig_mean_5, orig_mean_9);

            Mepi_Kuwahara_5=epi(orig_mean_5, orig_Kuwahara_5);
            Mepi_Kuwahara_9=epi(orig_mean_5, orig_Kuwahara_9);


            Mepi_SNN_3 = epi(orig_mean_5, orig_SNN_3);
            Mepi_SNN_5 = epi(orig_mean_5, orig_SNN_5);
            Mepi_SNN_7 = epi(orig_mean_5, orig_SNN_7);
            Mepi_SNN_9 = epi(orig_mean_5, orig_SNN_9);

            Mepi_Winer_3 = epi(orig_mean_5, orig_Winer_3);
            Mepi_Winer_5 = epi(orig_mean_5, orig_Winer_5);
            Mepi_Winer_7 = epi(orig_mean_5, orig_Winer_7);
            Mepi_Winer_9 = epi(orig_mean_5, orig_Winer_9);

            Mepi_Lee_3 = epi(orig_mean_5, orig_Lee);
            Mepi_Lee_5 = epi(orig_mean_5, orig_Lee_5);
            Mepi_Lee_7 = epi(orig_mean_5, orig_Lee_7);
            Mepi_Lee_9 = epi(orig_mean_5, orig_Lee_9);


            Mepi_NLM = epi(orig_mean_5, orig_NLM);
            Mepi_TV = epi(orig_mean_5, orig_TV/255); %Ella 24
            Mepi_BM3D = epi(orig_mean_5, orig_BM3D); %25
            Mepi_ann = epi(orig_mean_5, orig_ann);
            Mepi_org = epi(orig_mean_5, orig_I_norm_unlog);


            % if (isinteger(Mepi_median_3) && isinteger(Mepi_median_5) && isinteger(Mepi_median_7) && isinteger(Mepi_median_9) ...
            % && isinteger (Mepi_mean_3) && isinteger (Mepi_mean_5) && isinteger (Mepi_mean_7) && isinteger (Mepi_mean_9) ...
            % && isinteger (Mepi_Kuwahara_5) && isinteger (Mepi_Kuwahara_9) ...
            % && isinteger (Mepi_SNN_3) && isinteger (Mepi_SNN_5) && isinteger (Mepi_SNN_7) && isinteger (Mepi_SNN_9) ...
            % && isinteger (Mepi_Winer_3) && isinteger (Mepi_Winer_5) && isinteger (Mepi_Winer_7) && isinteger (Mepi_Winer_9) ...
            % && isinteger (Mepi_Lee_3) && isinteger (Mepi_Lee_5) && isinteger (Mepi_Lee_7) && isinteger (Mepi_Lee_9) ...
            % && isinteger (Mepi_NLM) && isinteger (Mepi_TV) && isinteger (Mepi_BM3D) && isinteger(Mepi_ann) )
            % display ('imaginary') ; 
            % end

            %Feature extarct
            try
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
                STTF(:,:,i)=(STT1(:,:,i,j)+STT2(:,:,i,j)+STT3(:,:,i,j)+STT4(:,:,i,j)+STT5(:,:,i,j))/5;

                FEBOTH=[GLR;STTF];
            catch ME
                display (sprintf('&&&&&&&&&&************=> do it again for this file : %s .',image_filename));
            end
        end% for j
    end%for i
    
    enlf = mean(enl,2);
    enlf = abs (enlf);
    CNRF = mean(CNR,2);
    CNRF = abs (CNRF);

    MSSIM=[MSSIM_median_3 ,MSSIM_median_5, MSSIM_median_7,MSSIM_median_9,...
    MSSIM_mean_3 ,MSSIM_mean_5, MSSIM_mean_7,MSSIM_mean_9,MSSIM_Kuwahara_5,MSSIM_Kuwahara_9,...
    MSSIM_SNN_3,MSSIM_SNN_5,MSSIM_SNN_7,MSSIM_SNN_9,MSSIM_Winer_3,MSSIM_Winer_5,MSSIM_Winer_7,MSSIM_Winer_9, MSSIM_Lee_3,MSSIM_Lee_5,MSSIM_Lee_7,MSSIM_Lee_9,...
    MSSIM_NLM,MSSIM_TV ,MSSIM_BM3D,MSSIM_ann,MSSIM_org];

    MSSIM = MSSIM' ;
 
 
    EPIF=[abs(Mepi_median_3) ,abs(Mepi_median_5), abs(Mepi_median_7),abs(Mepi_median_9),...
    abs(Mepi_mean_3) ,abs(Mepi_mean_5), abs(Mepi_mean_7),abs(Mepi_mean_9),abs(Mepi_Kuwahara_5),abs(Mepi_Kuwahara_9),...
    abs(Mepi_SNN_3),abs(Mepi_SNN_5),abs(Mepi_SNN_7),abs(Mepi_SNN_9),abs(Mepi_Winer_3),abs(Mepi_Winer_5),abs(Mepi_Winer_7),abs(Mepi_Winer_9), abs(Mepi_Lee_3),abs(Mepi_Lee_5),abs(Mepi_Lee_7),abs(Mepi_Lee_9),...
    abs(Mepi_NLM),abs(Mepi_TV) ,abs(Mepi_BM3D),abs(Mepi_ann),abs(Mepi_org)];
    % EPIF=mean(EPI,2);
    EPIF = EPIF' ;
    toc

    % calculate SNR in another function
    SNRF = SNR_func( num_of_regions, nof, orig_I,cropped_I, ROI_filename );
    SNRF = abs (SNRF);
    
    %save parameters for ANN
    annparam_filename = [result_path num2str(image_id) '_ann_params.mat'];
    Para(input_index).ST = FEBOTH;
    Para(input_index).SNR = SNRF;
    Para(input_index).CNR = CNRF;
    Para(input_index).ENL = enlf;
    Para(input_index).MSSIM = MSSIM;
    Para(input_index).EPI = EPIF; 
    % if exist(annparam_filename, 'file') == 2
    %     save (annparam_filename,'Para','-append') % append to the existing one
    % else
    %     save (annparam_filename,'Para')
    % end
    save (annparam_filename,'Para')
    %save the whole workspace for security    
    save (Workspace_filename);

end %main_func_saba