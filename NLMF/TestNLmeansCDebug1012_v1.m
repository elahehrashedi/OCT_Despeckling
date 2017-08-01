function output = TestNLmeansCDebug1012_v1( I, V, filterstrength )

filterstrength2=1/(filterstrength^2);
Rowlength = size(I,1) - 8 ;
Collength = size(I,2) - 8 ;    
output = zeros(Rowlength-8,Collength-8) ;
k1 = 5 ;
s1 = 5 ;
for i1 = 9: Collength
    distancei1 = i1*Rowlength ;        
    for j1 = 9: Rowlength
        wmax=0; 
        average=0;
        sweight=0;
        distancek1 = k1 * Rowlength ;
        sumpart1 = distancei1-distancek1+j1-s1+1 ;            
        for t1 = i1-4:i1+4
            distancet1 = t1*Rowlength ;
            for t2 = j1-4:j1+4
                if t1 == i1 && t2 == j1
                    continue ;
                end
                distance = sum((V(:,sumpart1 )-V( :,distancet1-distancek1+t2-s1+1)).^2) ;
                tempw = exp(-distance*filterstrength2);
                wmax=max(tempw, wmax);
                sweight = sweight + tempw;               
                average = average + tempw*I(t2,t1);
            end
        end

        wmax=max(wmax, 1e-15);
        average = average + wmax*I(j1,i1);
        sweight = sweight + wmax;
        if sweight > 0
            output(j1-8,i1-8) = average / sweight;
        else
            output(j1-8,i1-8) = I(j1,i1);
        end 
    end
end