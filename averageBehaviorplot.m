clear all, clc, close all

ENABLE_SAVE = true;
date_of_data = "241023ctxTest4";
T_NUM = 8;

colorScale1 = 1/T_NUM:1/T_NUM:1;
colorScale2 = 1:-1/T_NUM:1/T_NUM;

colorScale = [colorScale1' colorScale2' zeros(T_NUM,1)];

if(ENABLE_SAVE)
    fig_foldername = sprintf('figs%s',date_of_data);
    mkdir(fig_foldername)
end

for i = 1:T_NUM
     
    fname = sprintf('dataSet//data%s//data%d',date_of_data,i );
    load(fname)
    alldata(i).cmean = cmean;

end

N= length(init_cc);

for nrn_ind = 1:N
    nrn_ind
    figure,
    
    for i = 1:T_NUM
        i
%         fname = sprintf('data2312062//data%d',i );
%         load(fname)
        hold on;
        plot(alldata(i).cmean(nrn_ind,:), 'Color',colorScale(i,:),LineWidth=1.5)
    
    end
%     ylim([-10 30])
    
    t = sprintf('Nrn Ind : %d', nrn_ind);
    title(t)
    if(ENABLE_SAVE)
        fname = sprintf('%s//NrnInd%d.svg',fig_foldername, nrn_ind); 
        saveas(gcf,fname) 
        fname = sprintf('%s//NrnInd%d.pdf',fig_foldername, nrn_ind);
        exportgraphics(gcf,fname,'ContentType','vector')
    else
        pause(0.5)
    end
    close all

end

warn_the_end() 
