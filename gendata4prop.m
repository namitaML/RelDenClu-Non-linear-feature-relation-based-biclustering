%This file contains the MATLAB code for generating data for testing the
%properties of biclusters obtained by RelDenClu reported in the manuscript
%"RelDenClu: A Relative Density based Biclustering Method for identifying
%non-linear feature relations"


%Code for generating Non-Linear 1 -Table 1, Row 1
mkdir('./data/nonlinA');

for i =1:10


d=rand(1000, 20);
a=d(1:500, 1);
d(1:500, 2)=sin(a);
d(1:500, 3)=a.^2;
d(1:500, 4)=a.^10;
d(1:500, 5)=sin(a*pi);
d(1:500, 6)=sin(a*2*pi);
d(1:500, 7)=a.^3;
d(1:500, 8)=4*a.^2;
d(1:500, 9)=sin(a*4*pi);
d(1:500, 10)=4*a.^3;

fname=strcat('data/NonlinA/nonlinA',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;

%Code for generating Non-Linear 2 -Table 1, Row 2
mkdir('./data/NonlinB')
for i =1:10

x=rand(1000, 1);

d=rand(1000, 20);
a=x(1:500);

d(1:500, 2)=sin(a);
d(1:500, 3)=a.^2;
d(1:500, 4)=a.^10;
d(1:500, 5)=0.5*sin(a*pi);
d(1:500, 6)=0.5*sin(a*2*pi)+0.5;
d(1:500, 7)=a.^3;
d(1:500, 8)=a.^2;
d(1:500, 9)=0.5*sin(a*4*pi)+0.5;
d(1:500, 10)=a.^3;

fname=strcat('./data/NonlinB/nonlinB',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;

%Code for generating base data-Table 1, Row 3


mkdir('./data/basedata')
n=1000;
m=20;
u=500;
v=10;
for i =1:10
datagen2;
fname=strcat('./data/basedata/dbase',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;

%Code for generating scaled data-Table 1, Row 4
mkdir('./data/scaledata')
chdir('./data/scaledata');
n=1000;
m=20;
u=500;
v=10;

for i =1:10

fname=strcat('../basedata/dbase', num2str(i),'.txt');
d=load(fname);
d=d.*repmat(rand(1,m), n, 1);
fname=strcat('scale',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;
chdir('../..');


%Code for generating data after applying Translation-Table 1, Row 5
mkdir('./data/transdata')
chdir('./data/transdata');
n=1000;
m=20;
u=500;
v=10;

for i =1:10
fname=strcat('../basedata/dbase', num2str(i),'.txt');
d=load(fname);
d=d+repmat(rand(1,m), n, 1);
fname=strcat('trans',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;
chdir('../..');


%Code for generating data after appling linear transform -Table 1, Row 6
mkdir('./data/linearlocal')
chdir('./data/linearlocal');
n=1000;
m=20;
u=500;
v=10;

for i =1:10
fname=strcat('../basedata/dbase', num2str(i),'.txt');
d=load(fname);
d=d.*repmat(rand(1,m), n, 1)+repmat(rand(1,m), n, 1);
fname=strcat('linearlocal',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;
chdir('../..');



%Code for genearting point proportion data-Table 1, Row 9

mkdir('./data/pointplocal')
chdir('./data/pointplocal');


for i =1:10
fname=strcat('../basedata/dbase', num2str(i),'.txt');
d=load(fname);
d=[d(1:u,:);d(1:u,:);d(u+1:n,:);d(u+1:n,:);];
fname=strcat('pp',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;
chdir('../..');


%Code for genearting cluster proportion data-Table 1, Row 10

mkdir('./data/clup')
chdir('./data/clup');


for i =1:10
fname=strcat('../basedata/dbase', num2str(i),'.txt');
d=load(fname);
d=[d(1:u,:);d(1:u,:);d(u+1:n,:)];
fname=strcat('clup',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;
chdir('../..');


%Code for genearting noisy data-Table 1, Row 11

mkdir('./data/noisy10pc')
chdir('./data/noisy10pc');
n=1000;
m=20;
u=500;
v=10;

for i =1:10
fname=strcat('../basedata/dbase', num2str(i),'.txt');
d=load(fname);
d=d+0.1*rand(n,m);
fname=strcat('noisy10pc',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;
chdir('../..');


%Code for genearting random permutations of rows and columns data-Table 1, Row 12

mkdir('./data/randperms')
chdir('./data/randperms');
for i =1:10
fname=strcat('../basedata/dbase', num2str(i),'.txt');
d=load(fname);
nperms = randperm(n);
allNperms(i,:)=nperms;
mperms=randperm(m);
allMperms(i,:)=mperms;
d=d(nperms, mperms);
fname=strcat('randperms',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;
save('allNperms.txt','allNperms','-ascii')
save('allMperms.txt','allMperms','-ascii')
chdir('../..');


%Code for genearting normal data-Table 1, Row 13

mkdir('./data/gaus')
chdir('./data/gaus');
n=1000;
m=20;
u=500;
v=10;

for i =1:10
chdir('../..');
datagenG;
chdir('./data/gaus');

fname=strcat('./data/gaus/gaus',num2str(i),'.txt');
fname=strcat('gaus',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;
chdir('../..');


%Code for genearting noisy normal data- Table 1, Row 14

mkdir('./data/noisy10pcnorm')
chdir('./data/noisy10pcnorm');
n=1000;
m=20;
u=500;
v=10;

for i =1:10
fname=strcat('../gaus/gaus', num2str(i),'.txt');
d=load(fname);
d=d+0.1*randn(n,m);
fname=strcat('noisy10pcnorm',num2str(i),'.txt');
save(fname,'d', '-ascii')
end;
chdir('../..');



