function projected_pts = projectPoints(p_C, K, D)

projected_pts = K * p_C;
projected_pts = projected_pts ./ projected_pts(3,:);



end

