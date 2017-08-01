%here we add all the spare codes which are not a part of whole ANN and
%Autoencoder

%-------------------------------------------------------------------------
% CODE FOR 6pics
load('C:\Users\Elaheh\Dropbox\Elahe_Saba\OCT despeckling\paper\3pics\yfilterall.mat')
plot(YfilterAll(:,[28,81,97,147,163,197]));
Filter1 = YfilterAll([2,6,10],[28,81,97,147,163,197]) ;
Filter2 = YfilterAll([13,16,20],[28,81,97,147,163,197]) ;
Filter3 = YfilterAll([23,24,25],[28,81,97,147,163,197]) ;
figure,bar(Filter1);
figure,bar(Filter2);
figure,bar(Filter3);


%-------------------------------------------------------------------------
% CODE FOR COLORMAP
All1D = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,22,0,0,15,10,238];
All2D = [1,0;2,0;3,0;4,0;5,0;6,0;7,0;8,0;9,0;10,0;11,0;12,0;
    13,0;14,0;15,0;16,0;17,0;18,0;19,0;20,22;21,0;22,0;23,15;24,10;25,238];
All3D = [1,1,0;1,2,0;1,3,0;1,4,0;1,5,0;1,6,0;1,7,0;1,8,0;1,9,0;1,10,0;1,11,0;1,12,0;
    1,13,0;1,14,0;1,15,0;1,16,0;1,17,0;1,18,0;1,19,0;1,20,22;1,21,0;1,22,0;1,23,15;1,24,10;1,25,238];
figure
surf(All3D)
colormap hot


%-------------------------------------------------------------------------
% CODE FOR YFILTER BARS
Cat{1} = [1:8, 11:14];
Cat{2} = [9:10, 15:22];
Cat{3} = 23:25;

Cat{4} = [1:8, 11:14,9:10, 15:22,23:25] ;

F1 = Yfilter (Cat{1},:);
F2 = Yfilter (Cat{2},:);
F3 = Yfilter (Cat{3},:);

Fall = Yfilter (Cat{4},:);

[I,labels1] = max (F1);
sum(M(:) == 6)
X = [0,223,0,0,0,60,0,0,0,2,0,0];


[I,labels2] = max (F2);
Y = [0,0,0,0,0,0,0,285,0,0];

[I,labels3] = max (F3);
Z = [29,10,246];

All = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,22,0,0,15,10,238];

YfilterAll = [F1',F2',F3'];
YfilterAll = YfilterAll';


%-------------------------------------------------------------------------
% CODE FOR ann
plot(YfilterAll(:,[56,119,130,236,246]),'DisplayName','Yfilter(:,[45,98,236])')

Yfilter = Yfilter';
[I,labels] = max (Yfilter);

features = X (1:25,:,27); % features of main image
setdemorandstream(491218382);
net = patternnet(3);
[net,tr] = train(net,features,labels3);
nntraintool
testX = features(:,tr.testInd);
testT = labels(:,tr.testInd);

testY = net(testX);
testIndices = vec2ind(testY);
plotconfusion(testT,testY)

