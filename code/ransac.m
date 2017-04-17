function [H, n_inl, idx_inl] = ransac(x1, x2)
%% RANSAC algorithm:

e_dist = 5;
n_trials = 500;
n_matches = length(x1);
n_inl = 0;

H = zeros(3,3);
idx_inl = [];

for i = 1:n_trials
   idx = floor(rand(1, 4)*n_matches) + 1;
   
   H_aux = f_dlt_norm(x1(:,idx), x2(:,idx));
   
   x12 = H_aux * x1;
   x12 = x12./repmat(x12(3,:),3,1);
   
   n_inl_aux = 0;
   idx_inl_aux = [];
   for j = 1:n_matches
       if (norm(x12(:, j) - x2(:, j)) < e_dist)
          n_inl_aux = n_inl_aux + 1;
          idx_inl_aux = [idx_inl_aux j];
       end
   end
   
   if (n_inl_aux > n_inl)
      idx_inl = idx_inl_aux;
      n_inl = n_inl_aux;
      H = H_aux;
   end
end

H = H / H(3,3);
end