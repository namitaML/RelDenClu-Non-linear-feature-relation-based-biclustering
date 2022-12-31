%Find bicluster with best accuracy, when X contains the expected class
%label (0,1)
maccuid=0;
ma=0;
s=size(clubase);
s=s(1);
perfMat=zeros(s, 6);
for i=1:s
res=clubase(i,:)';
%find accuracy for a particular bicluster
accutest
if(wieghted_accuracy > ma) ma= wieghted_accuracy; maccuid = i; end;
%if(recall > ma) ma= recall; maccuid = i; end;
perfMat(i,1)=accuracy;
perfMat(i,2)=wieghted_accuracy;
perfMat(i,3)=gscore;
perfMat(i,4)=revgscore;
perfMat(i,5)=posacc;
perfMat(i,6)=negacc;

find(cludim(i,:));
end;
% ma
% maccuid
% 
% res=clubase(maccuid,:)';
% accutest
% 
% sum(clubase(maccuid,:))
% sum(cludim(maccuid,:))