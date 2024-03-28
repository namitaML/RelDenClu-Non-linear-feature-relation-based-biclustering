%modify cov19 after download
%wd=readtable('wdiDat.csv');
%covRateDec
%Can read tabCov2 from tabcovSv.csv   tabCov2=readtable('tabcovSv.csv');
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
%Ccountries above 90 percentile
X=r>quantile(r, 0.9);


d=dat;
%d(:,1)=t(:,1)./t(:,27);
temp=size(d)
n=temp(1)
m=temp(2);
d=(d-repmat(min(d),n,1))./repmat(range(d), n,1);
tic;

[ixmat]=preproFast(d);
%[impbase, impdim]=bicRMfunc(ixmat,5000 );
temp1=sum(ixmat>0,1);
%histn=ceil(m*(m-1)/10);
histn=ceil(3*log(m*(m-1)/2)/log(2));

[hyp, cthy]=hist(temp1(:),histn );
ctt=(cthy(1:(histn-1))+cthy(2:histn))/2;
hyp(1)=[];
for k=1:(histn-1)
    if(hyp(k)>0 & hyp(k+1)>0) break;
    end;
end;
%hyp2sum=hyp(1:(histn-2))+hyp(2:(histn-1));
%temp=find(hyp2sum>1);
%temp=find(hyp>0);
obsmin=ceil(ctt(k-1));
%obsmin=ceil(ctt(temp(1)-1));
[impbase, impdim]=bicRMfunc(ixmat,obsmin );
noclu=ceil(obsmin/size(impdim,1))+3;
[clubase, cludim]=getbiclus(impbase, d, noclu);

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
coefs=array2table([cspJan', cspDec',  zeros(27,1), zeros(27,1),featSelB', abs(cspDec')]);
coefs.Properties.VariableNames={'PearsonDec', 'SpearmanDec', 'CBSC','ARBic','Reldenclu', 'sotredAbsSp'};
tabSel=innerjoin(idic, [flstdtab, coefs]);
finaltab=sortrows(tabSel, 8, 'descend');
finaltab=finaltab(:,[1,3,4,5, 6, 7]);
finaltab([4, 5, 7, 9, 14, 21, 24, 25],4)={1};
finaltab([5,7,8,10,18,25],5)={1};
finaltab=[array2table((1:27)'), finaltab];
%writetable(finaltab, 'resCov.csv', 'delimiter', ';')
