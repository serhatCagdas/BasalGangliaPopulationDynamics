function [I] = set_value_by_grp(I,params, name_grp, value)
    
    d   = params.d;
    Nch = params.Nch;
    
    I((d(name_grp) - 1)*Nch + (1:Nch),:) = value;
 
end