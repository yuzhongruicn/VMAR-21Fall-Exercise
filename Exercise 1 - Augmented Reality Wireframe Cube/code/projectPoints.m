function projected_pts = projectPoints(p_C, K, D)


if nargin <= 2
    D = zeros(1, 2);
end

projected_pts = K * p_C;
projected_pts = projected_pts ./ projected_pts(3,:);

projected_pts = distortPoints(projected_pts(1:2,:),D,K);


end

