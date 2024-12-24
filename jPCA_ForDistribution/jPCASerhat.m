
% loading libraries
addpath 'fromMarksLibraries' -END
addpath 'CircStat2010d' -END

% loading data
% load exampleData
% load SerhatData2401131

%&these&will&be&used&for&everything&below&
jPCA_params.softenNorm =5; %&how&each&neuron's&rate&is&normized,&see&below&
jPCA_params.suppressBWrosettes = true; %&these&are&useful&sanity&plots,&but&lets&ignore&them&for&now&
jPCA_params.suppressHistograms = true; %&these&are&useful&sanity&plots,&but&lets&ignore&them&for&now&

%% EX1: FIRST PLANE
% plotting the first jPCA plane for 200 ms of data, using 6 PCs (the default)
times = 50:0.1:150;  % 50 ms before 'neural movement onset' until 150 ms after
jPCA_params.numPCs = 6;  % default anyway, but best to be specific
% Data2 = Data(1:10);
[Projection, Summary] = jPCA(Data, times, jPCA_params);

params.lineWidth = 1.5;
params.useAxes = true;
params.useLabel = false; 
[col_struct,~,~] = phaseSpace(Projection, Summary,params);  % makes the plot

% printFigs(gcf, '.', '-dpdf', 'Basic jPCA plot');  % prints in the current directory as a PDF
