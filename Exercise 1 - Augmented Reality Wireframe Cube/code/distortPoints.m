function d_pts = distortPoints(pts,D,K)

k1 = D(1); k2 = D(2);

u0 = K(1,3);
v0 = K(2,3);

u_u0 = pts(1,:) - u0;
v_v0 = pts(2,:) - v0;

r_2 = u_u0.^2 + v_v0.^2;

ud = u_u0.*(1 + k1*r_2 + k2*r_2.^2) + u0;
vd = v_v0.*(1 + k1*r_2 + k2*r_2.^2) + v0;

d_pts = [ud; vd];
end

