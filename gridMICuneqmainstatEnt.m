function [summic]= gridMICuneqmainstatEnt(ds,pow)


[n,m]=size(ds);
rg=range(ds);
minDs=min(ds);
maxDs=max(ds);
% for i=1:n
%     dsNormalized(i,:)=(ds(i,:)-minDs+0.001*rg)./(rg*1.002);
% end;
% ds=dsNormalized;

[srtDs, DSIndex]=sort(ds);
dlen=diff(srtDs);
%avgEdgeWt=sum(dlen)/(n-1);
maxEdgeWt=max(dlen);
nds=max(3,floor(log10(n)));

divLen=zeros(2,m);
%maxEdgeWt
%n.^pow
divLen(1,:)=maxEdgeWt.*((n).^pow);
divLen(2,:)=rg./nds;
divLen(1,divLen(1,:)>=rg)=0.5*rg(1,divLen(1,:)>=rg); %latest midi mod

gridSz=zeros(2,m);
gridSz(1,:)=ceil((rg)./divLen(1,:));
gridSz(2,:)=ceil(rg./divLen(2,:));

gridAdr=zeros(n,m,2); %index 1 contains spacing dependent size, index 2 contains nearly log n divisions 

 
grid_er_factor=0.0001; % add a little displacement to make up for calculation error


for layer=1:2
     for i=1:m
         llim=minDs(i);
         ulim=maxDs(i);
         j=0;
         k=1;

         while(llim+(j+grid_er_factor)*divLen(layer,i)<ulim)
             while (srtDs(k,i)<=llim+(j+1+grid_er_factor)*divLen(layer,i))
                 gridAdr(DSIndex(k,i),i,layer)=j+1;
                 if (k<n)
                     k=k+1;
                 else
                     break;
                 end;

             end;

             j=j+1;

         end;
     end;
end; 

migrid=zeros(m);
 

for di=1:m
    for dj=di+1:m
        gAd1=[gridAdr(:,di,1),gridAdr(:,dj,2)];
        gAd2=[gridAdr(:,di,2),gridAdr(:,dj,1)];
        gSz1=[gridSz(1,di),gridSz(2,dj)];
        gSz2=[gridSz(2,di),gridSz(1,dj)];
        migrid(di,dj)=max(calcMI(gAd1,gSz1,n),calcMI(gAd2,gSz2,n));
    end;
end;
summic = migrid;
return;

function [mi]=calcMI(gAd,gSz,n)

if(all(isnan(gSz))) mi=1; return; end;
if(any(isnan(gSz))) mi=0; return; end;
cellCount=zeros(gSz);
 for i= 1:n
     cellCount(gAd(i,1),gAd(i,2))=cellCount(gAd(i,1),gAd(i,2))+1;
 end;
  
 colsum=sum(cellCount,1);
 rowsum=sum(cellCount,2);
 mitemp=zeros(gSz);     
 
 
         
for i=1:gSz(1)
    for j=1:gSz(2)
        if(cellCount(i,j)> 0) 
            
            mitemp(i,j)=(cellCount(i,j)/n)*log(n*cellCount(i,j)/(colsum(j)*rowsum(i)));
        end;
    end;
end;

Hx=0;
Hy=0;

for i=1:gSz(1)
    Hx=Hx+(rowsum(i)/n)*log(n/rowsum(i));
end;

for i=1:gSz(2)
    Hy=Hy+(colsum(i)/n)*log(n/colsum(i));
end;

if((min(Hx,Hy))>0)
    mi=sum(sum(mitemp))/min(Hx,Hy);
else
    mi=0;
end;

% 
% if ((min(gSz))>1)
%     mi=sum(sum(mitemp))/log(min(gSz));
% 
% else
%     mi=0;
% end;

return;
 
