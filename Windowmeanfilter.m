function [result ] = Windowmeanfilter(data,windowsize)
h=fspecial('average',windowsize);
result=filter2(h,data);

 end

