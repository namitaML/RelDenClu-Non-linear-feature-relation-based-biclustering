%A function to calculate MIDI to find non linear dependence 
%between variables
%Reference: Namita Jain, C. A. Murthy:
%A new estimate of mutual information based measure of dependence 
%between two variables: properties and fast implementation. 
%Int. J. Mach. Learn. Cybern. 7(5): 857-875 (2016)

function [summic]= gridMICuneqmainstatEnt(ds,pow)
%Input: ds is the data matrix (can contain more than 2 features)
%       pow is a parameter used to decide the bin length for histgram
%       estimate the value should be close to 0, preferably less than 0.1 
%Output: Upper triangular matrix showing dependencies 
%        between each pair of features

[n,m]=size(ds);
rg=range(ds);
minDs=min(ds);
maxDs=max(ds);

%Sort the data along each dimension and find the maximum distance between
%consecutive points to obtain maximal seperation
[srtDs, DSIndex]=sort(ds);
dlen=diff(srtDs);
maxEdgeWt=max(dlen);
nds=max(3,floor(log10(n)));

%Along each dimension take the bin length as maximal seperation raised to
%parameter pow (this leads to consistent density estimates

divLen=zeros(2,m);
divLen(1,:)=maxEdgeWt.*((n).^pow);

%Also according to a second scheme along a dimenion take number of bins to be log(n), where n is number
%of observations
divLen(2,:)=rg./nds;

gridSz=zeros(2,m);
gridSz(1,:)=ceil((rg)./divLen(1,:));
gridSz(2,:)=ceil(rg./divLen(2,:));

%Store bin address for each observations according to each scheme
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
 
%For each feature pair find normalized MI by calling calcMI, 
%with bin address using scheme 1 for first feature and scheme 2 for second
%feature and then vice versa
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


%Bin address and number of bins along 2 dimensions along with toal number of observations are taken as input
%Returns normalized mutual information MI/min(Entropy)
function [mi]=calcMI(gAd,gSz,n)

cellCount=zeros(gSz);
 for i= 1:n
     cellCount(gAd(i,1),gAd(i,2))=cellCount(gAd(i,1),gAd(i,2))+1;
 end;
  
 colsum=sum(cellCount,1);
 rowsum=sum(cellCount,2);
 mitemp=zeros(gSz);     
 
 
%Calculate the value of p(x,y) log(p(x)p(y)/p(x,y)) for each cell        
for i=1:gSz(1)
    for j=1:gSz(2)
        if(cellCount(i,j)> 0) 
            
            mitemp(i,j)=(cellCount(i,j)/n)*log(n*cellCount(i,j)/(colsum(j)*rowsum(i)));
        end;
    end;
end;

Hx=0;
Hy=0;

%Calculate entropies 
for i=1:gSz(1)
    Hx=Hx+(rowsum(i)/n)*log(n/rowsum(i));
end;

for i=1:gSz(2)
    Hy=Hy+(colsum(i)/n)*log(n/colsum(i));
end;

%Calculate MI by summing over p(x,y) log(p(x)p(y)/p(x,y)) and then
%normalizing
if((min(Hx,Hy))>0)
    mi=sum(sum(mitemp))/min(Hx,Hy);
else
    mi=0;
end;

return;
 