function [out1,out2] = buildInterSystem(obj,S,L)


lenA = length(obj.Aj);
lenB = length(obj.Bj);

Acl = {};
Bcl = {};

for j=1:lenA
    
    if(j==1)
        
        if(obj.tau_u(j)==0)
            
            Acl{j} = interSysDel(obj.Aj{j},obj.Bj{j},S,L);
            
        else
            
            Acl{j} = interSysDel(obj.Aj{j},zeros(length(obj.Bj{1}),1),S,L);
            
        end
        
    else
        
        Acl{j} = interA(obj.Aj{j},S);
        
    end
    
end

for j=1:lenB
     
    if(obj.tau_u(j)~=0)
        
        Bcl{j} = interB(obj.Aj{1},obj.Bj{j},S,L);
        
    end
    
end

ind = ~cellfun('isempty',Bcl);

Bcl = Bcl(ind);

out1=Acl;
out2=Bcl;


end