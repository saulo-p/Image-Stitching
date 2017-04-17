function [X_n , T] = f_normalization( x )
%Isotropic scaling of input data.

mu = mean(x(1:2,:).');
sig = std(x(1:2,:).');

s = sqrt(2)/sqrt((sig(1)^2 + sig(2)^2));

%transformation matrix
    %multiply translation with scaling.
T = [ s 0 -mu(1)*s ; 0 s -mu(2)*s ; 0 0 1];

X_n = T*x;

end

