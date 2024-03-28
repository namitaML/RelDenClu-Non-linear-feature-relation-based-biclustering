function [impbase, impdim]=bicRMfunc(ixmat, MIN_COMPTS)
temp=size(ixmat);
n=temp(1);
m=temp(2);
impbase=zeros(1,n);
COLIDCLU=10.^ceil(log(n)/log(10));
%MIN_COMPTS=10;       %15 used for yeast experiment; 3 for cancer, fertility magic and spect; 6 default; 10 ionosphere
impdim=[0,0,0];
for i=1:m
    
    for j=1:(i-1)
        for k=1:(j-1)          
            
            ixb1=ixmat(:, i,j)>0;
            ixb2=ixmat(:, i,k)>0;
            ixb3=ixmat(:, j,k)>0;
            isTriplet=ixb1 & ixb2 & ixb3;
            if(sum(isTriplet>0)<MIN_COMPTS) continue; end;
            temp=isTriplet.*(ixmat(:, i,j)+COLIDCLU*ixmat(:, i,k)+(COLIDCLU.^2)*ixmat(:,j,k));
            tempUnq=unique(temp);
            for ucounter=1:length(tempUnq)
                if(tempUnq(ucounter)==0) continue; end;
                tempB=(temp==tempUnq(ucounter));
                Stemp=sum(tempB);

                if(Stemp>MIN_COMPTS) 
                     impbase=[impbase;tempB'];
                     impdim=[impdim;i,j,k];
                
                end;
            end;

            end;
            
            
        end;
    end;
    
impdim(1,:)=[];
impbase(1,:)=[];

[temp,orderS]=sort(sum(impbase,2),'descend');
impdim=impdim(orderS,:);
impbase=impbase(orderS,:);

end


 
            