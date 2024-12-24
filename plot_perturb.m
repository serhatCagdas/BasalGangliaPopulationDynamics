clear all, clc, close all;


date = '241118'; 
N = 100;

load mdata.mat
m_desired = mdata;
for i=1:length(mdata.m)
    mdata.m{i}(:) = 0;
end

prs_mtr_energy = prospective_motor_error(m_desired,mdata,1,8);

fname = sprintf('perturbResultsctx%sN%dph50.mat',date,N);
load(fname) 

prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar(sigma_amp,mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'LineWidth',1.5)
set(gca,'YScale','log');
% set(gca,'XTick',prep_time)

hold on, 

fname = sprintf('perturbResultsctx%sN%dph50NoBg.mat',date,N);
load(fname) 

prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar(sigma_amp,mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'LineWidth',1.5)
set(gca,'YScale','log');
% set(gca,'XTick',[50 200 300 400 500 700 1000])
ylabel('prospective motor error')
xlabel('noise variance')

% xlim([100 1000]);
legend({'CBGT','Ctx'} ,'Location','southeast')
set(gcf, 'Position',  [100, 50, 350, 325])