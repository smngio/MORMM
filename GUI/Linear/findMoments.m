function [out1,out2] = findMoments(sys,sig_gen)


[wn,~] = damp(sig_gen);
abs_fre = abs(freqresp(sys,wn));
out1 = mag2db(abs_fre);
out2=wn;


end