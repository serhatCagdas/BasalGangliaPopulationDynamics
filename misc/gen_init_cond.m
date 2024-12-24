function [x0] = gen_init_cond(Wc2c,Nc,num_of_init_cond, gen_method)

% if gen_method = 0, initial conditions are generated as lineer combinations
% of eigenvectors that have largest eigenvaluues

%           x_k = alpha_k * v_1 + (1-alpha_k) * v_2

% if gen_method = 1, initial conditions are generated randomly

% if gen_method = 2, initial conditions are generated as linear combination
% of different egenvectors as 
% 
%           x_k = alpha_k * v_k + (1-alpha_k)*v_(2*num_of_init_cond + 1 - k) 



x0 = zeros(Nc,num_of_init_cond);

[V,D] = calcInitStateByEnergy(Wc2c,Nc);
[ve,ie]=sort(real(D),'descend'); 

for init_ind = 1:num_of_init_cond

    if gen_method == 0
        data_coeff = init_ind/num_of_init_cond;
        v1 = V(:,ie(1));
        v2 = V(:,ie(2));
    elseif gen_method == 1
        data_coeff = rand();
        v1 = V(:,ie(1));
        v2 = V(:,ie(2));
    else
        data_coeff = 0.5;
        v1 = V(:,ie(init_ind));
        v2 = V(:,ie(2*num_of_init_cond+1-init_ind));
    end

    x0(:,init_ind) = 30*(data_coeff*v1 + (1-data_coeff)*v2);
    % x0(:,init_ind) = 30*(data_coeff*V(:,ie(1)) + (1-data_coeff)*V(:,ie(2)));

end