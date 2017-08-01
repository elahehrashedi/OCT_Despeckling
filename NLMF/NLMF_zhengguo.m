function J = NLMF_zhengguo(I,Options)

% This code is based by Dirk-Jan Kroon who published his code in 
% http://www.mathworks.com/matlabcentral/fileexchange/27395-fast-non-local-means-1d-2d-color-and-3d
% I just translate his code to matlab vision since his code is more
% efficient than mine by using c++. 

% Function:
% options,
%   Options.filterstrength : Strength of the NLMF filtering (default 0.05)
%   Options.blocksize : The image is split in sub-blocks for efficienter
%                memory usage,  (default 1D 20000, default 2D: 150, default
%                3D: 32);

% Beta Options:
%   Options.enablepca : Do PCA on the patches to reduce amount of
%                         calculations (default false)
%   Options.pcaskip : To reduce amount of PCA calculations the data for PCA
%                      is first reduced with V(:,1:pcaskip:end)  (default 10)
%   Options.pcane : Number of eigenvectors used (default 25)
%
% Literature:
% - Non local filter proposed for A. Buades, B. Coll  and J.M. Morel 
%   "A non-local algorithm for image denoising"
% - Basic Matlab implementation of Jose Vicente Manjon-Herrera and
%   D.Kroon University of Twente (April 2010)

% Example 2D greyscale,
%  I=im2double(imread('moon.tif'));
%  Options.kernelratio=4;
%  Options.windowratio=4;
%  Options.verbose=true;
%  J=NLMF(I,Options);
%  figure,
%  subplot(1,2,1),imshow(I); title('Noisy image')
%  subplot(1,2,2),imshow(J); title('NL-means image');

if((min(I(:))<0)||(max(I(:))>1)), 
    warning('NLMF:inputs','Preferable data range [0..1]');
end
if((~isa(I,'double'))&&(~isa(I,'single')))
    error('NLMF:inputs','Input data must be single or double');
end


% Detect Image Dimension
if(size(I,3)>3)
    Dim=3;
elseif((size(I,1)>1)&&(size(I,2)>1))
    Dim=2;
else
    Dim=1;
end

% In 1D assume column vector
if(Dim==1), I=I(:); end

% Process inputs
defaultoptions=struct('kernelratio',3,'windowratio',3,'filterstrength',0.05,'blocksize',150,'nThreads',2,'verbose',false,'enablepca',false,'pcaskip',10,'pcane',25);
if(Dim==1), 
    defaultoptions.blocksize=20000;
elseif(Dim==2), 
    defaultoptions.blocksize=150;
else
    defaultoptions.blocksize=32; 
end

if(~exist('Options','var')), Options=defaultoptions;
else
    tags = fieldnames(defaultoptions);
    for i=1:length(tags), if(~isfield(Options,tags{i})), Options.(tags{i})=defaultoptions.(tags{i}); end, end
    if(length(tags)~=length(fieldnames(Options))),
        warning('register_images:unknownoption','unknown options found');
    end
end

kernelratio=round(Options.kernelratio);
windowratio=round(Options.windowratio);
blocksize=round(Options.blocksize);
verbose=Options.verbose;
enablepca=Options.enablepca;
pcaskip=round(Options.pcaskip);
pcane=round(Options.pcane);

if(Dim==1), 
    Ipad = padarray(I,kernelratio+windowratio,'symmetric'); %,    
elseif(Dim==2), 
    Ipad = padarray(I,[kernelratio+windowratio kernelratio+windowratio],'symmetric'); %,
else
    Ipad = padarray(I,[kernelratio+windowratio kernelratio+windowratio kernelratio+windowratio],'symmetric'); %,
end

% Separate the image into smaller blocks, for less memory usage
% and efficient cpu-cache usage.
block=makeBlocks(kernelratio,windowratio, blocksize, I, Ipad, Dim);

