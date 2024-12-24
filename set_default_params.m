% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

param_cbgt; 
param_sigmoid;
param_dopamine;
param_sim;

Cinph = 30; 
tal_input = Cinph*2*0.76*2;
ctx_input_scale = 2;
stn_input =  0;
gpi_input = 0;
str1_input = 0;
str2_input = 0;

