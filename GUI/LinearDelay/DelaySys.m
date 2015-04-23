classdef DelaySys
    % write a description of the class here.
    
    properties
        % define the properties of the class here, (like fields of a struct)
        Aj = {[],[]};
        Bj = {[],[]};
        Cj = {[],[]};
        tau_j = zeros(1,2);
        tau_u= zeros(1,2);
        zeta;
        mu;
        delayT = struct('delay',{},'a',{},'b',{},'c',{},'d',{});
        delayS;
        
    end
    
    methods
        % methods, including the constructor are defined in this block
        
        function obj = DelaySys(Aj,Bj,Cj,tau_j,tau_u)
            % class constructor
            if(nargin > 0)
                
                obj.Aj = Aj;
                obj.Bj = Bj;
                obj.Cj = Cj;
                obj.tau_j = tau_j;
                obj.tau_u = tau_u;
                
                obj = checkTau(obj);
                obj = buildDelaySs(obj);
                
            end
            
        end
        
    end
    
    methods(Access = private)
        
        function obj = checkTau(obj)
            
            lenA = length(obj.Aj);
            lenB = length(obj.Bj);
            lenC = length(obj.Cj);
            lenTi= length(obj.tau_j);
            lenTu= length(obj.tau_u);
            
            if(isequal(lenA,lenTi) && isequal(lenC,lenTi) && (isequal(lenB,lenTu)))
                
                obj = setMuZeta(obj);
                
            else
                
                error('Mismatch beetween delays and A,B,C ')
                
            end
            
        end
        
        function obj = setMuZeta(obj)
            
            [ind,~,~] = find(obj.tau_j);
            obj.zeta = sum(ind);
            [ind,~,~] = find(obj.tau_u);
            obj.mu = sum(ind);
            if(obj.mu == 0)
                if(obj.Bj{2}~=0)
                    error('Mismatch beetween delays and Bj')
                end
            end
            
        end
        
        function obj = buildDelaySs(obj)
            
            %lenTi= length(obj.tau_j);
            lenTu= length(obj.tau_u);
            
%             for j=1:lenTi
%                 
%                 obj.delayT(j) = struct('delay',obj.tau_j(j),'a',obj.Aj{j},'b',0,'c',obj.Cj{j},'d',0);
%             
%             end

            if(obj.zeta~=0)
                
                obj.delayT(1) = struct('delay',obj.tau_j(2),'a',obj.Aj{2},'b',0,'c',obj.Cj{2},'d',0);
                
            end
            
            h=obj.zeta;
            
            for j=1:lenTu
                
                if(obj.tau_u(j)~=0)
                    
                    obj.delayT(j+h) = struct('delay',obj.tau_u(j),'a',0,'b',obj.Bj{j},'c',0,'d',0);
                    
                else
                    
                    h=0;
                    
                end
                    
                               
            end
            
            
            if(obj.tau_u(1)==0)
                
                obj.delayS = delayss(obj.Aj{1},obj.Bj{1},obj.Cj{1},0,obj.delayT);
            
            else
                
                obj.delayS = delayss(obj.Aj{1},[],obj.Cj{1},0,obj.delayT);
                
            end
            
        end
        
    end
end