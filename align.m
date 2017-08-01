function [X1d, X2d, displ] = align(X1, X2)
% Function to align GPR image X1 with GPR image X2 along the
% x-axis.
% Uses 1D correlation of individual image rows to find misalignment
% between the images (i.e. image rows).
% Also, it resizes re-aligned images to the same size.
%
% July 2012
%
% Output: X1d - re-aligned and resized image
% displ - displacement between the images
[m1 n1] = size(X1);
[m2 n2] = size(X2);
% Autocorrelate to find displacement between the images
corsum = 0;
for i = 1:min(m1,m2)
corsum = corsum + xcorr(X1(i,:),X2(i,:));
end
[maxc ind] = max(corsum);
d = ind - max(n1,n2);
% Align, if needed
if d < 0
X2d = X2(:,-d+1:end);
X1d = X1;
displ = -d;
elseif d > 0
X1d = X1(:,d+1:end);
X2d = X2;
displ = d;
else % for d = 0 retain original images
X1d = X1;
X2d = X2;
displ = 0;
end
% Make both images same size, if needed
[m1d n1d] = size(X1d);
[m2d n2d] = size(X2d);
if n2d > n1d
X2d = X2d(:,1:n1d);
elseif n1d > n2d
X1d = X1d(:,1:n2d);
end