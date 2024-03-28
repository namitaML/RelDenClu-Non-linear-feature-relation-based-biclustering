function [clubase, cludim]=RelDenClu(d)    
    [n,m]=size(d);
    d=(d-repmat(min(d),n,1))./repmat(range(d), n,1);

    [ixmat]=preproFast(d);
    temp1=sum(ixmat>0,1);
    histn=ceil(3*log(m*(m-1)/2)/log(2));
    histedges=0:n/histn:n;
    hyp=histcounts(temp1(:),histedges );
    hyp(1)=[];
    for k=1:(histn-2)
        if(hyp(k)>0 & hyp(k+1)>0) break;
        end;
    end;

    obsmin=ceil(histedges(k));
    obsmin=min(obsmin, floor(n/2));
    [impbase, impdim]=bicRMfunc(ixmat,obsmin );
    
    szimp=size(impbase,1);
    if(isempty(impbase)||szimp<2)
        clubase=zeros(1,n);
        cludim=zeros(1,m);  
    else
    noclu=ceil(obsmin/size(impdim,1))+3;
    [clubase, cludim]=getbiclus(impbase, d, noclu);
    
%     sunC=sum(clubase,2);
%     [temp, cluIds]=sort(sunC, 'descend');
%     clubase=clubase(cluIds, :);
%     cludim=cludim(cluIds,:);
    end;
    
if(sum(sum(clubase))==0)
        clubase=[];
        cludim=[];
end;    
