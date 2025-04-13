function [clubase, cludim]=pfRelDenBi(d)    
    [n,m]=size(d);
    d=(d-repmat(min(d),n,1))./repmat(range(d), n,1);

    [ixmat]=preproFast(d);
    temp1=sum(ixmat>0,1);
    histn=ceil(3*log(m*(m-1)/2)/log(2));
    [hyp, cthy]=hist(temp1(:),histn );
    ctt=(cthy(1:(histn-1))+cthy(2:histn))/2;
    hyp(1)=[];
    for k=1:(histn-1)
        if(hyp(k)>0 & hyp(k+1)>0) break;
        end;
    end;
    obsmin=ceil(ctt(k-1));
    [impbase, impdim]=bicRMfunc(ixmat,obsmin );
    
    szimp=size(impbase,1);
    if(isempty(impbase)||szimp<2)
        clubase=zeros(1,n);
        cludim=zeros(1,m);  
    else
    noclu=ceil(obsmin/size(impdim,1))+3;
    [clubase, cludim]=getbiclus(impbase, d, noclu);
    

    end;
    
if(sum(sum(clubase))==0)
        clubase=[];
        cludim=[];
end;    
