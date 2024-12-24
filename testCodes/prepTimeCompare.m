clear all, clc, close all;

load mdata.mat
m_desired = mdata;
for i=1:length(mdata.m)
    mdata.m{i}(:) = 0;
end

prs_mtr_energy = prospective_motor_error(m_desired,mdata,1,8);

load('prepTimeResultsctx240919N70PrepNoNoise.mat')
figure, 
p1 = semilogy(prep_time,mean_error/prs_mtr_energy,'g',LineWidth=2); 

hold on,
load('prepTimeResultsctx240919N100PrepNoNoise.mat')
p2 = semilogy(prep_time,mean_error/prs_mtr_energy,'r',LineWidth=2);


hold on,
load('prepTimeResultsctx240919N200PrepNoNoise.mat')
p3 = semilogy(prep_time,mean_error/prs_mtr_energy,'b',LineWidth=2);
ylabel('prospective motor error')
xlabel('preperation time (ms)')

legend([p1 p2 p3],{'N=70','N=100','N=200'})

