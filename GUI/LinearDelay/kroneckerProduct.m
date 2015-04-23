function out = kroneckerProduct(obj,del,S,L)

v=max(size(S));
n=max(size(obj.Aj{1}));
lenA = length(obj.Aj);
lenB = length(obj.Bj);

Left = -kron(S',eye(n));
Right = zeros(n,v);

for j=1:lenA
    
    Left = Left + kron(expm(-S'*del(j)),obj.Aj{j});
    
end

for j=1:lenB
       
    Right = Right - obj.Bj{j}*L*expm(-S*del(j+lenA));
    
end

Right = reshape(Right,n*v,1);
PI=reshape(Left\Right,n,v);

out = PI;