%This code is used by gendata4prop to generate gaussian data for create
%biclusters
d=randn(n,m);
mp=rand(1,v-1);
d(1:u, 2:v)=repmat(mp, u, 1).*repmat(d(1:u, 1), 1, v-1);


