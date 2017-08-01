
function [results]=wmedian(A)
[a,b]=size(A);
B=zeros(size(A)); 
for i=2:a-1
     for j=2:b-1
                      
          B(i,j)=(A(i-1,j-1)+A(i-1,j)+A(i-1,j+1)+A(i,j-1)+2*A(i,j)+A(i,j+1))/.7;
        
     end
end
results=B;