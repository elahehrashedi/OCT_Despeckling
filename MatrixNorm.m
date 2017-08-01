function [ output ] = MatrixNorm(input)

%     input = [ -12 2 4; 48 12 6 ; -7 8 90;]

    %output = normc (input);
    
    output = mat2gray (input); % mat2gray works the same as below code
    %matmax = max ( input (:)) ;
    %matmin = min ( input (:)) ;
    %output = (input - matmin ) / (matmax - matmin) ;
    
%     matmean = mean2(input);
%     matvar = var (input(:));
%     output2 = (input - matmean )./ matvar ;
%     output2 = mat2gray (output2) ; 

end

