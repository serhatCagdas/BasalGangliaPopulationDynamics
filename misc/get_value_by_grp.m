function [O] = get_value_by_grp(I, params, name_grp)
    
    d   = params.d;
    Nch = params.Nch;
    
    O = I((d(name_grp) - 1)*Nch + (1:Nch),:);

end