clear
clc
%读入undistorted图片
image = rgb2gray(imread('./data/images_undistorted/img_0001.jpg'));

% world frame [m]
% x = 0:4:32;
% y = 0:4:16;
% z = 0;
% [Pwx, Pwy, Pwz] = meshgrid(x,y,z);
% Pw = cat(3,Pwx,Pwy,Pwz);
square_size = 0.04;
num_corners_x = 9;
num_corners_y = 6;
num_corners = num_corners_x * num_corners_y;
[X,Y] = meshgrid(0:num_corners_x - 1, 0:num_corners_y - 1); % meshgrid
p_W_corners = square_size * [X(:) Y(:)];
p_W_corners = [p_W_corners zeros(num_corners,1)]';

%
pose = load('./data/poses.txt');
K = load('./data/K.txt'); 
D = load('./data/D.txt');

image_index = 1;

% from world to camera coordinate frame
T_C_W = poseVectorToTransformationMatrix(pose(1,:));
p_C_corners = T_C_W * [p_W_corners; ones(1, num_corners)];

projected_pts = projectPoints(p_C_corners, K, D);

figure()
imshow(image); hold on;
plot(projected_pts(1,:), projected_pts(2,:), 'r.');
hold off;















