function out = minH2norm(A,B,C,D,S,L,PI)

if(D~=0)
    
    error('Matrix D must be zero');
    
end

sys = ss(A,B,C,0);

if(isstable(sys)==0)
    
    error('System to be redeced must be stable');
    
end

H=C*PI;
v = max(size(S));
n = max(size(A));
cont = 1;
mef = 3000;
if(n>200 || v>7)
    
    % Construct a questdlg with three options
    choice = questdlg('The optimisation process could take a while. Continue?', ...
        'Warning', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            cont = 1;
            simp = 1;
        case 'No'
            cont = 0;
        otherwise
            cont = 0;
    end
    
end

if(cont)
d = sym('d',[v,1]);
assume(d,'real')
% t=waitbar(0,'Processing...');
%
% for k=1:w
%
%     s=1i*omega(k);
%     W(k)=(C/(s*eye(n)-A))*B;
%     Wr(k)=(H/(s*eye(v)-(S-d*L)))*d;
%     Wer(k)=W(k)-Wr(k);
%     waitbar(k/w,t);
%
% end
%
% close(t);
%
% tmp = sum(Wer);
% f = norm(tmp,2);
% fh = matlabFunction(f,'vars',{d});

X0 = feasibleX0(v);

Fc = S - d*L;

%     RT = routh(charpoly(Fc),v);
%
%     for i=1:v+1
%
%         c(i) = -RT(i,1);
%
%     end

chpol = fliplr(charpoly(Fc));
FH = hurwitz(chpol,v);

for i=1:v
    
    c(i)=(-det(FH(1:i,1:i)));
    
end

if(n>400 || v>11)
    
     c = c(1:2:length(c));
     %xodd=~xeven;
     mef = 3000;
end


constraint = matlabFunction(c,[],'vars',{d});

options = optimoptions('fmincon','Algorithm','interior-point','MaxFunEvals',mef,'TolFun',1e-6,'Display','final');

out = minRes(A,B,C,D,S,H,L,X0,constraint,options);

else
    
    out = [];
    
end

    function out = feasibleX0(v)
        
        out=cell(1,v);
        eigen = eig(A);
        [~,ind1] = sort(abs(imag(eigen)),'descend');
        [~,ind2] = sort(abs(real(eigen)),'ascend');
        ind3 = randperm(length(eigen),v);
        
        for j=1:v
            
            R = 1;
            Q = eye(v);
            
            if(j==1)
                
                eig_des = eigen(ind1(1:v));
                
                try
                    
                    out{j} = place(S',L',eig_des)';
                    
                catch
                    
                    out{j} = lqr(S',L',Q,R)';
                    
                end
                
            elseif(j==2)
                
                eig_des = eigen(ind2(1:v));
                
                try
                    
                    out{j} = place(S',L',eig_des)';
                    
                catch
                    
                    out{j} = lqr(S',L',Q,R)';
                    
                end
                
                           
            elseif(j==3)
                      
                eig_des = eigen(ind3);
                
                try
                    
                    out{j} = place(S',L',eig_des)';
                    
                catch
                    
                    out{j} = lqr(S',L',Q,R)';
                    
                end
                
                
            else
                
                out{j} = lqr((S + rand*j*eye(v))',L',Q,R)';
                
            end
            
        end
        
    end

end