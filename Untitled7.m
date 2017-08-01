 

imshow(org_norm_unlog_image,[]);

storedStructure = load('orig_norm_unlog_image.mat');
imageArray = storedStructure.s.I
imshow(imageArray, []);
%% select 5 ROI
prompt = {'Enter ROI size, x:','Enter ROI size, y'};
dlg_title = 'Please choose 5 Signal ROIs';
num_lines = 1;
defaultans = {'20','20'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
ROI_coordinates=(str2num(cell2mat(answer)))';
ROI_x=ROI_coordinates(1);
ROI_y=ROI_coordinates(2);



  num_of_regions = 1 ;
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



 %%% SNR calculation
        Blinear=max(max(ROI1(:,:,i,j)));
        ROI_B_v=ROI_B(:,:,i);
        variance=var(ROI_B_v(:)); 
        SNR1(i,j)=((Blinear^2)/variance);



%%% CNR calculation
        uo_1(i,j)=mean2(ROI1(:,:,i,j));
        Std_1(i,j)=std2(ROI1(:,:,i,j));
        ub=mean2(ROI_B(:,:,i));
        Sb=std2(ROI_B(:,:,i));
        CNR1(i,j)=(uo_1(i,j)-ub)/sqrt(Std_1(i,j)^2+ Sb^2);
        
        
          enl_1(i,j)=uo_1(i,j)/var(ROI_1(:));