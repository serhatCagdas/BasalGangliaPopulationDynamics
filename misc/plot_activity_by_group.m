function [] = plot_activity_by_group(x,dt,num_of_ele,params,name_grp, is_save, path )
    
    x2 = get_value_by_grp(x, params, name_grp);
    param_sigmoid;
    
    x = x2(1:num_of_ele,:);

    % if(strcmp(name_grp,"c"))
    %     z = sigmoid_func(x,param_sig_ctx);
    % else
        z = sigmoid_func(x,param_sig_bgt);
         
    % end

   t = (1:length(x))*dt;
   plot(t,z')
   title(name_grp)

   if(is_save)
       fpath = sprintf("%s//%s.png", path, name_grp);
       saveas(gcf,fpath);
   end
   xlabel ("time (ms)")
   ylabel("r (Hz)")

end