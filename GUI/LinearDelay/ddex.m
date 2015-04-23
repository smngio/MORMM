function dxdt = ddex(t,x,Z,obj,Acl,Bcl)

lenA = length(Acl);
lenB = length(Bcl);
mu = obj.mu;

xi = [x, Z(:,:)];
    
tmp = zeros(length(x),1);

for j=1:lenA

    tmp = tmp + Acl{j}*xi(:,j);
    
end

if(mu~=0)
    
    for j=1:(lenB)
        
        tmp = tmp + Bcl{j}*xi(:,j+lenA);
        
    end
    
end

dxdt = tmp;


end