%Reads Covid rates 

y=readtable('owid-covid-dataDec.csv');
dt=datetime(table2array(unique(y(:,4))));
mdt=daysdif(min(dt), max(dt))+1; %data size according to date range
ccnt=table2array(unique(y(:,3))); %List Unique countries
ccnt(1)=[];
sz=size(ccnt);
datC=zeros(sz(1),mdt);
sz=size(y);
for i=1:sz(1) %for each data row
    
    tt=table2array(y(i,3)); %Get country name
    p=find(strcmp(ccnt,tt)); %Get country index in ccnt
    q=daysdif(min(dt), datetime(table2array(unique(y(i,4)))))+1; %find the number of day
    
    datC(p,q)= table2array(y(i,11)); %Store in matrix where row shows country and column shows day
end;
Region=ccnt;
CcntTab=array2table(Region); %Country table
datC(isnan(datC))=0;
datCTab=array2table(datC); %Get in matrix form
tabCov2=[CcntTab, datCTab]; %Get data in table form with country names
    