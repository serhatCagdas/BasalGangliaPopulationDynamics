function [Wc2c] = gen_M1_net_weigth(Nc)

      
    gamma = 0.2; 
    daVTA =  2; 
    daVTA = 0.6; 

    M1 =  (rand(Nc)- 0.5);
    Wc =   ((1-gamma)*(M1-M1')/2 + gamma*(M1+M1')/2 ); 
    
    Wc2c= daVTA*Wc/(max(real(eig(Wc)))) - 0.6*eye(Nc);    
    % Wc2c= (daVTA^(1/Nc))*Wc/(det(Wc)^(1/Nc));

end