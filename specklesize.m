M=400; % determine how many AC of arrays will be averaged
N=400; % determine how many AC of columns will be averaged
A=imread('1-speckle.tif'); % read file
B=A(:,158:558); %cut a strip of image
figure(1)
imshow(B); % show the striped image
B=double(B); % change data to double
character
E=B(1,:); % select one array of
data
s=size(xcov(E)); % get the size of AC serial
D=zeros(s); % generate a zero serial with the same size with
AC serial
D=double(D); % set the serial with double character
for i=1:M % begin of the cycle; parameter is define at
the begining
C=B(i,:); % choose one array
D=imadd(D,xcov(C,'coeff')); % Do AC and add it to the zero serial
end; % End of the circle
figure(2)
G=D/M; % Normalized the addition
plot(G); % Plot the normalized AC
E1=B(:,1); % Same process to calculate
normalized AC to column
s1=size(xcov(E1));
D1=zeros(s1);
D1=double(D1);
for j=1:N
C1=B(:,j);
D1=imadd(D1,xcov(C1,'coeff'));
end;
figure(3)
G1=D1/M;
plot(G1);