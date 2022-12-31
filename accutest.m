% if (sum(res==X)<sum(~res==X))
%     res=~res;
% end;

accuracy=sum(res==X)/n;
precision=sum(res.*X)/sum(res);
recall=sum(res.*X)/sum(X);

gscore=sqrt(precision*recall);
fscore=(2/(1/precision+1/recall));
posacc=sum(res.* X)/sum(X);
negacc=sum(~res.* ~X)/sum(~X);
wieghted_accuracy=(sum(res.* X)/sum(X)+sum(~res.* ~X)/sum(~X))/2;


revprecision=sum(~res.*~X)/sum(~res);
revrecall=sum(~res.*~X)/sum(~X);

revgscore=sqrt(revprecision*revrecall);