clear all, close all, clc

Ne = 100;
Ni = 50;
Ncol = sqrt(Ne);

ei_rate = Ne/Ni;

e2e = 0.1 ;
i2i = -0.1 ;
e2i = 0.5;
i2e = -0.5;

sigmae = 0.2*rand(1,Ne);
sigmai = 0.2*rand(1,Ni);

E2E = zeros(Ne,Ni);
E2I = zeros(Ne,Ni);
I2E = zeros(Ni,Ne);
I2I = zeros(Ni,Ni);


for i = 1:Ne
 for j = 1:Ne
    
    ix = rem(i,Ncol);
    iy = (i - ix)/Ncol;

    jx = rem(j,Ncol);
    jy = (j - jx)/Ncol;

    dist_ij = sqrt((ix-jx)^2 + (iy-jy)^2); 
    E2E(i,j) = e2e*rand(1,1)*exp(-sigmae(i)*abs(dist_ij)); 
  
 end
 
 for j = 1:Ni
    
    ix = rem(i,Ncol);
    iy = (i - ix)/Ncol;

    jx = rem(j*ei_rate,Ncol);
    jy = (j*ei_rate - jx)/Ncol;

    dist_ij = sqrt((ix-jx)^2 + (iy-jy)^2);  
    E2I(i,j) = e2i*rand(1,1)*exp(-sigmae(i)*abs(dist_ij)); 
  
 end

end

for i = 1:Ni
 for j = 1:Ne
    
    ix = rem(i*ei_rate,Ncol);
    iy = (i*ei_rate - ix)/Ncol;
 
    jx = rem(j,Ncol);
    jy = (j - jx)/Ncol;

    dist_ij = sqrt((ix-jx)^2 + (iy-jy)^2);  
    I2E(i,j) = i2e*rand(1,1)*exp(-sigmai(i)*abs(dist_ij)); 
  
 end
 
 for j = 1:Ni
    
    ix = rem(i*ei_rate,Ncol);
    iy = (i*ei_rate - ix)/Ncol;
 
    jx = rem(j*ei_rate,Ncol);
    jy = (j*ei_rate - jx)/Ncol;
 
    dist_ij = sqrt((ix-jx)^2 + (iy-jy)^2);  
    I2I(i,j) = i2i*rand(1,1)*exp(-sigmai(i)*abs(dist_ij));
  
 end

end


Wc = [E2E E2I; I2E I2I];



daVTA = 0.4;
Wc2c  = daVTA*Wc/(max(real(eig(Wc))));

Msym = (Wc2c + Wc2c')/2;
Mskw = (Wc2c - Wc2c')/2; 

[Vspat,Dspat] = eig(Wc2c  );
lambdas = diag(Dspat);
figure,plot(real(lambdas), imag(lambdas), '.') 
 xlim([-5 5])
 ylim([-5 5]) 
ylabel('imag. part')
xlabel('real part')

