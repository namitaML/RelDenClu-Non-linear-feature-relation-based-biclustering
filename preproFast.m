% Code for Algorithm 1 presented in the manuscript 
%"RelDenClu: A Relative Density based Biclustering Method for identifying
%non-linear feature relations"

%Input: Normalized data to be biclustered
%Output: Returns ixmat which is (n*m*m) matrix where n is number of observations and m
%number of features
%The elemnt ixmat(k,i,j) is the id of connected component to which
%observation k belongs for dimension pair j,k
function [ixmat]=preproFast(d)
    %Find data dimensions
    sz=size(d);
    n=sz(1);
    m=sz(2);
    
    %Find the length of bins for density estimation
    rlen=repmat(log(10)/log(n),1,m);
    rlenby3=rlen/3;
    dred=ceil(d./repmat(rlenby3, n, 1));
    dred(dred==0)=1;
    gridsize=ceil(ones(1,m)./rlenby3);
    
    %Check each observation if it lies in dense region for each feature pair 
    ixmat=zeros(n,m,m);
    for i = 2:m      

         for j = 1:(i-1)

            %for each dimension pair form a grid 
            basecon=zeros(gridsize(i), gridsize(j), gridsize(i), gridsize(j));
            for r=1:gridsize(i)
                for s=1:gridsize(j)
                    %Check whether an elements is dense enough
                    %Assume each grid element is connected to 8 elements surrounding it

                    hcount=(dred(:,i)==r); %Set 1 for observations in a horizontal strip
                    vcount=(dred(:,j)==s); %Set 1 for observations in a vertical strip
                    comcount=sum(hcount & vcount); %Set 1 for observations in a cell
                    hcount=sum(hcount); %Total number of observations in a horizontal strip
                    vcount=sum(vcount); %Total number of observations in a vertical strip
                    
                    %Compare cell count with horizontal and vertical strips
                    if(comcount>max(max(hcount/gridsize(j), vcount/gridsize(i)), n/(gridsize(i)*gridsize(j))))

                        %make a note that current cell is dense and is
                        %adjacent (horizontally vertically or diagonally) to  8 other cells 
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
            %Reshape connection matrix to show connection pairwise
            %connectedness between cells and find connected components
            basecon = reshape(basecon, gridsize(i)*gridsize(j), gridsize(i)*gridsize(j));
            boolanchor=sum(basecon)>0;
            if(sum(boolanchor)>0)
                [S,C]=graphconncomp(sparse(basecon(boolanchor,boolanchor)));
                 blen=size(basecon); blen= blen(1);
                 gridgroup= max((repmat(C,blen,1).*basecon(:,boolanchor))');
                 %For each observation note the connected component in
                 %which it falls for the given feature pair i,j
                 ixmat(:,i,j)=gridgroup(dred(:,i)+(gridsize(i))*(dred(:,j)-1));
            end;
         
        end;
    end;


end