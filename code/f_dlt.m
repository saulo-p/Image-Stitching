function He = f_dlt(x,x2)
%Direct Linear Transformation (DLT). [Hartley P.91] 
N = length(x);

%fixed size (better performance)
A = zeros(2*N,9);

for i = 1:N
    Ai = [zeros(1,3) -x2(3,i)*x(:,i).'  x2(2,i)*x(:,i).' ;
          x2(3,i)*x(:,i).' zeros(1,3) -x2(1,i)*x(:,i).'  ];
    A(2*i-1:2*i,:) = Ai;
end

%% SVD and H estimate:
[U,S,V] = svd(A);

h = V(:,9).';                  
He = [h(1:3);h(4:6);h(7:9)];

end

