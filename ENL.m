function myenl = ENL(signal)
    homo = 40 ; %homogeneaos regins 
    repeat= 5 ; % repeat regins of interests
    mycol = [40 , 600 , 820 , 1125 , 1385 ] ; %X in image
    myrow = [265 , 230 , 220 , 250 , 325 ] ; %Y in image
    
    
    myenl = 0 ;
    for i=1:repeat
        region = signal( myrow(i):myrow(i)+homo-1 , mycol(i):mycol(i)+homo-1);
        variance = var(region(:));
        mymean = mean(region(:));
        newenl = mymean/variance;
        myenl = myenl + newenl ;
    end
    
    myenl = myenl / repeat ;