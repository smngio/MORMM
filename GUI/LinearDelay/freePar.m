function [out] = freePar(Sa,La,F1,H1,G3,tau_j,tau_u,eig_des,C0,C1,PIa)

tmp = Sa - F1*expm(-Sa*tau_j(2)) - G3*La*expm(-Sa*tau_u(2));

G2 = place(tmp',La',eig_des)';

F0 = tmp - G2*La;

H0 = C0*PIa + C1*PIa*expm(-Sa*tau_j(2)) - H1*expm(-Sa*tau_j(2));

out = DelaySys({F0,F1},{G2,G3},{H0,H1},tau_j,tau_u);


end