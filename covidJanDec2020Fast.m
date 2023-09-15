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
%Ccountries above 90 percentile
X=r>quantile(r, 0.9);

%Apply RelDenClu
d=dat;
%d(:,1)=t(:,1)./t(:,27);
temp=size(d);
n=temp(1);
m=temp(2);
d=norm1(d);

[clubase, cludim]=RelDenClu(d);
cd=logical(cludim);

%Load WDI column names
idic=readtable('indicator_dictionary.csv');
fl=ct.Properties.VariableNames;

%Find best bicluster
besctaccCov

%Get WDI features selected in best bicluster
cd(:, 28:m)=false;
flt=fl(cd(maccuid,:));
flt1=strrep(flt, '_', '.');
resid=(ismember(idic.Indicator_Code, flt1));


%Get WDI features rejected from best bicluster
boolFltRej=~cd(maccuid,:);
boolFltRej(:, 28:m)=false;
fltrej=fl(boolFltRej);
fltrej=strrep(fltrej, '_', '.');
residRj=(ismember(idic.Indicator_Code, fltrej));

%Calculate Pearson and Spearman correlations
SpDecAc=corr(ratedec20, dat(:,(cd(maccuid,:))), 'type','Spearman');
SpDecRej=corr(ratedec20, dat(:,boolFltRej), 'type','Spearman');

SpJanAc=corr(dat(:,28), dat(:,(cd(maccuid,:))), 'type','Spearman');
SpJanRej=corr(dat(:,28), dat(:,boolFltRej), 'type','Spearman');

PrDecAc=corr(ratedec20, dat(:,(cd(maccuid,:))));
PrDecRej=corr(ratedec20, dat(:,boolFltRej));

PrJanAc=corr(dat(:,28), dat(:,(cd(maccuid,:))));
PrJanRej=corr(dat(:,28), dat(:,boolFltRej));

corRj=array2table([PrJanRej', PrDecRej', SpJanRej', SpDecRej' ]);
corRj.Properties.VariableNames={'Rho_Jan_Rejected', 'Rho_Dec_Rejected', 'RhoSp_Jan_Rejected', 'RhoSp_Dec_Rejected'};

corAc=array2table([PrJanAc', PrDecAc', SpJanAc', SpDecAc' ]);
corAc.Properties.VariableNames={'Rho_Jan_Selected', 'Rho_Dec_Selected', 'RhoSp_Jan_Selected', 'RhoSp_Dec_Selected'};

%Print tables
Table_rejected=[idic(residRj,:), corRj]
Table_selected=[idic(resid,:), corAc]
