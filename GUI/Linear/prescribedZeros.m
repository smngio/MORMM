function out = prescribedZeros(S,C,PI,zer)

syms s

v = max(size(S));

if(rank(obsv(S,C*PI),10e-5)<v)
    
    error('The couple (S,C*PI) is not observable.')
    
end

des_pol = poly(zer);
    
D = sym('d',[v 1]);

M=[s*eye(v) - S, D;C*PI, 0];

pol = det(M);

[coeff,~]=coeffs(pol,s);

tmp=jacobian(coeff,D);

% for i=1:v
%     c = coeff_s(i);
%     tmp(i,:)=jacobian(c,D);
%     
% end

A = double(tmp);

delta = linsolve(A,des_pol');

out = delta;

end