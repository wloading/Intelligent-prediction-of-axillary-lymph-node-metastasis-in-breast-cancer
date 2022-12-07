function f = mat_to_vess(mat)
[a,b,c] = size(mat);
im = mat;
mat = vesselness3dtest(mat);
for i =1:c
   I = mat(:,:,i); 
   T = max(I(:)).*0.9;
   I = im2bw(I,T);
   mat(:,:,i) = I;
end
f = mat;
end