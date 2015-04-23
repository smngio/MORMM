function [out] = errorBode(mag1,mag2)

err = abs(mag1 - mag2);
err_db = mag2db(err);
out = err_db(1,:);

end