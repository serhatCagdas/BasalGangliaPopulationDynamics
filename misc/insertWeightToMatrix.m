function [W] = insertWeightToMatrix(W, params, Gpre , Gpost ,weights)

    d   = params.d;
    Nch = params.Nch;

    W((d(Gpost)-1)*Nch + (1:Nch), (d(Gpre)-1)*Nch + (1:Nch)) = weights;

end