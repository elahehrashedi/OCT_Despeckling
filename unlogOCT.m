function [ Intensity ] = unlogOCT( Intensity )

% our OCT image is a log image
% so we will unlog it first
Intensity = 10.^ (Intensity./10);
% after this with the use of logOCT function, we bring back the image to
% OCT condition


end

