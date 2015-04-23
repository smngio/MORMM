function out = interSysDel(A,B,S,L)


v=max(size(S));
n=max(size(A));

out = [S, zeros(v,n);
      B*L, A];