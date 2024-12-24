function [O] = sigmoid_func(I,param)
    
    if(strcmp(param.type,"logistic"))

        O = param.a ./ (1 + exp(param.b*(-I + param.c)));

    elseif(strcmp(param.type,"tanh"))
        
        O =  param.a*tanh(param.b*I);
    end

    % 
    O = log(exp(0.85*I +5) + 1);
    % O = double(O<80).*O + double(O>=80)*80;
    % 
    % O=I;

end