% Data normalization reported as equation 8 in the manuscript 
%"RelDenClu: A Relative Density based Biclustering Method for identifying
%non-linear feature relations"
function [data]= norm2(d)

d=normalizeInfy2Unit(d);
data=norm1(d);
