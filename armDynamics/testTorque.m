close all;
all_trajx = cell(length(theta_reach),1);
all_trajy = cell(length(theta_reach),1);

for reach_ind=1:length(theta_reach)
      
    theta1 = [theta1init; zeros(Nn-1,1)]; 
    theta2 = [theta2init; zeros(Nn-1,1)];

    theta1_d1 = zeros(Nn,1);   
    theta2_d1 = zeros(Nn,1);  

    m_goal = mdata.m{reach_ind};
    % Binv = inv(B);

    for n = 1:Nn-1 
  
        M = [a1+2*a2*cos(theta2(n)) a3+a2*cos(theta2(n));
            a3+a2*cos(theta2(n)) a3];
    
        X = a2*sin(theta2(n))*[-theta2_d1(n)*(2*theta1_d1(n)+ theta2_d1(n));
                                theta1_d1(n)^2];
    
         
        temp = [theta1_d1(n); theta2_d1(n)] + (M\(m_goal(:,n) - X - B*[theta1_d1(n); theta2_d1(n)]))*dt;
        
        theta1_d1(n+1) = temp(1);
        theta2_d1(n+1) = temp(2);
           
        theta1(n+1) = theta1(n) + theta1_d1(n)*dt ;
        theta2(n+1) = theta2(n) + theta2_d1(n)*dt;
 
    end

    x = L1*cos(theta1)+L2*cos(theta1+theta2);
    y = L1*sin(theta1)+L2*sin(theta1+theta2);
    % plot(x,y)
    % hold on;
    goal_theta = mdata.theta(reach_ind); 

    animFname = sprintf('myVideoFile%d.gif', reach_ind);
    % myVideo = VideoWriter(sprintf('myVideoFile%d', i)); %open video file
    % myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
    % open(myVideo)

    trajectoryOfArmSim;

    all_trajx{reach_ind} = trajx;
    all_trajy{reach_ind} = trajy;

end

% for i=1:length(theta_reach)
% 
%     m_goal = mdata.m{i};
% 
%     figure,plot(t,m_goal(1,:),t,m_goal(2,:));
%     ylim([-4 4]*1e-4);
%     % xlim([0 600])
% end
figure,

hold on;
for i = 1:8
    
    plot(all_trajx{i},all_trajy{i},'LineWidth',1.5,'Color',[0    0.4470    0.7410]);

end
   axis off; 
   xlim([-0.25 0.25]);
    ylim([0.05 0.40]);
hold off;
