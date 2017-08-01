function result = epi(Orig_Image,Esti_Image)

%     [M N] = size(Orig_Image);%---Size of Original Image

       %---epi 
    h = fspecial('laplacian');
    I1 = imfilter(Orig_Image,h);
    I2 = imfilter(Esti_Image,h);
    I_1 = mean2(I1);
    I_2 = mean2(I2);
    tmp = (I1 - I_1).*(I2 - I_2);
    result = sum(tmp(:))./(sqrt(sum(tmp(:))));
end
    
