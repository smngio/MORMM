function [out1,out2] = buildRedMod(sys, sig_gen, spec)

A = sys.a;
B = sys.b;
C = sys.c;
D = sys.d;
S = sig_gen.a;
L = sig_gen.c;

n = max(size(A));
v = max(size(S)); 

if(v>=n)
    
    error('The dimension of S must be strictly less than dimension of A');
    
end
diff = setdiff(eig(A),eig(S));

if(length(diff)~= n)
    
    error('Matrices S and A have common eigenvalues');

end

%PI = sylvester(A,-S,-B*L);

Left= kron(eye(v),A)-kron(S',eye(n));
Right=reshape(-B*L,n*v,1);
PI=reshape(Left\Right,n,v);

switch(spec)
    
    case 1
        
        eigen = eig(A);
        
        [~,ind] = sort(abs(real(eigen)),'ascend');
        
        eig_des = eigen(ind(1:v));
        
        delta = place(S',L',eig_des)';
        
    case 2
        
        check = true;
        cancel = true;
        
        while (check)
            
            prompt = {sprintf('Enter a [1 x %d] vector containing distinct eigenvalues:',v)};
            dlg_title = 'Input';
            num_lines = 1;
            default = -(1:1:v);
            def = {num2str(default)};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            
            if(~isempty(answer))
                
                des_eig = str2num(answer{1});
                
                if(~isequal(size(des_eig),[1,v]))
                    
                    errordlg('The size of the desired eigenvalues is not correct','Error des_eig');
                    waitforbuttonpress();
                    
                else
                    
                    check = false;
                    cancel = false;
                    
                end
                
            else
                check = false;
            end
        end
        
        if(cancel)
            out1=[];
            out2=[];
            return
        else
            delta = prescribedEig(S,L,des_eig);
        end
        
    case 3
        
        check = true;
        cancel = true;
        
        while (check)
            
            prompt = {sprintf('Enter a [1 x %d] vector containing desired zeros:',v-1)};
            dlg_title = 'Input';
            num_lines = 1;
            default = -(1:1:(v-1));
            def = {num2str(default)};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            
            if(~isempty(answer))
                
                des_zer = str2num(answer{1});
                
                if(~isequal(size(des_zer),[1,v-1]))
                    
                    errordlg('The size of the desired zeros is not correct','Error des_zer')
                    waitforbuttonpress();
                    
                else
                    
                    check = false;
                    cancel = false;
                    
                end
                
            else
                check = false;
            end
            
        end
        
        if(cancel)
            
            out1=[];
            out2=[];
            return
            
        else
            delta = prescribedZeros(S,C,PI,des_zer);
        end
        
    case 4
        
        delta = passivityConstraint(S,L,C,PI);
        
    case 5
        
        check = true;
        cancel = true;
        
        while (check)
            
            prompt = {'Enter the desired L2 gain:'};
            dlg_title = 'Input';
            num_lines = 1;
            def = {'100'};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            
            if(~isempty(answer))
                
                gain = str2num(answer{1});
                
                if(gain<=0)
                    
                    errordlg('Enter a L2 gain > 0','Error L2 gain')
                    waitforbuttonpress();
                    
                else
                    
                    check = false;
                    cancel = false;
                    
                end
                
            else
                check = false;
            end
            
        end
        
        if(cancel)
            
            out1=[];
            out2=[];
            return
            
        else
            delta = gainL2(S,L,C,PI,gain);
        end
        
    case 6
        
        delta = minH2norm(A,B,C,D,S,L,PI);
        if(isempty(delta))
            out1=[];
            out2=[];
            return
        end
        
    case 7
        
        check = true;
        cancel = true;
        
        while (check)
            
            prompt = {sprintf('Enter a [%d x %d] Q matrix containing further moments:',v,v),...
                sprintf('Enter a [%d x 1] R vector such that (Q,R) is controllable:',v)};
            dlg_title = 'Input';
            num_lines = v;
            %default = -(1:1:(v-1));
            tmp=[];
            for k=1:floor(v/2)
                
                W=[0 k*1;-k*1 0];
                tmp = blkdiag(tmp,W);
                
            end

            
            def_Q = tmp;
            def_R = L';
            def = {num2str(def_Q),num2str(def_R)};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            
            if(~isempty(answer))
                
                try
                    
                    Q = evalin('base',answer{1});
                    
                    R = evalin('base',answer{2});
                    
                catch
                
                    Q = str2num(answer{1});
                
                    R = str2num(answer{2});
                    
                end
                
                if(~isequal(size(Q),[v,v]))
                    
                    errordlg('The size of Q is not correct','Error Q')
                    waitforbuttonpress();
                    
                elseif(~isequal(size(R),[v,1]))
                    
                    errordlg('The size of R is not correct','Error R')
                    waitforbuttonpress();
                    
                else
                    
                    check = false;
                    cancel = false;
                    
                end
                
            else
                check = false;
            end
            
        end
        
        if(cancel)
            
            out1=[];
            out2=[];
            return
            
        else
            delta = interp2V(A,B,C,S,L,PI,Q,R);
        end
        
    otherwise
        
        eigen = eig(A);
        
        [~,ind] = sort(abs(real(eigen)));
        
        eig_des = eigen(ind(1:v));
        
        delta = place(S',L',eig_des)';
        
        
end



F = S - delta*L;

G = delta;

H = C*PI;

out1 = ss(F,G,H,0);

out2=v;


end