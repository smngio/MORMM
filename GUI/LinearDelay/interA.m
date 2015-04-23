function out = interA(A,S)


v=max(size(S));
n=max(size(A));

out = [zeros(v,v), zeros(v,n);
       zeros(n,v),      A];
 