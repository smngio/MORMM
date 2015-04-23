function out = interp2V(A,B,C,S,L,PI,Q,R)

n = max(size(A));
v = max(size(S)); 

diff = setdiff(eig(A),eig(Q));

if(length(diff)~= n)
    
    error('Matrices Q and A have common eigenvalues');

end

diff = setdiff(eig(Q),eig(S));

if(length(diff)~= v)
    
    error('Matrices S and Q have common eigenvalues');

end

Left = kron(A',eye(v))-kron(eye(n),Q);
Right = reshape(-R*C,v*n,1);
Y = reshape(Left\Right,v,n);


Left = kron(S',eye(v))-kron(eye(v),Q);
Right = reshape(Y*B*L - R*C*PI,v*v,1);
P = reshape(Left\Right,v,v);

out = P\(Y*B);


