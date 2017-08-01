function C = im2vect_V1(Iblock)

for i = 1:9
    for j = 1:9
        K(i,j) = exp(-(((i-5)^2)+((j-5)^2))/(2.0*(2.25^2)));
    end
end

K = K/sum(K(:)) ;
K = sqrt( K ) ;

C = zeros(81,(size(Iblock,1)-8)*(size(Iblock,2)-8)) ;
h = 1 ;
for i = 1:size(Iblock,2)-8
    for j = 1:size(Iblock,1)-8
        temp1 = K(1,:)'.*Iblock(j:j+8,i);
        temp2 = K(2,:)'.*Iblock(j:j+8,i+1);
        temp3 = K(3,:)'.*Iblock(j:j+8,i+2);
        temp4 = K(4,:)'.*Iblock(j:j+8,i+3);
        temp5 = K(5,:)'.*Iblock(j:j+8,i+4);
        temp6 = K(6,:)'.*Iblock(j:j+8,i+5);
        temp7 = K(7,:)'.*Iblock(j:j+8,i+6);
        temp8 = K(8,:)'.*Iblock(j:j+8,i+7);
        temp9 = K(9,:)'.*Iblock(j:j+8,i+8);
        C(:,h) = [ temp1; temp2; temp3; temp4; temp5; temp6; temp7; temp8; temp9 ] ;
        h = h + 1 ;
    end
end