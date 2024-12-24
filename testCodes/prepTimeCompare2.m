clear all, close all, clc

isNoisy = true;

date = '241020'; 

N_neural = [50 100 150];

if(isNoisy)
    suffx = '';
else
    suffx = 'NoNoise';
end

subplot(1,2,1)

fname = sprintf('prepTimeResultsctx%sN%dph50Prep%s.mat',date,N_neural(1),suffx);
load(fname)
load mdata.mat

m_desired = mdata;
for i=1:length(mdata.m)
    mdata.m{i}(:) = 0;
end

prs_mtr_energy = prospective_motor_error(m_desired,mdata,1,8);
prs_mtr_error = prs_mtr_error / prs_mtr_energy;

errorbar([60 260 660 960],mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'ok','LineWidth',1.5)
set(gca,'YScale','log');
xlim([0,1100])
hold on, 
fname = sprintf('prepTimeResultsctx%sN%dph50Prep%s.mat',date, N_neural(2),suffx);
load(fname)
prs_mtr_energy = prospective_motor_error(m_desired,mdata,1,8);
prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar([100 300 700 1000],mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'or','LineWidth',1.5)
set(gca,'YScale','log');
xlim([0,1100])

hold on, 
fname = sprintf('prepTimeResultsctx%sN%dph50Prep%s.mat',date,N_neural(3),suffx);
load(fname) 
prs_mtr_energy = prospective_motor_error(m_desired,mdata,1,8);
prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar([140 340 740 1040],mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'og','LineWidth',1.5)
set(gca,'YScale','log');
set(gca,'XTick',[100 300 700 1000])

xlim([0,1100])
title('sigma : 0.2')
% legend('N=70', 'N=100', 'N=200')

isNoisy = false;

if(isNoisy)
    suffx = '';
else
    suffx = 'NoNoise';
end

subplot(1,2,2)


fname = sprintf('prepTimeResultsctx%sN%dph50Prep%s.mat',date,N_neural(1),suffx);
load(fname)
load mdata.mat

m_desired = mdata;
for i=1:length(mdata.m)
    mdata.m{i}(:) = 0;
end

prs_mtr_energy = prospective_motor_error(m_desired,mdata,1,8);
prs_mtr_error = prs_mtr_error / prs_mtr_energy;

errorbar([60 260 660 960],mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'ok','LineWidth',1.5)
set(gca,'YScale','log');
xlim([0,1100])
hold on, 
fname = sprintf('prepTimeResultsctx%sN%dph50Prep%s.mat',date,N_neural(2),suffx);
load(fname)
prs_mtr_energy = prospective_motor_error(m_desired,mdata,1,8);
prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar([100 300 700 1000],mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'or','LineWidth',1.5)
set(gca,'YScale','log');
xlim([0,1100])

hold on, 
fname = sprintf('prepTimeResultsctx%sN%dph50Prep%s.mat',date,N_neural(3),suffx);
load(fname) 
prs_mtr_energy = prospective_motor_error(m_desired,mdata,1,8);
prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar([140 340 740 1040],mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'og','LineWidth',1.5)
set(gca,'YScale','log');
set(gca,'XTick',[100 300 700 1000])

xlim([0,1100])
leg1 = sprintf('N = %d', N_neural(1));
leg2 = sprintf('N = %d', N_neural(2));
leg3 = sprintf('N = %d', N_neural(3)); 
legend(leg1, leg2, leg3)
title('sigma : 0')

set(gcf, 'Position',  [100, 100, 700, 300])
