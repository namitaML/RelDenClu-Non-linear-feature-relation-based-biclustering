% Code for Algorithm 2 (lines 8 to 14) presented in the manuscript 
%"RelDenClu: A Relative Density based Biclustering Method for identifying
%non-linear feature relations"
function [clubase, cludim]=getbiclus(impbase,d,maxbiclust)
%Input: impbase is the output from previous step 
        %given by function bicRMfunc, the data matrix d and
        %maxclust which controls the maximum number of feature biclusters 
        %found for particular seed observation set 
        %DEFULT is M/2 , where M is number of features
        
m=size(d);
m=m(2);
noclu=5; %default 5

%Perform single linkage of observations set using cosine distance to merge
%similar sets, maximum sets is set to 5
Y=clusterdata(impbase, 'linkage', 'single', 'distance', 'cosine', 'maxclust',noclu);
clubase=[];
cludim=[];
implen=size(impbase);
implen=implen(1);
for i=1:noclu
    %check if the observation set is large enough
    if(sum(Y==i)>implen/noclu)
        seedClu=sum(impbase(Y==i,:))>implen/noclu;
        clubase=[clubase;seedClu];
        pd=[];
        %For selected set of observation find the dependence between
        %features using MIDI
        dSet=d(seedClu,:);
        simmat=gridMICuneqmainstatEnt(dSet,0.001);
        for j=1:m
            pd=[pd,simmat(j,j+1:m)];
        end;
        %Perform single linkage clustering of features 
        %using distance 1-MIDI
        ftcls=cluster(linkage(1-pd, 'single'), 'maxclust',maxbiclust)';
        cluftn=0;
        ftsetid=0;
        for j=1:maxbiclust % default :floor(m/2); covid: floor( m/3)
            if (sum(ftcls==j)>cluftn)
                cluftn=sum(ftcls==j);
                ftsetid=j;
            end;
        end;
        %Choose the largest feature cluster
        cludim=[cludim; ftcls==ftsetid];
            
    end;
       
end;
end