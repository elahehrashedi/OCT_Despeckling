clear all;
clc;
[filename,pathname]=uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*','All Files' },'mytitle',...
'Select an Image');
X= imread(fullfile(pathname,filename)); 
X=double(X);
 X=X(:,:,1);

[m, n] = size(X);

% %mean
% [m,n] = size(X);
mean_trace = mean(X,2);
Xmr = X - repmat(mean_trace,1,n);

%with PCA

dataX = X'/sqrt(n-1); % transpose and scale the data matrix
[U, S, V] = svd(dataX,0); % PCA via "economy" SVD
D = diag(S).^2; % calculate the eigenvalues
% Plot eigenvalue spectra
figure(5);
plot(20*log10(D),'k-*'); % scree plot
grid on;
xlabel('Eigenvalue no');
ylabel('Eigenvalue (dB)');
title('Eigenspectra');
k = input('Number of PCs: '); % select number of PCs to retain
Y = U'*dataX; % transform the original data
% Reduce data dimensionality
% i.e. consider only the first r rows of Y
Yr = Y(1:k,:);
% Recover the original data
% Just for checking
Xrec = U*Y;
Xrec = Xrec'; % this should now be the same with X
% Recover the original data with losses due to dimensionality
% reduction
% Just for checking
Xkrec = U(:,1:k)*Yr;
Xkrec = Xkrec';
% Set the largest singular values to zero for clutter reduction
% since the clutter usually dominates the largest eigenvalues.
Xsvd = U(:,2:k)*Y(2:k,:);
Xsvd = Xsvd';
% PCA via SVD Results - Plots
% Plot the first k eigenimages
E = zeros(k,m,n);
for i = 1:k
E(i,:,:) = (U(:,i) * S(i,i) * (V(:,i))')';
end
figure(6);
for i = 1:k
subplot(ceil(sqrt(k)),ceil(sqrt(k)),i)
colormap(gray);
imagesc(reshape(E(i,:,:),m,n));
title(['Eigenimage # ', num2str(i)]);
end
% Plot the reconstructed image
figure(7)
imagesc(Xsvd);
colormap(gray);
title('Decluttered Data - SVD')

 figure; imshow(Xsvd,[])
figure; imshow(X,[])

%% 4. PCA method 2
% Uses eigenvalue decomposition of data covariance matrix
dataX2 = X'; % transpose the data matrix
cov = 1/(n-1)*dataX2*dataX2'; % calculate the covariance matrix
[U, D] = eig(cov); % find the eigenvectors and
% eigenvalues
D = diag(D); % extract diagonal eigenvalues
% matrix as vector
% Sort the eigenvalues and eigenvectors in decreasing order
[junk, rindices] = sort(-1*D);
D = D(rindices);
U = U(:,rindices);
% Plot eigenvalue spectra
figure(8);
plot(20*log10(D),'k-*'); % scree plot
grid on;
xlabel('Eigenvalue no');
ylabel('Eigenvalue (dB)');
title('Eigenspectra');
k = input('Number of PCs: '); % select number of PCs to retain
Y = U' * dataX2; % project the original data set
% Reduce data dimensionality
% i.e. consider only the first r rows of Y
Yr = Y(1:k,:);
% Recover the original data
Xrec = U*Y;
Xrec = Xrec'; % this should now be the same with X
% Recover the original data with losses due to dimensionality
% reduction
Xkrec = U(:,1:k)*Yr;
Xkrec = Xkrec';
% Set the largest singular values to zero for clutter reduction
% since the clutter usually dominates the largest eigenvalues.
Xeig = U(:,2:k)*Y(2:k,:);
Xeig = Xeig';
% PCA via SVD Results - Plots
% Plot the first k eigenimages
figure(9);
Xreceig = zeros(size(dataX2));
for i = 1:k
Y1 = zeros(size(Y));
Y1(i,:) = Y(i,:);
eigeigen = U * Y1;
subplot(ceil(sqrt(k)),ceil(sqrt(k)),i);
colormap(gray);
imagesc(eigeigen');
title(['Eigenimage # ', num2str(i)]);
Xreceig = Xreceig + eigeigen;
end
% Plot the reconstructed image
figure(10);
colormap(gray);
imagesc(Xeig);
title('Decluttered Data - EIG');
figure; imshow(Xeig,[])
figure; imshow(X,[])


%% 5. SVDPICA method
k = input('Number of PCs: ');
[U, S, V] = svd(Xmr,0); % do the SVD on mean removed data
Uk = U(:,1:k); % consider first k PCs only
Vk = V(:,1:k);
Sk = S(1:k,1:k);
W = jadeR(Uk',k); % do the ICA
Uktil = W * Uk'; % un-mix the mixed PCs
B = pinv(W); % estimate the mixing matrix
Tktil = Vk * Sk * B;
% Decompose Tktil into two new matrices such that:
% Tktil = Vktil * Sktil
% The data has been transposed, thus, we have rows of measurements
% instead of columns
[m1 n1] = size(Tktil);
Vktil = [];
Sktil = zeros(n1,n1);
for i = 1:n1
beta = norm(Tktil(:,i));
Vktil = [Vktil Tktil(:,i)/beta];
Sktil(i,i) = beta;
end
% Sort new ICs in descending order of associated singular values
% from Sktil= diag(Sktil); % extract diagonal of matrix as
% vector
Stemp = diag(Sktil);
[junk, rindices] = sort(-1*Stemp); % sort in decreasing order
Uktil = Uktil(rindices,:); % reorder
Sktil = Sktil(rindices,rindices);
Vktil = Vktil(:,rindices);
eigentil = diag(Sktil).^2; % get the eigenvalues
% Plot the new eigenvalue spectra
figure(11);
plot(20*log10(eigentil),'k-*'); % scree plot
grid on;
xlabel('Eigenvalue no');
ylabel('Eigenvalue (dB)');
title('New Eigenspectra');
% Obtain independent images and reconstruct the data
I = zeros(k,m,n);
for i = 1:k
I(i,:,:) = (Vktil(:,i) * Sktil(i,i) * (Uktil(i,:)))';
end
k1 = input('Number of ICs [nfirst nlast]: ');
Xrec1 = sum(I(k1(1):k1(2),:,:));
Xrec1 = reshape(Xrec1,m,n);
% SVDPICA Results - Plots
% Plot individual independent images
figure(12)
for i = 1:(k1(2)-k1(1)+1)
subplot(ceil(sqrt(k1(2)-k1(1)+1)),ceil(sqrt(k1(2)-k1(1)+1)),i)
colormap(gray);
imagesc(reshape(I(i,:,:),m,n));
title(['Independent image # ', num2str(i)]);
end
% Plot reconstructed image
figure(13);
imagesc(Xrec1);
colormap(gray);
title('Decluttered Data - PCA via ICA');
%% Evaluation via PSNR
% i.e. Compare to "ideal" or reference image
% For simulated data "ideal" image can be used as a reference
% For measured data original raw image is used as a reference

Xref = X;

XR = imscale(Xref);
XMR = imscale(Xmr);
XSVD = imscale(Xsvd);
XEIG = imscale(Xeig);
XSVDPICA = imscale(Xrec1);
% Calculate PSNRs for all obtained images, using XR as reference
% image
psnr_MR = PSNR(XMR,XR);
psnr_SVD = PSNR(XSVD,XR);
psnr_EIG = PSNR(XEIG,XR);
psnr_SVDPICA = PSNR(XSVDPICA,XR);
%% Evaluation via M-SSIM
% For simulated data = "Ideal" vs. processed images
% For measured data = Reflexw vs. processed images

XI = XR;


[mssim_MR, ssim_map_MR] = ssim(XI, XMR);
[mssim_SVD, ssim_map_SVD] = ssim(XI, XSVD);
[mssim_EIG, ssim_map_EIG] = ssim(XI, XEIG);
[mssim_SVDPICA, ssim_map_SVDPICA] = ssim(XI, XSVDPICA);
%% Display results
% PSNR results
format short
disp('PSNR values:');
disp(' MR PCAviaSVD PCAviaEIG SVDPICA ');
disp(' --------------------------------------- ');
disp([psnr_MR psnr_SVD psnr_EIG psnr_SVDPICA]);
% Similarity result
format short
disp('SSIM values:');
disp(' MR PCAviaSVD PCAviaEIG SVDPICA ');
disp(' --------------------------------------- ');
disp([mssim_MR mssim_SVD mssim_EIG mssim_SVDPICA]);
% The PSNR result:
% SIMULATED DATA:
% Ideal image can be obtained to be used as the "reference" image
% in the evaluation using PSNR. Thus, higher PSNR indicates better
% algorithm.
%
% MEASURED DATA:
% Original raw data is used as the "reference" image. Lower values
% of PSNR indicates better algorithm.

% SVD of the total image
[V,S,U] = svd(X);
% Plot the eigenvalues to decide on the exact number of eigenimages
% to be reconsidered
eigen = diag(S).^2;
sev = sum(eigen);
figure(4);
plot(eigen,'k','LineWidth',2);
hold on;
plot(eigen,'ko','LineWidth',2);
title('2D-PCA Eigenvalue Spectrum');
xlabel('Eigenvalue Number');
ylabel('Eigenvalue')
%% Construct eigenimage group best representing the unwanted feature
% Obtain first eno eigenimages
eno = input('Select number of eigenimages to be removed from the image: ');
St = zeros(size(S));
for i = 1:eno
St(i,i) = S(i,i); % keep the first eno eigenvalues for
end % reconstruction
Xeig = V * St * U';
%% Plot the individual eigenimages
Xetot = zeros(m,n);
figure(5)
for i = 1:eno
St = zeros(size(S));
St(i,i) = S(i,i);
Xe = V * St * U';
subplot(ceil(sqrt(eno)),ceil(sqrt(eno)),i)
imagesc(Xe);
colormap(gray);
title(['2DPCA Eigenimage #' num2str(i)]);
Xetot = Xetot + Xe;
end
% "Total" eigenimage - first eno eigenimages added together
figure(6);
imagesc(Xetot); % plot the reconstructed total eigenimage
colormap(gray);
title('Total Eigenimage of the Unwanted Features');
%% Plot 2D-PCA results
% Align original and total eigenimage of 2D-PCA
[Xd, Xeigd, displ] = align(X, Xeig);
% Remove the reconstructed total eigenimage from the selected
% individual image
Xsvd2 = Xd - Xeigd;
figure(7);
imagesc(Xsvd2); % plot the residual
colormap(gray);
title('2D-PCA');
%% Calculate PSNR for 2D-PCA
% The dimension of image obtained from 2D-PCA (Xsvd2) must be the
% same with the image before the application of this method (i.e.
% Xdids) for PSNR comparison. Thus:
% 1. Do the upsample to each column of Xsvd2
% 2. Sort the number of columns
[nsvd2 msvd2] = size(Xsvd2);
[ndids mdids] = size(Xdids);
m = min(msvd2,mdids);
Xdids = Xdids(:,1:m);
for j = 1:m
Xsvd2i(:,j) = interp(Xsvd2(:,j),uf);
end
% Sort the number of columns
[nsvd2 msvd2] = size(Xsvd2i);
[ndids mdids] = size(Xdids);
n = min(nsvd2,ndids);
Xdids = Xdids(1:n,:);
Xsvd2i = Xsvd2i(1:n,:);
% Calculate the PSNR
psnr_2DPCA = PSNR(imscale(Xsvd2i),Xdids);
% Similarity measure
[mssim_2DPCA, ssim_map_2DPCA] = ssim(imscale(Xsvd2i),Xdids);
%% 2D-ICA
% Turn each image into 1D mixture and construct matrix of mixtures
[m n] = size(X1);
X11D = reshape(X1,m*n,1);
X21D = reshape(X2,m*n,1);
X31D = reshape(X3,m*n,1);
X41D = reshape(X4,m*n,1);
X51D = reshape(X5,m*n,1);
X61D = reshape(X6,m*n,1);
Xm = [X11D X21D X31D X41D X51D X61D]'; % mixtures matrix
% Do PCA and plot the eigenvalues to get some idea of independent
% components to be extracted from the mixture
[U,S,pc]= svd(Xm',0);
eigen = diag(S).^2;
figure(8)
plot(eigen,'k'); hold on; plot (eigen,'rx');
title('Scree Plot');
xlabel('Eigenvalue Number');
ylabel('Eigenvalue')
%% Un-mix
nu_ICA = 6; % nu_ICA equals to number of mixed images
W = jadeR(Xm,nu_ICA);
ic = (W * Xm)';
% Reshape and plot individual images
figure(9);
for k = 1:nu_ICA
subplot(ceil(sqrt(nu_ICA)),ceil(sqrt(nu_ICA)),k)
imagesc(reshape(ic(:,k),m,n));
colormap(gray);
title(['Independent image #' num2str(k)]);
end