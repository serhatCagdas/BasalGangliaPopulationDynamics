function [x0] = gen_random_int_cond(Wc2c,Nc,num_of_init_cond, is_rand)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

x0 = zeros(Nc,num_of_init_cond);

[V,D] = calcInitStateByEnergy(Wc2c,Nc);
[ve,ie]=sort(real(D)); 

for init_ind = 1:num_of_init_cond

    if is_rand == 0
        data_coeff = init_ind/num_of_init_cond;
    else
        data_coeff = rand();
    end

    x0(:,init_ind) = 30*(data_coeff*V(:,ie(Nc)) + (1-data_coeff)*V(:,ie(Nc-1)));
    % x0(:,init_ind) = 30*(data_coeff*V(:,ie(1)) + (1-data_coeff)*V(:,ie(2)));

end