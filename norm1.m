% Data normalization reported as equation 7 in the manuscript 
%"RelDenClu: A Relative Density based Biclustering Method for identifying
%non-linear feature relations"

function [data]= norm1(d)

temp=size(d);
n=temp(1);
m=temp(2);
data=(d-repmat(min(d),n,1))./repmat(range(d), n,1);
