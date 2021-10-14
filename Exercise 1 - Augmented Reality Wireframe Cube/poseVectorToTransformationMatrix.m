function T = poseVectorToTransformationMatrix(pose)
% Converts a 6x1 pose vector into a 4x4 transformation matrix

omega = pose(1:3);
theta = norm(omega);

t = pose(4:6);

k = omega/theta;
k_x = k(1);
k_y = k(2);
k_z = k(3);
K = [[0,-k_z,k_y];[k_z,0,-k_x];[-k_y,k_x,0]];

R = eye(3) + sin(theta)*K + (1-cos(theta))*K^2;

T = eye(3,4);
T(1:3,1:3) = R;
T(1:3,4) = t;

end

