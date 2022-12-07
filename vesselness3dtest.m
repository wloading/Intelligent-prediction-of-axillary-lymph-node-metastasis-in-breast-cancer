function [imv,v] = vesselness3dtest(im)


%% default parameters
sigma = 1;  
gamma = 2;  
alpha = 0.5; 
beta = 0.5; 
c = 15;     
wb = true;  

%% normalize
im = double(im); im = (im - min(im(:))) / (max(im(:)) - min(im(:)));

%% convert image to double
im = double(im);

%% start loop over scales
[m,n,o] = size(im);
v = zeros(m,n,o,length(sigma)); 

[hxx,hyy,hzz,hxy,hxz,hyz] = hessian3d(im,1);
hxx = power(1,gamma)*hxx;
hyy = power(1,gamma)*hyy;
hzz = power(1,gamma)*hzz;
hxy = power(1,gamma)*hxy;
hxz = power(1,gamma)*hxz;
hyz = power(1,gamma)*hyz;
[l1,l2,l3] = ...
        eigen3d_m(hxx,hxy,hxz,hxy,hyy,hyz,hxz,hyz,hzz);
[l1,l2,l3] = eigen_sort3d_m(l1,l2,l3);
ralpha = abs(l2)./abs(l3);              % 1 -> plate;   0 -> line  / 0 -> plate;   1 -> line      
rbeta = abs(l1)./sqrt(abs(l2.*l3));     % 1 -> blob;    0 -> line
ralpha(isnan(ralpha)) = 0;
rbeta(isnan(rbeta)) = 0;    
s = sqrt(l1.^2 + l2.^2 + l3.^2);   
    
vo =    ( ones(size(im)) - exp(-(ralpha.^2)/(2*alpha^2)) ) .*...
            exp(-(rbeta.^2)/(2*beta^2)) .*...
            ( ones(size(im)) - exp(-(s.^2)/(2*c^2)) );  
  
 if(wb)
      vo(l3<0) = 0;
else
      vo(l3>0) = 0;
 end    

imv = vo; 
end