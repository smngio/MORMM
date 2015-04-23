function [out] = interSys(sys,sig_gen)

v=max(size(sig_gen.a));
n=max(size(sys.a));

out = ss([],[],[],0);

out.a = [sig_gen.a, zeros(v,n);
            sys.b*sig_gen.c, sys.a];
out.c = [zeros(1,v), sys.c];

end