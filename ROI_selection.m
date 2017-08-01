% this function is used to select ROI and then save them 03/21/2017
function ROI_selection (src_path, result_path, image_filename, image_id, input_index, num_of_regions, nof)

    ROI_filename = [result_path num2str(image_id) '_ROI.mat'];
    if exist(ROI_filename, 'file') == 2
        %it means there is already an ROI exist for this image
        display (sprintf('@@@@@@@@@@@@@ ROI already exists for %s .',image_filename));
        return;
    end

    B = imread(fullfile(src_path,image_filename)); 
    orig_I=im2double(B);
    orig_I=orig_I(:,:,1);
    imshow (orig_I);title('New Image. Please select and crop the Skin tissue'); %% cropped image
    %pause(3);
    [~,y,cropped_I,crop_rect]=imcrop(orig_I,[]); 
    %crop_rect = floor (crop_rect);
    %crop_rect = ceil (crop_rect);
    %[R,C]=size(cropped_I);


    close all;
    imshow(cropped_I,[]); title('Please select 25 ROIs');
    %% select 5 ROI
    % prompt = {'Enter ROI size, x:','Enter ROI size, y'};
    % dlg_title = 'Please choose 5 Signal ROIs';
    % num_lines = 1;
    % defaultans = {'20','20'};
    % answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    % ROI_coordinates=(str2num(cell2mat(answer)))';
    % ROI_x=ROI_coordinates(1);
    % ROI_y=ROI_coordinates(2);
    ROI_x=20;
    ROI_y=20;   


   for j=1: num_of_regions*num_of_regions %% number of clusters
        %%% ROI 25 regions
        waitforbuttonpress
        point2 = get(gcf,'CurrentPoint'); % button down detected
        rect = [point2(1,1) point2(1,2) ROI_x ROI_y];
        [r1] = dragrect(rect);
        point1 = get(gca,'CurrentPoint'); % button down detected
        r2 = [point1(1,2) point1(1,1) ROI_x ROI_y];
        z = [r2(2) r2(2) r2(2)+r2(4) r2(2)+r2(4) r2(2)];
        x = [r2(1) r2(1)-r2(3) r2(1)-r2(3) r2(1) r2(1)];
        hold on
        plot(z,x,'y')
        %text(r2(2)+r2(4)/2,r2(1)-r2(3)/2,'1','color','y','FontSize',20,'FontWeight','bold')
        r2=round(r2)+1;
        list_of_recs (j,:) = r2 ;
   end
        pause(1);
        %ROI of background
        close all;
        imshow(orig_I,[]); title('Please select the background');
        waitforbuttonpress
        point2 = get(gcf,'CurrentPoint'); % button down detected
        rect = [point2(1,1) point2(1,2) ROI_x ROI_y];
        [r1] = dragrect(rect);
        point1 = get(gca,'CurrentPoint'); % button down detected
        r2 = [point1(1,2) point1(1,1) ROI_x ROI_y];
        z = [r2(2) r2(2) r2(2)+r2(4) r2(2)+r2(4) r2(2)];
        x = [r2(1) r2(1)-r2(3) r2(1)-r2(3) r2(1) r2(1)];
        hold on
        plot(z,x,'y')
        %text(r2(2)+r2(4)/2,r2(1)-r2(3)/2,'1','color','y','FontSize',20,'FontWeight','bold')
        r2=round(r2)+1;
        list_of_recs (num_of_regions*num_of_regions+1,:) = r2 ;

        %save list of recs in a file name ROI
        
        save(ROI_filename,'ROI_x', 'ROI_y', 'crop_rect','list_of_recs');
end