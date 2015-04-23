function out =  minRes(A,B,C,D,S,H,L,X0,constraint,options) 


v = max(size(S));
sys = ss(A,B,C,D);

if(v>7)
    
    v=3;
    
end


for i=1:v
    
     try
         
        del{i} = fmincon(@nestedfun,X0{i},[],[],[],[],[],[],constraint,options);
        F{i} = S-del{i}*L;
        red{i} = ss(F{i},del{i},H,0);
        res(i) = norm(sys-red{i},2);
        
     catch
         res(i) = Inf;
     end
end

[~,ind] = min(res);

out = del{ind};


    function obj = nestedfun(x)
        
       
        tmp_red = ss(S-x*L,x,H,0);

        obj = norm(sys-tmp_red,2);
%       obj = sqrt(abs(tr1-tr2));

       %obj = sqrt((1/(2*pi))*integral(@(w,in2)f(w,x),-Inf,Inf));
        
    end

end