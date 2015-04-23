function out = interB(A,B,S,L)


v=max(size(S));
n=max(size(A));

out = [zeros(v,v), zeros(v,n);
       B*L,zeros(n,n)];