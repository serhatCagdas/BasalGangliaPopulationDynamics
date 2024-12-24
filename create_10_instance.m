% Create 10 network instance and train 


foldername = 'netInstances//ctx241118N100ph50NoBg';
mkdir(foldername)

for net_ind=1:10
    
    save("net_ind",'net_ind','foldername')
    
    trainingProcedure;
    
    clear X
    clear Y
    clear x
    clear inpData 
    clear xdata
    clear noise_sig
    clear noise;
    
    load('net_ind');
    
    fname = sprintf("%s//netInstance1000Prep%d.mat",foldername,net_ind);
    save(fname);

end