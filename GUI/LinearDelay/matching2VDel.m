function [out] = matching2VDel(Sa,La,Sb,Lb,G3,tau_j,tau_u,eig_des,C0,C1,PIa,vars)

A0 = vars.A0;

A1 = vars.A1;

n = max(size(A0));
v = max(size(Sa));


diff = setdiff(eig(Sb),eig(A0 + A1*exp(-tau_j(2))));



if(length(diff)~= v)

    error('Matrices Sb and A0 + A1*tau_j(2) have common eigenvalues');

end

diff = setdiff(eig(Sa),eig(Sb));

if(length(diff)~= v)

    error('Matrices Sb and Sa have common eigenvalues');

end


PIb = kroneckerProduct(vars.sys,vars.delay_0,Sb,Lb);


F1 = (Sb - Sa - G3*Lb*(expm(-Sb*tau_u(2)) - expm(-Sa*tau_u(2))))/(expm(-Sb*tau_j(2)) - expm(-Sa*tau_j(2)));

tmp = Sa - F1*expm(-Sa*tau_j(2)) - G3*La*expm(-Sa*tau_u(2));

G2 = place(tmp',La',eig_des)';

F0 = tmp - G2*La;

H1 = (C0*PIb - C0*PIa + C1*PIb*expm(-Sb*tau_j(2)) - C1*PIa*expm(-Sa*tau_j(2)))/(expm(-Sb*tau_j(2)) - expm(-Sa*tau_j(2)));

H0 = C0*PIa + C1*PIa*expm(-Sa*tau_j(2)) - H1*expm(-Sa*tau_j(2));

out = DelaySys({F0,F1},{G2,G3},{H0,H1},tau_j,tau_u);


end