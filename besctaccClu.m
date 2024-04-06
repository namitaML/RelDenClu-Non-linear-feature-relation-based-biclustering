maccuid=0;
ma=0;
clubase=logical(clubase);
s=size(clubase);
s=s(1);

for i=1:s
for j=0:1
if(j==1)    
    res=clubase(i,:)';
else
    res=~clubase(i,:)';
end

accutest
if(accuracy > ma) ma= accuracy; maccuid = i; state =j; end;
%if(recall > ma) ma= recall; maccuid = i; end;

%find(cludim(i,:))
end;
end;

ma
maccuid

if(state)
    res=clubase(maccuid,:)';
else
    res=~clubase(maccuid,:)';
end;
accutest

sum(clubase(maccuid,:))
%sum(cludim(maccuid,:))