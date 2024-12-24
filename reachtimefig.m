clear all, close all, clc;

includeProjectPaths( )

load('reachtraj300.mat');

fg = figure, %subplot(1,2,1);
tifig = tiledlayout(fg, 2, 1, 'padding', 'tight', 'OuterPosition',[0 0 .995 1]);
nexttile
hold on;
for i = 1:8
    
    plot(all_trajx{i},all_trajy{i},'LineWidth',1.5,'Color',[0    0.4470    0.7410]);

end
   axis off; 
   xlim([-0.25 0.25]);
    ylim([0.0 0.40]);
hold off;
title('A')
txt = 'prep. dur.: 300 ms';
text(-0.07,0.01,txt, 'FontWeight', 'Bold') 

% subplot(1,2,2);
nexttile
load('reachtraj1000.mat');

hold on;
for i = 1:8
    
    plot(all_trajx{i},all_trajy{i},'LineWidth',1.5,'Color',[0    0.4470    0.7410]);

end
   axis off; 
   xlim([-0.25 0.25]);
    ylim([0.0 0.40]);
hold off;
title('B')
txt = 'prep. dur.: 1000 ms';
text(-0.07,0.01,txt, 'FontWeight', 'Bold') 


set(gcf, 'Position',  [100, 100, 350, 650])
% exportgraphics(tifig,'reachPrep3007003.eps','BackgroundColor','none')
% exportgraphics(tifig,'reachPrep3007003.png','BackgroundColor','none')