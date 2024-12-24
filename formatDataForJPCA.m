function [Data] = formatDataForJPCA(folderName,cond_num)
    
    addpath(folderName);
    dt = 0.1;
    t = (-1000 + dt):dt:1000;
    for cond_ind= 1:cond_num
        
        cond_ind
        fname = sprintf('%s//data%d.mat',folderName, cond_ind );
        load(fname) 
    %     Data(cond_ind).A = cmean(:,10:10:20000);
        Data(cond_ind).A = cmean';
        Data(cond_ind).times = t';
    
    end
    
    fname = sprintf('%sForJPCA',folderName);
    save(fname, 'Data')
    'Done'

end