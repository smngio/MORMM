function [out] = loadDataDel(var)

out.A0 = var{1};
out.A1 = var{2};
out.B0 = var{3};
out.B1 = var{4};
out.C0 = var{5};
out.C1 = var{6};
out.Sa = var{7};
out.La = var{8};
out.tau_j = [0,var{9}];
out.tau_u = var{10};
out.w0 = var{11};
out.x0 = var{12};
out.omega = logspace(-2,4,40000);
out.sys = DelaySys({out.A0,out.A1},{out.B0,out.B1},{out.C0,out.C1},out.tau_j,out.tau_u);
out.sig_gen = ss(out.Sa,[],out.La,0);
out.tokeep = {'A0','A1','B0','B1','C0','C1','x0','Sa','La','tau_j','tau_u','w0','omega','sys','sig_gen','tokeep'};

end