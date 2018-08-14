clc;
clear;
% Plot the genuine and impostor score distributions
m1=load('C:\Users\Administrator\Desktop\simMatrix1.txt');
[l,m]=size(m1);
i=1;
ms=[0.7:0.005:1.01];
count1=zeros(1,100);
count2=zeros(1,100);
while(i<=l)
    j=1;
    while(j<=100)
        if ms(j)>m1(i,i)
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
        while(k<=100)
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
title('Genuine and impostor score distributions of simMatrix2');
xlabel('Match Score');
ylabel('Probability');
clc;
clear;
m2=load('C:\Users\Administrator\Desktop\simMatrix2.txt');
[l,m]=size(m2);
i=1;
ms=[0:0.01:0.29];
count1=zeros(1,30);
count2=zeros(1,30);
while(i<=l)
    j=1;
    while(j<=30)
        if ms(j)>m2(i,i)
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
        while(k<=40)
            if ms(k)>m2(i,j)
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

% Plot the Cumulative Match Characteristic curve
m1=load('C:\Users\Administrator\Desktop\simMatrix1.txt');
[l,m]=size(m1);
[a,b]=sort(m1,2,'descend');
accu=zeros(1,l);
for i=1:l
    for j=1:l
        for k=1:m
            if b(j,k)==j
                if k<=i
                    accu(1,i)=accu(1,i)+1;
                end
            end
        end
    end
end
accu=accu/l;
figure;
plot([1:1:l],accu);
% Find the lowest rank at which the system achieves performance greater than 70%?
t=0;
for i=1:l
    if accu(1,i)>0.7
        t=i
        break;
    end
end

% Calculate d-prime
m1=load('C:\Users\Administrator\Desktop\simMatrix1.txt');
[l,m]=size(m1);
gen=[];
for i=1:l
    gen=[gen,m1(i,i)];
end
imp=[m1(1,2:m)];
for i=2:m
    imp=[imp,m1(i,1:i-1)];
    imp=[imp,m1(i,i+1:m)];
end
d=sqrt(2)*abs(mean(gen)-mean(imp))/(sqrt(var(gen)+var(imp)))
% Plot the Receiver Operating Curve
t=[0:0.01:0.99];
frr=zeros(1,100);
far=zeros(1,100);
for i=1:100
    for j=1:466
        if gen(j)<t(i)
            frr(1,i)=frr(1,i)+1;
        end
    end
    for j=1:216690
        if imp(j)>t(i)
            far(1,i)=far(1,i)+1;
        end
    end
end
far=far/216690;
frr=frr/466;
figure;
plot(frr,far);
title('Receiver Operating Curve of of simMatrix2');
xlabel('False Accept Rate');
ylabel('False Reject Rate');
% Calculate the Equal Error Rate
diff=abs(far-frr);
[a,b]=sort(diff);
b(1)
far(b(1))
frr(b(1))

% Calculate FRR according to FAR
far=[0.01,0.05,0.1,0.2];
frr=zeros(1,4);
t1=zeros(1,4);
[a,b]=sort(imp,'descend');
for i=1:4
    for j=1:466
        if gen(j)<imp(b(floor(216690*far(1,i))))
            frr(1,i)=frr(1,i)+1;
        end
    end
end
frr=frr/466
