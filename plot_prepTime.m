clear all, clc, close all;


date = '241118'; 
N = 100;

load mdata.mat
m_desired = mdata;
for i=1:length(mdata.m)
    mdata.m{i}(:) = 0;
end

prs_mtr_energy = prospective_motor_error(m_desired,mdata,1,8);

fname = sprintf('prepTimeResultsctx%sN%dph50NoNoise.mat',date,N);
load(fname) 
figure, subplot(2,1,1);
prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar(prep_time,mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'LineWidth',1.5)
set(gca,'YScale','log');
% set(gca,'XTick',prep_time)

hold on, 

fname = sprintf('prepTimeResultsctx%sN%dph50NoBgNoNoise.mat',date,N);
load(fname) 

prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar(prep_time,mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),...
    '--','LineWidth',1.5,"MarkerSize",10)
set(gca,'YScale','log');
set(gca,'XTick',[50 200 300 400 500 700 1000])

ylabel('prospective motor error')
xlabel('preperation time (ms)')
t = '(\sigma = 0.0)';
text(400,50,t, 'FontWeight', 'Bold')
title('A')
% legend({'CBGT','Ctx'} ,'Location','northeast')

subplot(2,1,2);

fname = sprintf('prepTimeResultsctx%sN%dph50.mat',date,N);
load(fname)  
prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar(prep_time,mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),'LineWidth',1.5)
set(gca,'YScale','log');
% set(gca,'XTick',prep_time)

hold on, 

fname = sprintf('prepTimeResultsctx%sN%dph50NoBg.mat',date,N);
load(fname) 

prs_mtr_error = prs_mtr_error / prs_mtr_energy;
errorbar(prep_time,mean(prs_mtr_error),min(prs_mtr_error),max(prs_mtr_error),...
    '--','LineWidth',1.5,"MarkerSize",10)
set(gca,'YScale','log');
set(gca,'XTick',[50 200 300 400 500 700 1000])

ylabel('prospective motor error')
xlabel('preperation time (ms)')

legend({'CBGT','Ctx'} ,'Location','northeast')

set(gcf, 'Position',  [100, 50, 350, 650])
t = '(\sigma = 0.2)';
text(400,50,t, 'FontWeight', 'Bold') 
title('B')
% exportgraphics(tifig,'figPrepTime241121.eps','BackgroundColor','none')
% exportgraphics(tifig,'figPrepTime241121.png','BackgroundColor','none')
