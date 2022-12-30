% Code for Algorithm 2 (lines 4 to 7) presented in the manuscript 
%"RelDenClu: A Relative Density based Biclustering Method for identifying
%non-linear feature relations"
function [impbase, impdim]=bicRMfunc(ixmat, MIN_COMPTS)
%Input: ixmat represents dense regions found by preproFast i.e. Algorithm 1
        %MIN_COMPTS is minimum number of observations that can be used to find seed biclusters
        %and so also limits minimum size of final bicluster
        %MIN_COMPTS=10;       %15 used for yeast experiment; 3 for cancer, fertility magic and spect; 6 default; 10 ionosphere
%Output: %Each row of impbase represents set of observations 
         %in seed bicluster and impdim corresponding rows contains the
         %three associated features

temp=size(ixmat);
n=temp(1);
m=temp(2);
impbase=zeros(1,n);
%Upper bound of number of connected components for any feature apir
COLIDCLU=10.^ceil(log(n)/log(10));
impdim=[0,0,0];
for i=1:m
    
    for j=1:(i-1)
        for k=1:(j-1)          
            %For each set of three features we have three feature pairs
            %Find observations which form relation for all 3 pairs
            ixb1=ixmat(:, i,j)>0;
            ixb2=ixmat(:, i,k)>0;
            ixb3=ixmat(:, j,k)>0;
            isTriplet=ixb1 & ixb2 & ixb3;
            %If number of such observations is too small ignore and move to
            %next triplet
            if(sum(isTriplet>0)<MIN_COMPTS) continue; end;
            %Find observations which lie in same connected components in
            %all 3 pairs
            temp=isTriplet.*(ixmat(:, i,j)+COLIDCLU*ixmat(:, i,k)+(COLIDCLU.^2)*ixmat(:,j,k));
            tempUnq=unique(temp);
            for ucounter=1:length(tempUnq)
                if(tempUnq(ucounter)==0) continue; end;
                tempB=(temp==tempUnq(ucounter));
                Stemp=sum(tempB);

                if(Stemp>MIN_COMPTS) 
                    %Store observations lying in same connected components
                    %in all 3 pairs ass a seed set and also store
                    %corresponding features
                     impbase=[impbase;tempB'];
                     impdim=[impdim;i,j,k];
                
                end;
            end;

            end;
            
            
        end;
    end;
    
impdim(1,:)=[];
impbase(1,:)=[];

%Sort the observation sets in descending order by size
[temp,orderS]=sort(sum(impbase,2),'descend');
impdim=impdim(orderS,:);
impbase=impbase(orderS,:);

end


 
            