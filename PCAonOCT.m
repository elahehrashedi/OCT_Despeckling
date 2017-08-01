% PCA
function PCAonOCT (result_path, nof, maximage)

    %load AutoEnc file
    atoenc_filename = [result_path 'AutoEnc.mat'];
    if ~exist(atoenc_filename, 'file') == 2
        display (sprintf('Autoencder file doesnt exist')); 
        return;
    end
    load (atoenc_filename,'Yfilter'); 
    %Yfilter = Yfilter';

    % X (features, images ,filters)
    % rows are features (obseravtions)
    % columns are variables
    numoffeatures = 62 ; 
	X = zeros (numoffeatures,maximage,nof); 
    
    % read features of each image from destination folder
	for image_id = 1 : maximage
		annparam_filename = [result_path num2str(image_id) '_ann_params.mat'];
		load (annparam_filename); % load Para		
        for filter_id = 1 : nof
            X (:,image_id,filter_id) = Para(image_id).ST ( 1:numoffeatures,1,filter_id) ;
        end
    end
 
    coeff = pca (X(:,:,1)) ;
    
    %YfilterT = Yfilter';
    [I,labels] = max (Yfilter);

    features = X (:,:,27); % features of the main image
    setdemorandstream(491218382);
    
    %create the target matrix
    target = zeros (27,285);
    for i=1:285
      target (labels(i),i) = 1 ;  
    end
    
    %target = target';
    
    
    net = patternnet(3);
    [net,tr] = train(net,features,target);
    nntraintool
    testX = features(:,tr.testInd);
    testT = target(:,tr.testInd);

    testY = net(testX);
    testIndices = vec2ind(testY);
    plotconfusion(testT,testY)

    output = sim(net,features(1,:));
    
end