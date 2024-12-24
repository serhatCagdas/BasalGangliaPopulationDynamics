%% ENUMERATION 
nrnGrps = ["c" "s1" "s2" "stn" "gpe" "gpi" "th"  ];
nrnInds = 1:length(nrnGrps);
d = containers.Map(nrnGrps,nrnInds);


%% NETWORK PARAMS
Ng = length(nrnGrps);   %number of groups
Nch = 100;              %number of units

params.d = d;
params.Nch = Nch;

N  = Ng*Nch;

% Connection weight matrice
nwbg = 0.00 ; % weight variability for bg
W  = zeros(N);

%% INTERNAL CONNECTION OF BG
Wgpe2gpi  =  -0.1*(eye(Nch) + nwbg*rand(Nch));
Wgpe2stn  =  (-1.5)*(eye(Nch) + nwbg*rand(Nch));
W = insertWeightToMatrix(W, params, "gpe" , "gpi" ,Wgpe2gpi);
W = insertWeightToMatrix(W, params, "gpe" , "stn" ,Wgpe2stn);

Wstn2gpi  = 1*3.0*(ones(Nch) + nwbg*rand(Nch))*10.0/Nch;%10.0 for RELU like
Wstn2gpe  = 1*2.0*(ones(Nch) + nwbg*rand(Nch))*10.0/Nch;%10.0
% Wstn2gpi  = 14*3.0*(eye(Nch) + nwbg*rand(Nch))*10.0/Nch;%10.0 for RELU like
% Wstn2gpe  = 14*2.0*(eye(Nch) + nwbg*rand(Nch))*10.0/Nch;%10.0
W = insertWeightToMatrix(W, params, "stn" , "gpi" ,Wstn2gpi);
W = insertWeightToMatrix(W, params, "stn" , "gpe" ,Wstn2gpe);

Ws12gpi = -3.0*(eye(Nch) + nwbg*rand(Nch));
W = insertWeightToMatrix(W, params, "s1" , "gpi" ,Ws12gpi);

Ws22gpe = -2.5*(eye(Nch) + nwbg*rand(Nch));
W = insertWeightToMatrix(W, params, "s2" , "gpe" ,Ws22gpe); 

%% INTERNAL CONNECTION OF CTX
[Wc2c] = gen_M1_net_weigth3(Nch);% 0.5*(rand(Nch)- 0.5);%
% load('tempWc2c')
W = insertWeightToMatrix(W, params, "c","c",Wc2c);


%% INTER-CONN OF CTX-TH
nwinter = 0.00; % weight variability for interconnection of ctx and th
Wgpi2th =  -30.0*(eye(Nch) + nwinter*ones(Nch));
W = insertWeightToMatrix(W, params, "gpi" , "th" ,Wgpi2th);

Wth2c  =   1.5*0.6*(eye(Nch) + nwinter*ones(Nch));
W = insertWeightToMatrix(W, params, "th" , "c" ,Wth2c);

Wc2s1   =  0.3*(eye(Nch) + nwinter*ones(Nch));
Wc2s2   =  0.25*(eye(Nch)+ nwinter*ones(Nch));
Wc2stn  =  1.0*(eye(Nch) + nwinter*ones(Nch));
Wc2th   =  0.0*(eye(Nch) + nwinter*ones(Nch));% 0.4*(eye(Nch) + nwinter*ones(Nch));
W = insertWeightToMatrix(W, params, "c" , "s1" ,Wc2s1);
W = insertWeightToMatrix(W, params, "c" , "s2" ,Wc2s2);
W = insertWeightToMatrix(W, params, "c" , "stn" ,Wc2stn);
W = insertWeightToMatrix(W, params, "c" , "th" ,Wc2th);

%% External input weights
Wex  = eye(N);%0.8*eye(N); % external input

%% unit model params
tau_c = 150;        %time constant of cortical units
tau = 5*ones(N,1);  %time constant of other units  
tau = set_value_by_grp(tau, params, "c", tau_c);




