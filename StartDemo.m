% this is the start point of the project
% it automate the project for all images in one folder
% it asks user to create the ROI for all images and it saves teh ROIs
% then it run the filters on all images in that specified folder
% the ROI is saved for future uses

function StartDemo(  )

    %stage = 1 ; % perform RIO + filtering + autoencoder
    %stage = 2 ; % perform autoencoder
    stage = 3 ; % perform PCA

    src_path= 'C:\Elaheh\OCTsaba\source\';
    result_path = 'C:\Elaheh\OCTsaba\result\';

    num_of_regions = 5 ;
    nof=27;  %number_of_filters

    image_id = 1; % start from 1 to num_of_images
    input_index = 1; % same as image_id, unless some image IDs are missing (this is used for ann_params)
    src_dir = dir([src_path, '*.tif']);
    num_of_images = length(src_dir(not([src_dir.isdir])));

    if (stage == 1 )
        %select ROI for all images first
        %title('New Image. Please select and crop the Skin tissue'); %% cropped image
        first_title = 1 ;
        for i=1:num_of_images
            image_filename = [num2str(image_id) '.tif'];
            %if image doesn't exist then skip it
            if exist(fullfile(src_path,image_filename), 'file') ~= 2
                image_id = image_id + 1 ;
                num_of_images = num_of_images + 1 ;
                display (sprintf('@@@@@@@@@@@@@ %s doesnot exist.',image_filename));
            else % if image exists then run the code            
                if  first_title == 1  % this code is only for craeting the the title
                    B = imread(fullfile(src_path,image_filename)); 
                    orig_I=im2double(B);
                    orig_I=orig_I(:,:,1);
                    imshow (orig_I);title('New Image. Please select and crop the Skin tissue'); %% cropped image
                    pause(2);
                    first_title = 0 ;
                end            
                ROI_selection (src_path,result_path,image_filename,image_id,input_index, num_of_regions, nof);
                %main_func_saba (src_path,result_path,image_filename,image_id,input_index, num_of_regions, nof);
                image_id = image_id + 1 ;
                input_index = input_index + 1;
            end
        end

        % now run algorithm for each image with the selected ROI
        image_id = 1; % start from 1 to num_of_images
        input_index = 1; % same as image_id, unless some image IDs are missing (this is used for ann_params)
        %title('running algorithm on Cropped Image');
        for i=1:num_of_images
            image_filename = [num2str(image_id) '.tif'];
            %if image doesn't exist then skip it
            if exist(fullfile(src_path,image_filename), 'file') ~= 2
                image_id = image_id + 1 ;
                num_of_images = num_of_images + 1 ;
                display (sprintf('@@@@@@@@@@@@@ %s doesnot exist.',image_filename));
            else % if image exists then run the code
                %ROI_selection (src_path,result_path,image_filename,image_id,input_index, num_of_regions, nof);
                main_func_saba (src_path,result_path,image_filename,image_id,input_index, num_of_regions, nof);
                image_id = image_id + 1 ;
                input_index = input_index + 1;
            end
        end
    end
    
    % perform Auto Encoder
    if (stage == 2 )
        maximage = 285 ;
        AutoEnc (result_path, nof, maximage);
    end
    
    % perform PCA and ANN
    if (stage == 3 )
        maximage = 285 ;
        PCAonOCT (result_path, nof, maximage);
    end
    
end


