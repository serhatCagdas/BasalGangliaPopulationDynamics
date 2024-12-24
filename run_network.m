for i = global_ind: (global_ind + int32(run_dur/dt) -1 )
    
    %LOGISTIC
    z = sigmoid_func(x(:,i-1),param_sig_bgt);

    dopeffect = ones(N,1);
    dopeffect = set_value_by_grp(dopeffect,params, "s1", (bld1 +dad1));
    dopeffect = set_value_by_grp(dopeffect,params, "s2", 1/(bld2 +dad2)); 

    %update unit values 
    x(:,i) = x(:,i-1)  + (-x(:,i-1) + dopeffect.*(W*z + Wex*inpData(:,i-1)) + noise_sig(:,i-1))*dt./tau  ; 
    
    % update ctx units
    % TANH FOR CTX
    % x_ctx = get_value_by_grp(x(:,i-1), params, "c");
    % z_ctx = sigmoid_func(x_ctx,param_sig_ctx);
    % z = set_value_by_grp(z,params, "c", z_ctx);
    % 
    % tempc = x(:,i-1)  + (-x(:,i-1) + dopeffect.*(W*z + Wex*inpData(:,i-1)) + noise_sig(:,i-1))*dt./tau  ; 
    % temp_ctx = get_value_by_grp(tempc, params, "c");
    % x(:,i) = set_value_by_grp(x(:,i),params, "c", temp_ctx);

    noise_sig(:,i) = noise_sig(:,i-1) + (-noise_sig(:,i-1) + noise(:,i-1))/50*dt;
 
end

global_ind = global_ind + (int32(run_dur/dt) - 1);