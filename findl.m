function [lmodel,fmat]= findl(mat,LC,path,position)
j = 1;
for i = (LC-1):(LC+4) 
    I = dicomread([path,num2str(i,'%03d'),'.dcm']);
    I = imcrop(I,position);
    mat1(:,:,j) = I;
    j=j+1;
end
imv = hessianlinba(mat1);
[a,b,c] = size(imv);
max_v = 0;
num = 0;

j = 1;
for i =1:3
    imv1(:,:,j) = imv(:,:,i);
%     mat2(:,:,j) =  double(mat1(:,:,i));
    j = j+1;
end   
[max_v,index]=max(imv1(:));
[x,y,z] = ind2sub(size(imv1),index);
LC = z;
figure(1);
imshow(mat1(:,:,z),[]);
%修改成为半自动
%需要做出一个判断
disp('this? y or n');
panduan = input('panduan','s');
if(panduan =='n')
close(figure(1));
figure(1);
subplot(1,3,1);
imshow(mat1(:,:,1),[]);
subplot(1,3,2);  
imshow(mat1(:,:,2),[]);
subplot(1,3,3);
imshow(mat1(:,:,3),[]);
z = input('shoudongxuanze');
LC = z;
else 
   z =z;
end
%
max_image = imv1(:,:,z);
close(figure(1));
figure(1);
imshow(mat1(:,:,LC),[]);
set(gcf,'outerposition',get(0,'screensize'));
keydoprown = waitforbuttonpress;
if(keydoprown == 1)
    [x0,y0] = ginput(1);
end
close(figure(1));
lix = round(y0);
liy = round(x0);
liz = z;
[nRow, nCol, nSli] = size(mat1);
J = false(nRow, nCol, nSli);
regval = double(mat1(lix,liy,liz));
J(lix,liy,liz)=true;
I3 = mat1(:,:,LC);
que = [lix,liy,liz];
thresval=(max(I3(:))-min(I3(:)))*0.1;
while size(que,1)
    xv = que(1,1);
    yv = que(1,2);
    zv = que(1,3);
    que(1,:) = [];
    for i = -1:1
        for j= -1:1
            for k = -1:1
                if xv+i>0 && xv+i<=nRow &&...
                   yv+j>0 && yv+j<=nCol &&...
                   zv+k>0 && zv+k<=nSli &&...
                   any([i, j, k]) &&...
                   ~J(xv+i, yv+j, zv+k) &&...
                   mat1(xv+i, yv+j, zv+k) <= (regval + thresval)&&...
                   mat1(xv+i, yv+j, zv+k) >= (regval - thresval)
                        J(xv+i, yv+j, zv+k) = true; 
                        que(end+1,:) = [xv+i, yv+j, zv+k];
                        regval = mean(mean(mat1(J > 0)));
                end
            end
        end
    end
end

P = [];
for cSli = 1:nSli
    if ~any(J(:,:,cSli))
        continue
    end
        J(:,:,cSli) =bwmorph(J(:,:,cSli), 'dilate');
        J(:,:,cSli) =imfill(J(:,:,cSli), 'holes'); 
end
lmodel = J;
fmat = mat1;
imshow(J(:,:,2),[]);
end