function [clubase, cludim]=getbiclus(impbase,d, noclu)
m=size(d);
m=m(2);

Y=clusterdata(impbase, 'linkage', 'single', 'distance', 'cosine', 'maxclust',noclu);
clubase=[];
cludim=[];
implen=size(impbase);
implen=implen(1);
for i=1:noclu
    if(sum(Y==i)>implen/noclu)
        seedClu=sum(impbase(Y==i,:),1)>sum(Y==i)/noclu;%implen/noclu;
        clubase=[clubase;seedClu];
        pd=[];
        dSet=d(seedClu,:);
        simmat=gridMICuneqmainstatEnt(dSet,0.1);
        for j=1:m
            pd=[pd,simmat(j,j+1:m)];
        end;
        divm=floor(m/2); %default m/2 covid m/3
        ftcls=cluster(linkage(1-pd, 'single'), 'maxclust',divm)';
        cluftn=0;
        ftsetid=0;
        for j=1:divm
            if (sum(ftcls==j)>cluftn)
                cluftn=sum(ftcls==j);
                ftsetid=j;
            end;
        end;
        cludim=[cludim; ftcls==ftsetid];
            
    end;
       
end;
%clubase=logical(clubase);
end