BW = imread('text.png'); %%// Available in the MATLAB image library
figure,imshow(BW)

%%// Get the scalar distances around the boundaries of the regions/blobs
P  = regionprops(BW, 'Perimeter');

%%// Get scalar values that specifies the diameter of a circle with the same
%%// area as the regions/blobs
D  = regionprops(BW, 'EquivDiameter');

%%// Get list of pixels based on their labeling. 
%%// Basically the indices of the structs produced by regionprops refer to the labels.
pixel_list = regionprops(BW, 'PixelIdxList');

%%// Let us find out information about the first blob (blob that is labeled as 1)

%%// 1. List of pixel coordinates as linear indices
blob1_pixel_list = pixel_list(1).PixelIdxList;

%%// Create an image of the same size as the original one and showing the
%%blob labeled as 1
blob1 = false(size(BW));
blob1(blob1_pixel_list) = true;
figure,imshow(blob1)

%%// Perimter of blob -1 
blob1_perimeter = P(1).Perimeter

%%// Equivalent diameter of blob -1 
blob1_equivdiameter_values = D(1).EquivDiameter

%%// Get perimeter and diameter values for all the blobs
perimeter_values = struct2array(P)
diameter_values = struct2array(D)