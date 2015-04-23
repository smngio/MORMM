function [out] = loadData(var)

out.A = var{1};
out.B = var{2};
out.C = var{3};
out.D = var{4};
out.S = var{5};
out.L = var{6};
out.x0= var{7};
out.w0= var{8};
out.omega=logspace(-2,4,40000);
out.tokeep = {'A','B','C','D','S','L','x0','w0','omega','tokeep'};

end