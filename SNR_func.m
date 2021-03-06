function [ SNRF ] = SNR_func( num_of_regions, nof, orig_I,cropped_I, ROI_filename )

    orig_I_norm_unlog=MatrixNorm(unlogOCT(orig_I));
    cropped_I_norm_unlog=MatrixNorm(unlogOCT(cropped_I));

    load (ROI_filename);
    
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

    % all other than SNR
    ROI1=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI2=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI3=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI4=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI5=zeros(ROI_x+2,ROI_y+2,nof,num_of_regions);
    ROI_B=zeros(ROI_x+2,ROI_y+2,nof);
    

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
    %imshow(orig_I_norm_unlog,[]);

    r2 = list_of_recs (num_of_regions*num_of_regions+1,:);
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
        end
    end
    SNRF=mean(SNR,2);

end

