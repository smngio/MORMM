function [out1,out2] = buildRedModDel(vars,Sa,La,spec)

A0 = vars.A0;
A1 = vars.A1;
B1 = vars.B1;
C0 = vars.C0;
C1 = vars.C1;
tau_j = vars.tau_j;
tau_u = vars.tau_u;

n = max(size(A0));
v = max(size(Sa));

if(v>=n)
    
    error('The dimension of Sa must be strictly less than dimension of A0');
    
end

diff = setdiff(eig(Sa),eig(A0 + A1*exp(-tau_j(2))));

if(length(diff)~= v)
    
    error('Matrices Sa and A0 + A1*exp(-tau_j(2)) have common eigenvalues');
    
end


vars.delay_0 = getXLag(vars.sys,0);

PIa = kroneckerProduct(vars.sys,vars.delay_0,Sa,La);

switch(spec)
    
    case -1
        
        check = true;
        cancel = true;
        
        while (check)
            
            if(tau_u(2)~=0)
                
                prompt = {sprintf('Enter a [%d x %d] F1 matrix:',v,v),...
                    sprintf('Enter a [1 x %d] H1 vector:',v),...
                    sprintf('Enter a [1 x %d] vector containing desired F0 eigenvalues:',v),...
                    sprintf('Enter a [%d x 1] G3 vector:',v)};
                dlg_title = 'Input';
                num_lines = v;
                def_Q = A1(1:v,1:v);
                def_R = B1(1:v,1);
                def_H = C1(1,1:v);
                def_eig = 10*(-1:-1:-v);
                def = {num2str(def_Q),num2str(def_H),num2str(def_eig),num2str(def_R)};
                answer = inputdlg(prompt,dlg_title,num_lines,def);
                
            else
                
                prompt = {sprintf('Enter a [%d x %d] F1 matrix:',v,v),...
                    sprintf('Enter a [1 x %d] H1 vector:',v),...
                    sprintf('Enter a [1 x %d] vector containing desired F0 eigenvalues:',v)};
                dlg_title = 'Input';
                num_lines = v;
                def_Q = A1(1:v,1:v);
                def_H = C1(1,1:v);
                def_eig = -10*(1:1:v);
                def = {num2str(def_Q),num2str(def_H),num2str(def_eig)};
                answer = inputdlg(prompt,dlg_title,num_lines,def);
                
            end
            
            if(~isempty(answer))
                
                try
                    
                    Q = evalin('base',answer{1});
                    
                catch
                    
                    Q = str2num(answer{1});
                    
                end
                
                try
                    
                    if(tau_u(2)~=0)
                        R = evalin('base',answer{4});
                    else
                        R = zeros(v,1);
                    end
                    
                catch
                    
                    if(tau_u(2)~=0)
                        R = str2num(answer{4});
                    else
                        R = zeros(v,1);
                    end
                    
                end
                
                try
                    
                    H = evalin('base',answer{2});
                    
                    
                catch
                    
                    H = str2num(answer{2});
                    
                    
                end
                try
                    
                    eig_des = evalin('base',answer{3});
                    
                catch
                    
                    eig_des = str2num(answer{3});
                end
                
                if(~isequal(size(Q),[v,v]))
                    
                    errordlg('The size of F1 is not correct','Error F1')
                    waitforbuttonpress();
                    
                elseif(~isequal(size(R),[v,1]))
                    
                    errordlg('The size of G3 is not correct','Error G3')
                    waitforbuttonpress();
                    
                elseif(~isequal(size(eig_des),[1,v]))
                    
                    errordlg('The size of eig_des is not correct','Error eig_des')
                    waitforbuttonpress();
                    
                elseif(~isequal(size(H),[1,v]))
                    
                    errordlg('The size of H1 is not correct','Error H1')
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
            red_mod = freePar(Sa,La,Q,H,R,tau_j,tau_u,eig_des,C0,C1,PIa);
        end
        
        
    case -2
        
        check = true;
        cancel = true;
        
        while (check)
            
            if(tau_u(2)~=0)
                
                prompt = {sprintf('Enter a [%d x %d] Sb matrix containing further moments:',v,v),...
                    sprintf('Enter a [1 x %d] Lb vector such that (Sb,Lb) is observable:',v),...
                    sprintf('Enter a [1 x %d] vector containing desired F0 eigenvalues:',v),...
                    sprintf('Enter a [%d x 1] G3 vector:',v)};
                dlg_title = 'Input';
                num_lines = v;
                tmp=[];
                for k=1:floor(v/2)
                    
                    W=[0 k*1;-k*1 0];
                    tmp = blkdiag(tmp,W);
                    
                end
                def_Q = tmp;
                def_R = La;
                def_eig = 10*(-1:-1:-v);
                def_G = B1(1:v,1);
                def = {num2str(def_Q),num2str(def_R),num2str(def_eig),num2str(def_G)};
                answer = inputdlg(prompt,dlg_title,num_lines,def);
                
            else
                
                prompt = {sprintf('Enter a [%d x %d] Sb matrix containing further moments:',v,v),...
                    sprintf('Enter a [1 x %d] Lb vector such that (Sb,Lb) is observable:',v),...
                    sprintf('Enter a [%d x 1] vector containing desired F0 eigenvalues:',v)};
                dlg_title = 'Input';
                num_lines = v;
                tmp=[];
                for k=1:floor(v/2)
                    
                    W=[0 k*1;-k*1 0];
                    tmp = blkdiag(tmp,W);
                    
                end
                def_Q = tmp;
                def_R = La;
                def_eig = 10*(-1:-1:-v);
                def = {num2str(def_Q),num2str(def_R),num2str(def_eig)};
                answer = inputdlg(prompt,dlg_title,num_lines,def);
                
            end
            
            if(~isempty(answer))
                
                try
                    
                    Q = evalin('base',answer{1});
                    
                catch
                    
                    Q = str2num(answer{1});
                    
                end
                
                try
                    
                    if(tau_u(2)~=0)
                        G = evalin('base',answer{4});
                    else
                        G = zeros(v,1);
                    end
                    
                catch
                    
                    if(tau_u(2)~=0)
                        G = str2num(answer{4});
                    else
                        G = zeros(v,1);
                    end
                    
                end
                
                try
                    
                    R = evalin('base',answer{2});
                       
                catch
                    
                    R = str2num(answer{2});
                    
                end
                try
                    
                    eig_des = evalin('base',answer{3});
                    
                catch
                    
                    eig_des = str2num(answer{3});
                    
                end
                
                
                if(~isequal(size(Q),[v,v]))
                    
                    errordlg('The size of Sb is not correct','Error Sb')
                    waitforbuttonpress();
                    
                elseif(~isequal(size(R),[1,v]))
                    
                    errordlg('The size of Lb is not correct','Error Lb')
                    waitforbuttonpress();
                    
                elseif(~isequal(size(eig_des),[1,v]))
                    
                    errordlg('The size of eig_des is not correct','Error eig_des')
                    waitforbuttonpress();
                    
                elseif(~isequal(size(G),[v,1]))
                    
                    errordlg('The size of G3 is not correct','Error G3')
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
            red_mod = matching2VDel(Sa,La,Q,R,G,tau_j,tau_u,eig_des,C0,C1,PIa,vars);
        end
        
        
end


out1 = red_mod;

out2=v;


end