function H = gauss_newton(He_n, x, x2, n_it)
%Gauss-Newton algorithm: 
%Iterative optimization to enhance the estimated homography.
%INPUTS: 
%   He_n = Normalized Homography;
%   (x,x2) = points correspondences;
%   n_it = number of maximum iterations
%OUTPUTS:
%   H = Optimized homography;

N = length(x);

Jr = zeros(2*N,8);
cost = zeros(2*N,1);
h = [ He_n(1,:).' ; He_n(2,:).' ; He_n(3,1:2).' ];


%Gauss Newton main loop.
for s = 1:n_it

    %Jacobian matrix and Cost function matrix construction.
    for j = 1:N
        Den = h(7:8).'*x(1:2,j) + 1;
        Num1 = h(1:3).'*x(:,j);
        Num2 = h(4:6).'*x(:,j);

        Jr(2*j-1,:) = [ -x(1,j)/Den -x(2,j)/Den -x(3,j)/Den 0 0 0 (Num1/Den^2)*x(1,j) (Num1/Den^2)*x(2,j)  ];
        Jr(2*j,:)   = [ 0 0 0 -x(1,j)/Den -x(2,j)/Den -x(3,j)/Den (Num2/Den^2)*x(1,j) (Num2/Den^2)*x(2,j)  ];
        cost(2*j-1) = [ x2(1,j) - (Num1/Den)];
        cost(2*j)   = [ x2(2,j) - (Num2/Den)];
    end

%     if ( sum(h - (Jr.' * Jr)\(Jr.')*cost)/sum(h) > 0.999 )
%         s
%         pause;
%         break;
%     end
    %Variables update.
    h = h - inv(Jr.' * Jr)*(Jr.')*cost;
end

H = [ h(1:3).' ; h(4:6).' ; h(7:8).' 1 ];

end
