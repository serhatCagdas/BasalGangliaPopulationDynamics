clear all, close all, clc

folderName = "dataSet//data241206";

averageBehavior;

averageBehaviorplot;

formatDataForJPCA(folderName,8)

addpath("jPCA_ForDistribution") 
addpath(genpath("jPCA_ForDistribution"));

jPCAdatafname = sprintf("%sForJPCA",folderName);
load(jPCAdatafname)
% load('exampleData.mat')
jPCASerhat
save('dataSet//data241019//jPCA','Projection','Summary','params','col_struct')
