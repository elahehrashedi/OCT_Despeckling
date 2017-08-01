function result = epi(Orig_Image,Esti_Image)


%     %---Mean-Square Error(MSE) Calculation
%     Orig_Image = im2double(Orig_Image);%---Convert image to double class
%     Esti_Image = im2double(Esti_Image);%---Convert image to double class
%     [M N] = size(Orig_Image);%---Size of Original Image
%     err = Orig_Image - Esti_Image;%---Difference between two images
%     metrics.M_SE = (sum(sum(err .* err)))/(M * N);

       %---epi 
    h = fspecial('laplacian');
    I1 = imfilter(Orig_Image,h);
    I2 = imfilter(Esti_Image,h);
    I_1 = mean2(I1);
    I_2 = mean2(I2);
    result = sum(sum((I1 - I_1).*(I2 - I_2)))./(sqrt(sum(((I1 - I_1).^2).*((I2 - I_2).^2))));
end
    
