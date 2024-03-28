function [ixmat]=prepro(d)

    sz=size(d);
    n=sz(1);
    m=sz(2);
%     [dsorted, sidx]=sort(d);
%     seps=diff(dsorted);
%     sdifs=sort(seps, 'descend');
%     ksep=sdifs(1, :);
    rlen=repmat(log(10)/log(n),1,m);
    %rlen=sqrt(ksep);
    rlenby3=rlen/3;
    dred=ceil(d./repmat(rlenby3, n, 1));
    dred(dred==0)=1;
    gridsize=ceil(ones(1,m)./rlenby3);
    ixmat=zeros(n,m,m);
        for i = 2:m      
            
             for j = 1:(i-1)
                 
                %sprintf('dimensions %d %d ', i, j)
                %for each dimension pair form a grid 
                basecon=zeros(gridsize(i), gridsize(j), gridsize(i), gridsize(j));
                for r=1:gridsize(i)
                    for s=1:gridsize(j)
                        %Check whether an elements is dense enough
                        %Assume each grid element is connected to 8 elements surrounding it
                        
                        hcount=(dred(:,i)==r);
                        vcount=(dred(:,j)==s);
                        comcount=sum(hcount & vcount);
                        hcount=sum(hcount);
                        vcount=sum(vcount);
                        
                        if(comcount>max(max(hcount/gridsize(j), vcount/gridsize(i)), n/(gridsize(i)*gridsize(j))))
                            
                        
                            for t=(r-1):(r+1)
                                if (t<=0) continue; end;
                                if (t>gridsize(i)) continue; end;                                
                                for u=(s-1):(s+1)
                                    if(r==t && s==u)    continue; end;
                                    if (u<=0) continue; end;
                                    if (u>gridsize(j)) continue; end;     
                                    basecon(r,s,t,u)=1;


                                 end;
                            end;
                        end;
                    end;
                end;
                
            basecon = reshape(basecon, gridsize(i)*gridsize(j), gridsize(i)*gridsize(j));
            boolanchor=sum(basecon)>0;
            if(sum(boolanchor)>0)
            [S,C]=graphconncomp(sparse(basecon(boolanchor,boolanchor)));
             blen=size(basecon); blen= blen(1);
             gridgroup= max((repmat(C,blen,1).*basecon(:,boolanchor))');
                 
            %i,j
            %dred(:,i)+(gridsize(i))*(dred(:,j)-1)
             ixmat(:,i,j)=gridgroup(dred(:,i)+(gridsize(i))*(dred(:,j)-1));
            end;
             end;
        end;
    
    
end