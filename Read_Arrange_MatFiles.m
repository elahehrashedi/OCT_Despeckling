clear all; close all; clc;

Dest_dir = 'C:\Users\saba\Desktop\i\';
List = dir([Dest_dir, '*.mat']);
load([Dest_dir, List(1).name]);

for index = 1 : length(List)
    MatFileName = [Dest_dir, List(index).name];
    load(MatFileName);
    Para(index).ST = FEBOTH;
    Para(index).SNR = SNRF;
    Para(index).CNR = CNRF;
    Para(index).ENL = enlf;
    Para(index).MSSIM = MSSIM;
    clear FEBOTH SNRF CNRF enlf MSSIM
end

% save Para.mat Para