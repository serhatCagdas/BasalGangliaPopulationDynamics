clear all, close all, clc;

ENABLE_SAVE = true;
date_of_data = "241019";
T_NUM = 8;

fname = sprintf('dataSet//data%s//jPCA.mat',date_of_data );
load(fname);
titles = {'A',''};

for i = 1:T_NUM
     
    fname = sprintf('dataSet//data%s//data%d',date_of_data,i );
    load(fname)
    alldata(i).cmean = cmean;

end

N= [81,84];%[4, 35, 42, 65, 80, 89];

fg = figure,
% tifig = tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact');
tifig = tiledlayout(fg, 1, 3, 'padding', 'tight', 'OuterPosition',[0 0 .995 1]);

for nrn_index = 1:length(N)
    nrn_ind = N(nrn_index);
    
    nexttile;%subplot(1,3,nrn_index);
    for i = 1:T_NUM
        i
%         fname = sprintf('data2312062//data%d',i );
%         load(fname)
        hold on;
        plot(alldata(i).cmean(nrn_ind,:), 'Color',col_struct.colors{i},LineWidth=1.5)
        axis off

    end
    ylim([-5 28])

    plot(0,0,'.k','MarkerSize',10)
    txt = 'target';
    text(0,-1,txt)

    plot(11000,0,'.k','MarkerSize',10)
    txt = 'move onset';
    text(11000,-1,txt)
    
    t = sprintf('Nrn Ind : %d', nrn_ind);
    text(8000,26,t)
    title(titles{nrn_index})
      
end

 nexttile;%subplot(1,3,3);
params.reusePlot = 1;
hold on;
phaseSpace(Projection, Summary,params);
title('B')
axis off
set(gcf, 'Position',  [100, 100, 1000, 350])
exportgraphics(tifig,'figRotational241019.eps','BackgroundColor','none')
exportgraphics(tifig,'figRotational241019.png','BackgroundColor','none')
