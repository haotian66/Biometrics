sumthetam=zeros(7,7);
sumxm=zeros(7,7);
sumym=zeros(7,7);
matchm=zeros(7,7);
unmatchm=zeros(7,7);
probe={n1,n2,n3,n4,n5,n6,n7};
gallery=probe;
for p=1:7
    for g=1:7
matrix1=probe{p};
matrix2=gallery{g};
[l1,m1]=size(matrix1);
[l2,m2]=size(matrix2);
a=zeros(200,200,200);
for i=1:l1
    for j=1:l2
        dtheta=matrix1(i,3)-matrix2(j,3);
        dx=matrix1(i,1)-matrix2(j,1)*cos(dtheta*pi/180)-matrix2(j,2)*sin(dtheta*pi/180);
        dy=matrix1(i,2)+matrix2(j,1)*sin(dtheta*pi/180)-matrix2(j,2)*cos(dtheta*pi/180);
        a(floor(dtheta/20)+100,floor(dx/20)+100,floor(dy/20)+100)=a(floor(dtheta/20)+100,floor(dx/20)+100,floor(dy/20)+100)+1;
    end
end
max=a(1,1,1);
im=1;
jm=1;
km=1;
for i=1:200
    for j=1:200
        for k=1:200
            if a(i,j,k)>max
                max=a(i,j,k);
                im=i;
                jm=j;
                km=k;
            end
        end
    end
end
for i=1:200
    for j=1:200
        for k=1:200
            if a(i,j,k)==max
                fprintf('same');
            end
        end
    end
end
sumtheta=0;
sumx=0;
sumy=0;
for i=1:l1
    for j=1:l2
        dtheta=matrix1(i,3)-matrix2(j,3);
        dx=matrix1(i,1)-matrix2(j,1)*cos(dtheta*pi/180)-matrix2(j,2)*sin(dtheta*pi/180);
        dy=matrix1(i,2)+matrix2(j,1)*sin(dtheta*pi/180)-matrix2(j,2)*cos(dtheta*pi/180);
        if floor(dtheta/20)+100==im && floor(dx/20)+100==jm && floor(dy/20)+100==km
            sumtheta=sumtheta+dtheta;
            sumx=sumx+dx;
            sumy=sumy+dy;
        end
    end
end
sumtheta=sumtheta/a(im,jm,km);
sumx=sumx/a(im,jm,km);
sumy=sumy/a(im,jm,km);
sumthetam(p,g)=sumtheta;
sumxm(p,g)=sumx;
sumym(p,g)=sumy;
for i=1:l1
    matrix1(i,1)=matrix1(i,1)*cos(sumtheta*pi/180)+matrix1(i,2)*sin(sumtheta*pi/180)-sumx;
    matrix1(i,2)=-matrix1(i,1)*sin(sumtheta*pi/180)+matrix1(i,2)*cos(sumtheta*pi/180)-sumy;
end
match=0;
for i=1:l1
    for j=1:l2
        d=sqrt((matrix1(i,1)-matrix2(j,1))^2+(matrix1(i,1)-matrix2(j,1))^2);
        dangle=abs(matrix1(i,3)-matrix2(j,3));
        if d<20 && dangle<20
            match=match+1;
            matrix2(j,1)=10000000;
            matrix2(j,2)=10000000;
            matrix2(j,3)=10000000;
            break;
        end
    end
end
matchm(p,g)=match;
unmatchm(p,g)=l1+l2-match*2;
    end
end


