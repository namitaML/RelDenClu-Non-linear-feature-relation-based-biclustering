
%%%%%%%%%%%%credi card fraud data
t=csvread('ccdef.csv');
d=t;
temp=size(d);
n=temp(1);
m=temp(2);
X=d(:,m);
d(:,m)=[];
t(:,m)=[];
m=m-1;
d=norm1(d);

[clubase, cludim]=RelDenClu(d,5000, floor(m/2));

%Classify with Naive BAyes and perform 10-fold cross validation for
%original and augemnted dataset
a1=zeros(10,1); 
a2=zeros(10,1);
b=clubase';
for j = 1:10

i=crossvalind('Kfold', X, 10);
test=(i==1);
train=~test;
m1=fitcnb(t(train,:), X(train,:));
a1(j)=sum(predict(m1, t(test,:))==X(test,:))/sum(test);

%Augmented feature values in t2
t2=[t,b];
m2=fitcnb(t2(train,:), X(train,:));
a2(j)=sum(predict(m2, t2(test,:))==X(test,:))/sum(test);

end;
%Calculate accuracy and standard deviation
Originl_accuracy=sum(a1)/10
Original_Acc_std_dev=std(a1)
Augmented_accuracy=sum(a2)/10
Augmented_Acc_std_dev=std(a2)