tic; erms='***';
J=zeros(size(I),class(Ipad));
for i=1:length(block);
%     if(verbose)
%         disp(['Processing Block ' num2str(i) ' of ' num2str(length(block)) ' estimated time remaining ' erms]);
%     end
    
    if(Dim==1)
        Iblock=Ipad(block(i).x1:block(i).x2);        
    elseif(Dim==2)
        Iblock=Ipad(block(i).x1:block(i).x2,block(i).y1:block(i).y2,:);
    else
        Iblock=Ipad(block(i).x1:block(i).x2,block(i).y1:block(i).y2,block(i).z1:block(i).z2);
    end
    
    %% This code is genalized by zhengguo
     V1 = im2vect_V1(Iblock) ; 
        
    if(enablepca)
        % Do PCA on the block
        [Evalues, Evectors, x_mean]=PCA(V(:,1:pcaskip:end),pcane);
        % Project the block to the reduced PCA feature space
        V = Evectors'*(V-repmat(x_mean,1,size(V,2)));
    end
    
    Iblock_filtered = TestNLmeansCDebug1012_v1( Iblock, V1, Options.filterstrength ) ;
    
    if(Dim==1)
        J(block(i).x3:block(i).x4)=Iblock_filtered;        
    elseif(Dim==2)
        J(block(i).x3:block(i).x4,block(i).y3:block(i).y4,:)=Iblock_filtered;
    else
        J(block(i).x3:block(i).x4,block(i).y3:block(i).y4,block(i).z3:block(i).z4)=Iblock_filtered;
    end
    
    if(verbose)
        t=toc; erm=(t/i)*(length(block)-i); erms=num2str(erm);
    end
end
toc;


function block=makeBlocks(kernelratio,windowratio,blocksize, I,Ipad, Dim)
block=struct;
i=0;
blocksize_real=blocksize-(kernelratio+windowratio)*2;
if(Dim==1)
    for x1=1:blocksize_real:size(Ipad,1)
        x2=x1+blocksize-1; 
        x2=max(min(x2,size(Ipad,1)),1); 
        x3=x1; 
        x4=min(x1+blocksize_real-1,size(I,1));
        if(x4>=x3)
            i=i+1;
            block(i).x1=x1; block(i).x2=x2; 
            block(i).x3=x3; block(i).x4=x4; 
        end
    end
elseif(Dim==2)
    for y1=1:blocksize_real:size(Ipad,2)
        for x1=1:blocksize_real:size(Ipad,1)
            x2=x1+blocksize-1; y2=y1+blocksize-1;
            x2=max(min(x2,size(Ipad,1)),1); 
            y2=max(min(y2,size(Ipad,2)),1);
            x3=x1; y3=y1; 
            x4=min(x1+blocksize_real-1,size(I,1));
            y4=min(y1+blocksize_real-1,size(I,2));
            if((x4>=x3)&&(y4>=y3))
                i=i+1;
                block(i).x1=x1; block(i).y1=y1; block(i).x2=x2; block(i).y2=y2;
                block(i).x3=x3; block(i).y3=y3; block(i).x4=x4; block(i).y4=y4;
            end
        end
    end
else
    for z1=1:blocksize_real:size(Ipad,3)
        for y1=1:blocksize_real:size(Ipad,2)
            for x1=1:blocksize_real:size(Ipad,1)
                x2=x1+blocksize-1; y2=y1+blocksize-1;  z2=z1+blocksize-1; 
                x2=max(min(x2,size(Ipad,1)),1); 
                y2=max(min(y2,size(Ipad,2)),1);
                z2=max(min(z2,size(Ipad,3)),1);
                x3=x1; y3=y1; z3=z1; 
                x4=min(x1+blocksize_real-1,size(I,1));
                y4=min(y1+blocksize_real-1,size(I,2));
                z4=min(z1+blocksize_real-1,size(I,3));
                if((x4>=x3)&&(y4>=y3)&&(z4>=z3))
                    i=i+1;
                    block(i).x1=x1; block(i).y1=y1;  block(i).z1=z1;
                    block(i).x2=x2; block(i).y2=y2;  block(i).z2=z2;
                    block(i).x3=x3; block(i).y3=y3;  block(i).z3=z3;
                    block(i).x4=x4; block(i).y4=y4;  block(i).z4=z4;
                end
            end
        end    
    end
end

function [Evalues, Evectors, x_mean]=PCA(x,ne)
% PCA using Single Value Decomposition
% Obtaining mean vector, eigenvectors and eigenvalues
%
% [Evalues, Evectors, x_mean]=PCA(x,ne);
%
% inputs,
%   X : M x N matrix with M the trainingvector length and N the number
%              of training data sets
%   ne : Max number of eigenvalues
% outputs,
%   Evalues : The eigen values of the data
%   Evector : The eigen vectors of the data
%   x_mean : The mean training vector
%
s=size(x,2);

% Calculate the mean 
x_mean=sum(x,2)/s;

% Substract the mean
x2=(x-repmat(x_mean,1,s))/ sqrt(s-1);

% Do the SVD 
[U2,S2] = svds(x2,ne,'L',struct('tol',1e-4));
Evalues=diag(S2).^2;
Evectors=U2;
