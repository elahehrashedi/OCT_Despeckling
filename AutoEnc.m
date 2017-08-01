% the autoencoder code
% nof number of filters
% maximage is maximum number of images

function AutoEnc (result_path, nof, maximage)

    numberofparams = 4 ;
	X = zeros (numberofparams,maximage*nof); % 5 rows of SNR, CNR, ENL, MMSIM, EPI

	for image_id=1:maximage
		annparam_filename = [result_path num2str(image_id) '_ann_params.mat'];
		load (annparam_filename); % load Para
		
		a = (image_id-1) * nof + 1 ;
		b = a + nof - 1 ;
		X (1,a:b) = normc (Para(image_id).SNR);
		X (2,a:b) = normc (Para(image_id).CNR);		
		X (3,a:b) = normc (Para(image_id).EPI);
        X (4,a:b) = normc (Para(image_id).MSSIM);        
        %X (5,a:b) = normc (Para(image_id).ENL);

	end

	%Xnew = X ;
	hiddenSize = 1;
% 	autoenc_SABA = trainAutoencoder(X,hiddenSize, ...
%         'ScaleData',false, ...
%         'DecoderTransferFunction','purelin');
    autoenc_SABA = trainAutoencoder(X,hiddenSize );
	
    %Z = encode (autoenc_SABA, Xnew);
	%Z = encode (autoenc_SABA, X) ;


    % All FOMs
    Y = zeros (1,maximage*nof);  
	for i =1:maximage*nof
        for j = 1:numberofparams
            Y (1,i) = Y (1,i) + autoenc_SABA.EncoderWeights(j)* X (j,i) ;
        end
	end 
    Y = mat2gray (Y);
    
    %only for one filter
    Yfilter = zeros (nof,maximage); 
    for filter = 1: nof
        j = 1 ;
        for i =filter:27:maximage*nof
            Yfilter (filter,j) = Y (1,i);
            j = j + 1 ;
        end
    end

    autoencoder_filename = [result_path 'AutoEnc.mat'];
	save (autoencoder_filename , 'autoenc_SABA' ,'Y', 'Yfilter' );
    
end

