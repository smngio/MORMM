function out = gainL2(S,L,C,PI,gamma)

v = max(size(S));

Q =((PI'*C')*(C*PI));
R =-((gamma^2)*(L'*L));

setlmis([]) 
X=lmivar(1,[v 1]);
% 1st LMI 
lmiterm([1 1 1 X],1,S,'s')
lmiterm([1 1 1 0],Q)
lmiterm([1 1 1 0],R)

% 2nd LMI 
lmiterm([-2 1 1 X],1,1)

LMISYS = getlmis;

[tmin,xfeas] = feasp(LMISYS);

if(tmin<0)
    
    X = dec2mat(LMISYS,xfeas,X);
    
else
    
    error('The solution found is not feasible.') 
    
end

delta = (gamma^2)*X^(-1)*(L)';

out=delta;

end