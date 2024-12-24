trajx = []; 
trajy = [];



figure 
for i = 1:int32(2000*dt):Nn
    
    theta1(i);
  
    y1 = L1*sin(theta1(i));
    x1 = L1*cos(theta1(i));
    
    y2 = y1 + L2*sin(theta1(i) + theta2(i));
    x2 = x1 + L2*cos(theta1(i) + theta2(i));
    trajx = [trajx x2];
    trajy = [trajy y2];
    
    if exist('goal_theta','var') == 1

        plot(0+ d*cos(goal_theta) ,d + d*sin(goal_theta),'x','Color','g')
        hold on;

    end

    plot([0 x1 x2],[0 y1 y2],'Color',[0 0.45 i/Nn], LineWidth=1.5) 
    hold on;
    plot(trajx,trajy,'o','Color','r')
    
    xlim([-0.25 0.4]);
    ylim([-0.3 0.40]);
    set(gca,'XColor', 'none','YColor','none')
    % M = getframe(gcf);
    % writeVideo(myVideo,M);
    % exportgraphics(gcf,animFname,'Append',true); 

    hold off; 

    % pause(0.1); %uncomment for animation
end


% close(myVideo);
