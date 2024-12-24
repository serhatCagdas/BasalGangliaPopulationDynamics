clear all,close all
clc

dt = 0.1;
dur = 2000;
prep_dur = 1000; % ms
phasic_dur = 50;
move_dur = dur - prep_dur -phasic_dur;
prep_step = int32(prep_dur/dt); 
phasic_step = int32(phasic_dur/dt);
move_step = int32(move_dur/dt);
N = 100;

folderName = "dataSet//data241023ctxTest4";
addpath(folderName);
cond_num = 8;

trim_step = 0;

X_prep = zeros(N,cond_num*(prep_step-trim_step));
X_phasic = zeros(N,cond_num*phasic_step);
X_move = zeros(N,cond_num*move_step); 

corr_val = zeros(cond_num,1); 

for cond_ind= 1:cond_num
    clear cmean;
    cond_ind
    fname = sprintf('%s//data%d.mat',folderName, cond_ind );
    load(fname) 
    X_prep(:,(cond_ind-1)* (prep_step-trim_step) +(1:(prep_step-trim_step))) = cmean(:,trim_step+1:prep_step);
    X_phasic(:,(cond_ind-1)* phasic_step +(1:phasic_step)) = cmean(:,prep_step + (1:phasic_step));
    X_move(:,(cond_ind-1)* move_step + (1:move_step)) = cmean(:,prep_step + phasic_step + (1:move_step));
    corr_val(cond_ind) = corr(cmean(:,prep_step),cmean(:,prep_step + phasic_step));
 
end

X= [X_prep X_phasic X_move]';
ranges = range(X);
normFactors = (ranges+5);

for i = 1:N
    
    
    X_prep(i,:) = X_prep(i,:)/ normFactors(i); 
    X_phasic(i,:) = X_phasic(i,:)/ normFactors(i); 
    X_move(i,:) = X_move(i,:)/ normFactors(i);
    
end


[coeff_prep, score_prep,latent_prep] = pca(X_prep');
[coeff_move, score_move,latent_move] = pca(X_move');

latent_prep= latent_prep/sum(latent_prep);
latent_move = latent_move/sum(latent_move);

var_prep = var(X_prep'*coeff_prep);
latent_prep= var_prep/sum(var_prep);

var_move = var(X_move'*coeff_move);
latent_move= var_move/sum(var_move);

var_move_on_prep_pc = var(X_move'*coeff_prep);
latent_move_on_prep = var_move_on_prep_pc/sum(var_move_on_prep_pc);

var_prep_on_move_pc = var(X_prep'*coeff_move);
latent_prep_on_move = var_prep_on_move_pc/sum(var_prep_on_move_pc);

var_phasic_on_prep_pc = var(X_phasic'*coeff_prep);
latent_phasic_on_prep = var_phasic_on_prep_pc/sum(var_phasic_on_prep_pc);

var_phasic_on_move_pc = var(X_phasic'*coeff_move);
latent_phasic_on_move = var_phasic_on_move_pc/sum(var_phasic_on_move_pc);


figure,bar([latent_prep(1:100);latent_prep_on_move(1:100)]')
ylim([0,1])
title('prep. variance')


figure,bar([latent_phasic_on_prep(1:100);latent_phasic_on_move(1:100)]')
ylim([0,1])
title('phas. variance')

figure,bar([latent_move_on_prep(1:100);latent_move(1:100)]')
ylim([0,1])
title('move. variance')
legend('prep. PC','move. PC');

