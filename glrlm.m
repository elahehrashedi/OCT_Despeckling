function Final_Out  = glrlm(img)
% [SRE,LRE,GLN,RP,RLN,LGRE,HGRE]= glrlm(img,16,mask)

% gray level run length matrix computation
%
% input:
% - img, an input grayscale image (RGB images are converted to grayscale)
% - quantize, quantization levels. Normally set to 16. Should be larger than 1.
% - mask, a binary mask to use with values of 1 at the ROI's. If whole image
%         is needed then mask = ones(size(img(:,:,1)));
%
% output: texture features
%
%    1. SHORT RUN EMPHASIS (SRE) 
%    2. LONG RUN EMPHASIS(LRE)
%    3. GRAY LEVEL NON-UNIFORMITY (GLN)
%    4. RUN PERCENTAGE (RP)
%    5. RUN LENGTH NON-UNIFORMITY (RLN)
%    6. LOW GRAY LEVEL RUN EMPHASIS (LGRE)
%    7. HIGH GRAY LEVEL RUN EMPHASIS (HGRE)
%
% example:
% I = imread('cameraman.tif');
% imshow(I)
% mask = ones(size(I(:,:,1)));
% quantize = 16;
% [SRE,LRE,GLN,RP,RLN,LGRE,HGRE]  = glrlm(I,quantize,mask)

mask = ones(size(img(:,:,1)));
quantize = 16;
% if color => make gray scale
if size(img,3)>1
   img = im2gray(img); 
end

img = im2double(img); % to double

% crop the image to the mask bounds for faster processing
stats = regionprops(mask,'BoundingBox');
bx = int16(floor(stats.BoundingBox)) + int16(floor(stats.BoundingBox)==0);
img = img(bx(2):bx(2)+bx(4)-1,bx(1):bx(1)+bx(3)-1);
mask = mask(bx(2):bx(2)+bx(4)-1,bx(1):bx(1)+bx(3)-1);

% adjust range
mini = min(img(:));   % find minimum
img = img-mini;       % let the range start at 0
maxi = max(img(:));   % find maximum

% quantize the image to discrete integer values in the range 1:quantize
levels = maxi/quantize:maxi/quantize:maxi-maxi/quantize;
img = imquantize(img,levels);

% apply the mask
img(~mask) = 0;

% initialize glrlm: p(i,j)
% -  with i the amount of bin values (quantization levels)
% -  with j the maximum run length (because yet unknown, assume maximum length
%    of image)
% -  four different orientations are used (0, 45, 90 and 135 degrees)
p0 = zeros(quantize,max(size(img)));
p45 = zeros(quantize,max(size(img)));
p90 = zeros(quantize,max(size(img)));
p135 = zeros(quantize,max(size(img)));

% initialize maximum value for j
maximgS = max(size(img));

% add zeros to the borders
img = padarray(img,[1 1]);

% initialize rotation
img45 = imrotate(img,45);

% find the run length for each quantization level
for i = 1:quantize
    % find the pixels corresponding to the quantization level
    BW = int8(img == i);
    BWr = int8(img45 == i);    
    
    % find the start and end points of the run length
    G0e = (BW(2:end-1,2:end-1) - BW(2:end-1,3:end)) == 1;
    G0s = (BW(2:end-1,2:end-1) - BW(2:end-1,1:end-2)) == 1;
    G45e = (BWr(2:end-1,2:end-1) - BWr(2:end-1,3:end)) == 1;
    G45s = (BWr(2:end-1,2:end-1) - BWr(2:end-1,1:end-2)) == 1;
    G90e = (BW(2:end-1,2:end-1) - BW(3:end,2:end-1)) == 1;
    G90s = (BW(2:end-1,2:end-1) - BW(1:end-2,2:end-1)) == 1;
    G135e = (BWr(2:end-1,2:end-1) - BWr(3:end,2:end-1)) == 1;
    G135s = (BWr(2:end-1,2:end-1) - BWr(1:end-2,2:end-1)) == 1;
    
    % find the indexes
    G0s = G0s'; G0s = find(G0s(:));
    G0e = G0e'; G0e = find(G0e(:));
    G45s = G45s'; G45s = find(G45s(:));
    G45e = G45e'; G45e = find(G45e(:));
    G90s = find(G90s(:));
    G90e = find(G90e(:));
    G135s = find(G135s(:));
    G135e = find(G135e(:));
 
    % find the lengths
    lengths0 = G0e - G0s + 1;
    lengths45 = G45e - G45s + 1;
    lengths90 = G90e - G90s + 1;
    lengths135 = G135e - G135s + 1;
    
    % fill the matrix
    p0(i,:) = hist(lengths0,1:maximgS);
    p45(i,:) = hist(lengths45,1:maximgS);
    p90(i,:) = hist(lengths90,1:maximgS);
    p135(i,:) = hist(lengths135,1:maximgS);    
end

% add all orientations
p = p0 + p45 + p90 + p135;

% calculate the features
Out0 = ComputePar(p0,maximgS,quantize,mask);
Out45 = ComputePar(p45,maximgS,quantize,mask);
Out90 = ComputePar(p90,maximgS,quantize,mask);
Out135 = ComputePar(p135,maximgS,quantize,mask);
Out = ComputePar(p,maximgS,quantize,mask);
Final_Out = [Out0; Out45; Out90; Out135; Out];
end

function out = ComputePar(p,maximgS,quantize,mask)

totSum = sum(p(:));
SRE = sum(sum(p,1) ./ ((1:maximgS).^2)) / totSum;
LRE = sum(sum(p,1) .* ((1:maximgS).^2)) / totSum;
RLN = sum(sum(p,1) .^2) / totSum;
RP = totSum / sum(mask(:));
GLN = sum(sum(p,2) .^2) / totSum;
LGRE = sum(sum(p,2) .* ((1:quantize)'.^2)) / totSum;
HGRE = sum(sum(p,2) .^2) / totSum;

out = [SRE,LRE,GLN,RP,RLN,LGRE,HGRE]';

end




    