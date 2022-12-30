function [clubase, cludim]=RelDenClu(d, ObsInMinBase, maxSingleLinkageFeat)
d=norm1(d);
[ixmat]=preproFast(d);
[impbase, impdim]=bicRMfunc(ixmat, ObsInMinBase );
[clubase, cludim]=getbiclus(impbase,d, maxSingleLinkageFeat);