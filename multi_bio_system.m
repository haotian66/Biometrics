hd=hd1;
pg='C:\Users\Administrator\Desktop\GallerySet\';
pp = 'C:\Users\Administrator\Desktop\ProbeSet\';
probe = zeros(100,1250);
n=1;
for i=1:100
            image =  imread(strcat(pp,'subject',num2str(i),'_img2.pgm'));
            image = image(26:50,:);
            probe(n,:) = reshape(double(image),1,1250);
            n=n+1;
end
gallery = zeros(100,1250);
n=1;
for i=1:100
            image =  imread(strcat(pg,'subject',num2str(i),'_img1.pgm'));
            image = image(26:50,:);
            gallery(n,:) = reshape(double(image),1,1250);
            n=n+1;
end


mu=0;
mo1=0;
mo2=0;
simi1=zeros(100,100);
for i=1:100
    for k=1:100
    for j=1:1250
        mu=mu+gallery(k,j)*probe(i,j);
        mo1=mo1+(probe(i,j))^2;
        mo2=mo2+(gallery(k,j))^2;
    end
    simi1(i,k)=mu/(sqrt(mo1)*sqrt(mo2));
    mu=0;
    mo1=0;
    mo2=0;
    end
end

simi2=hd;
mea1=0;
sq1=0;
for i=1:100
    for j=1:100
        mea1=mea1+simi1(i,j);
    end
end
mea1=mea1/10000;
for i=1:100
    for j=1:100
        sq1=sq1+(simi1(i,j)-mea1)^2;
    end
end
sq1=sqrt(sq1/10000);
for i=1:100

    for j=1:100
        simi1(i,j)=(simi1(i,j)-mea1)/sq1;
    end
end


mea2=0;
sq2=0;
for i=1:100
    for j=1:100
        mea2=mea2+simi2(i,j);
    end
end
mea2=mea2/10000;
for i=1:100
    for j=1:100
        sq2=sq2+(simi2(i,j)-mea2)^2;
    end
end
sq2=sqrt(sq2/10000);
for i=1:100
    for j=1:100
        simi2(i,j)=(simi2(i,j)-mea2)/sq2;
    end
end

simi=zeros(100,100);
for i=1:100
    for j=1:100
        simi(i,j)=min(simi1(i,j),(-simi2(i,j)));
    end
end


min(min(simi1))
max(max(simi1))
min(min(simi2))
max(max(simi2))  
        
        
        
        
        
m1=simi;
[l,m]=size(m1);
i=1;
ms=[-6:0.1:4];
count1=zeros(1,101);
count2=zeros(1,101);
while(i<=l)
    j=1;
    while(j<=101)
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
        while(k<=101)
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
legend('genuine','imposter');

% Plot the Cumulative Match Characteristic curve
m1=simi;
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
plot([1:1:m],accu);
title('Cumulative match characteristic curve');
xlabel('Rank(t)');
ylabel('Rank-t identification rate');
% Find the lowest rank at which the system achieves performance greater than 70%?
t=0;
for i=1:l
    if accu(1,i)>0.7
        t=i;
        break;
    end
end

% Calculate d-prime
m1=simi;
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
t=[-6:0.1:4];
frr=zeros(1,101);
far=zeros(1,101);
for i=1:101
    for j=1:100
        if gen(j)<t(i)
            frr(1,i)=frr(1,i)+1;
        end
    end
    for j=1:9900
        if imp(j)>t(i)
            far(1,i)=far(1,i)+1;
        end
    end
end
far=far/9900;
frr=frr/100;
figure;
plot(far,frr);
title('Receiver Operating Curve');
xlabel('False Accept Rate');
ylabel('False Reject Rate');
% Calculate the Equal Error Rate
diff=abs(far-frr);
[a,b]=sort(diff);
b(1)
far(b(1))
frr(b(1))