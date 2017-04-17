function e = f_geom_error( x,x2 )
%Computes the geometric error between two sets of correspondent vectors.

%squared difference
d = (x-x2).^2;
e = mean(sqrt(sum(d)));

end

