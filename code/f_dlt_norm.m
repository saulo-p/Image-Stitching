function He = f_dlt_norm( x,x2 )
%Normalized DLT [Hartley P.109]

%% Normalization 1
[X_n , T] = f_normalization(x);

% %check
% mu2 = mean(X_n(1:2,:).');
% sig2 = std(X_n(1:2,:).');

%% Normalization 2
[X2_n, T2] = f_normalization(x2);

%% DLT and estimate:

He = f_dlt(X_n , X2_n);
He = inv(T2)*He*T;

end

