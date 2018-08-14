clc;clear;
pg='C:\Users\Administrator\Desktop\GallerySet\';
pp = 'C:\Users\Administrator\Desktop\ProbeSet\';
probe = zeros(200,1250);
read = dir(strcat(pp,'*.pgm'));%
len = length(read);%获取图像总数量
if len > 0 %有满足条件的图像
        for j = 1:len %逐一读取图像
            n = read(j).name;% 图像名
            image =  imread(strcat(pp,n));
            image = image(1:25,:);
            probe(j,:) = reshape(double(image),1,1250);
            %图像处理过程 省略
        end
end

gallery = zeros(100,1250);
read = dir(strcat(pg,'*.pgm'));%
len = length(read);%获取图像总数量
if len > 0 %有满足条件的图像
        for j = 1:len %逐一读取图像
            n = read(j).name;% 图像名
            image =  imread(strcat(pg,n));
            image = image(1:25,:);
            gallery(j,:) = reshape(double(image),1,1250);
            %图像处理过程 省略
        end
end


av=sum(gallery,1)/100;
sub=zeros(100,1250);
for i=1:100
    sub(i,:)=gallery(i,:)-av;
end
A=sub'*sub;
[v,d]=eigs(A,99);
v(:,5)
norm(v(:,5))
w=zeros(99,100);
for i=1:100
    for j=1:99
        w(j,i)=v(:,j)'*sub(i,:)';
    end
end
A1=w(1,1)*v(:,1)+w(1,2)*v(:,2);
A1=int8(reshape(A1,25,50));
imshow(A1);
sub1=zeros(200,1250);
for i=1:200
    sub1(i,:)=probe(i,:)-av;
end 
w1=zeros(99,200);
for i=1:200
    for j=1:99
        w1(j,i)=v(:,j)'*sub1(i,:)';
    end
end

% A2=w1(1,1)*v(:,1)+w1(1,2)*v(:,2);
% A2=int8(reshape(A2,50,50));
% imshow(A2);

dis=zeros(200,100);
sum=0;
for i=1:200
    for k=1:100
    for j=1:99
        sum=sum+(w1(j,i)-w(j,k))^2;
    end
    dis(i,k)=sqrt(sum);
    sum=0;
    end
end


m1=dis;
[l,m]=size(m1);
i=1;
ms=[100:100:5300];
size(ms)
count1=zeros(1,53);
count2=zeros(1,53);
while(i<=l)
    j=1;
    while(j<=53)
        if ms(j)>m1(i,ceil(i/2))
            count1(1,j)=count1(1,j)+1;
            break;
        end
        j=j+1;
    end
    i=i+1;
end
i=1;
j=1;
while(i<=l)
    while(j<=m)
        k=1;
        while(k<=53)
            if ms(k)>m1(i,j)
                count2(1,k)=count2(1,k)+1;
                break;
            end
            k=k+1;
        end
        j=j+1;
    end
    i=i+1;
    j=1;
end
count2=count2-count1;
count1=count1/l;
count2=count2/(l*m-l);
figure;
plot(ms,count1);
hold on;
plot(ms,count2);
title('Genuine and impostor score distributions');
xlabel('Match Score');
ylabel('Probability');

m1=dis;
[l,m]=size(m1);
[a,b]=sort(m1,2);
accu=zeros(1,m);
for i=1:m
    for j=1:l
        for k=1:m
            if b(j,k)==ceil(j/2) 
                if k<=i
                    accu(1,i)=accu(1,i)+1;
                end
            end
        end
    end
end
accu=accu/l;
figure;
plot([1:1:m],accu);
title('Cumulative match characteristic curve');
xlabel('Rank(t)');
ylabel('Rank-t identification rate');
rank1accu=accu(1,1)

m1=dis;
[l,m]=size(m1);
gen=[];
for i=1:l
    gen=[gen,m1(i,ceil(i/2))];
end
imp=[m1(1,2:m)];
imp=[imp,m1(2,2:m)];
for i=3:l
    imp=[imp,m1(i,1:ceil(i/2)-1)];
    imp=[imp,m1(i,ceil(i/2)+1:m)];
end
d=sqrt(2)*abs(mean(gen)-mean(imp))/(sqrt(var(gen)+var(imp)))
% Plot the Receiver Operating Curve
t=[100:50:5300];
frr=zeros(1,105);
far=zeros(1,105);
for i=1:105
    for j=1:l
        if gen(j)>t(i)
            frr(1,i)=frr(1,i)+1;
        end
    end
    for j=1:19800
        if imp(j)<t(i)
            far(1,i)=far(1,i)+1;
        end
    end
end
far=far/19800;
frr=frr/l;
figure;
plot(far,frr);
title('Receiver Operating Curve');
xlabel('False Accept Rate');
ylabel('False Reject Rate');
diff=abs(far-frr);
[a,b]=sort(diff);
rank=b(1)
eer1=far(b(1))
eer2=frr(b(1))
far
frr




