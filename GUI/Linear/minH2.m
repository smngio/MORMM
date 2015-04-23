function out = H2test(A,B,C,S,L,PI,Q,R)
% Input: (A,B,C) system matrices, (S,L) signal generator matrices,
%        (PI) solution of sylvester equation, (Q,R) initial interpolation
%         point
% 
% Output: (out) delta


n = max(size(A));
v = max(size(S)); 

diff = setdiff(eig(A),eig(Q));

if(length(diff)~= n)
    
    error('Matrices Q and A have common eigenvalues');

end

diff = setdiff(eig(S),eig(Q));

if(length(diff)~= v)
    
    error('Matrices S and Q have common eigenvalues');

end

eigen1 = eig(Q);
eigen2 = zeros(v,1);
diff = abs(eigen1)-abs(eigen2);
W = lyap(A,B*B');
W1 = lyap(A',C'*C);

j=0;
while(max(diff)>0.00001)
    
    j=j+1;
    Left = kron(A',eye(v))-kron(eye(n),Q);
    Right = reshape(-R*C,v*n,1);
    Y = reshape(Left\Right,v,n);
    
    Left = kron(S',eye(v))-kron(eye(v),Q);
    Right = reshape(Y*B*L - R*C*PI,v*v,1);
    P = reshape(Left\Right,v,v);

    Z = (Y*PI)\Y*B;
    m(:,j) = Z;
    tmp = -(S - Z*L);
    
    eigen2 = eig(tmp);
    
    Q = zeros(length(eigen2));
    
    for i=1:length(eigen2)
        
        Q(i,i) = eigen2(i);
        
    end
    
    diff = abs(sort(abs(eigen1))-sort(abs(eigen2)));
    
    eigen1 = eigen2;
    
end

diff = setdiff(eig(A),eig(Q));

if(length(diff)~= n)
    
    error('Matrices Q and A have common eigenvalues');

end

diff = setdiff(eig(Q),eig(S));

if(length(diff)~= v)
    
    error('Matrices S and Q have common eigenvalues');

end

out = m;
