function out = passivityConstraint(S,L,C,PI)

v = max(size(S));

Q =-(PI'*C'*L + L'*C*PI);

setlmis([]) 
X=lmivar(1,[v 1]);
% 1st LMI 
lmiterm([1 1 1 X],1,S,'s')
lmiterm([1 1 1 0],Q)

% 2nd LMI 
lmiterm([-2 1 1 X],1,1)

LMISYS = getlmis;

[tmin,xfeas] = feasp(LMISYS);

if(tmin<0)
    
    X = dec2mat(LMISYS,xfeas,X);

else
    
    error('The solution found is not feasible.') 
    
end

delta = X^(-1)*(C*PI)';

out=delta;
end