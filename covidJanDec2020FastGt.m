wd=readtable('wdiDat.csv');
covRateDec
%Keep Covid rates for dates 31-Jan-2020 and 31-Dec-2020
cv=tabCov2(:,[1,36,370]); 

%Join data from WDI and Covid rates
ct=innerjoin(wd, cv);

%Get country names
regionlist=ct(:,1);

%Rates on 31-dec-2020
ratedec20=table2array(ct(:,30));

%Drop 31-dec-2020 covid rates and coiuntry names from main table
ct(:,30)=[];
ct(:,1)=[];

tabsz2=size(ct, 2);

%wdi features 1-27 rest are cov
dat=table2array(ct);
datsz2=size(dat, 2);

%Rates on 31-jan-2020
r=dat(:,28);
%Countries above 90 percentile
X=r>quantile(r, 0.9);


d=dat;
temp=size(d)
n=temp(1)
m=temp(2);
d=(d-repmat(min(d),n,1))./repmat(range(d), n,1);
tic;

[clubase, cludim]=RelDenClu(d);

toc
cd=logical(cludim);
idic=readtable('indicator_dictionary.csv');
fl=ct.Properties.VariableNames;
fldot=strrep(fl(1:27), '_', '.')

besctacc
cd(:, 28:m)=false;
flt=fl(cd(maccuid,:));
flt1=strrep(flt, '_', '.')
fltrej=fl(~cd(maccuid,:))
resid=(ismember(idic.Indicator_Code, flt1));
idic(resid,:)

cspDecNR=corr(ratedec20, dat(:,1:27), 'type','Spearman');

cspDec=round(corr(ratedec20, dat(:,1:27), 'type','Spearman'), 2);
%cPearsonDec=corr(ratedec20, dat(:,1:27));
cspJan=round(corr(dat(:,28), dat(:,1:27), 'type','Spearman'), 2);
%cPearsonJan=corr(dat(:,28), dat(:,1:27));
%[sortedSp, idxSp]=sort(abs(cspDec), 'descend');

flstdtab=array2table(fldot');
flstdtab.Properties.VariableNames={'Indicator_Code'};
featSelB=cd(maccuid, 1:27);
a=cspDecNR(featSelB);
b=cspDecNR(~featSelB);
