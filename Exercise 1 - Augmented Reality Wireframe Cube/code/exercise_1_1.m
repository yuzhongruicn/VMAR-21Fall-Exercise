close all;
clear all;

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
pose = load('../data/poses.txt');
K = load('../data/K.txt'); 
D = load('../data/D.txt');

image_index = 1;

%read undistorted pictures
% image = rgb2gray(imread(['../data/images_undistorted/',sprintf('img_%04d.jpg',image_index)]));

%read the first distorted pictures
image = rgb2gray(imread(['../data/images/',sprintf('img_%04d.jpg',image_index)]));

% from world to camera coordinate frame
T_C_W = poseVectorToTransformationMatrix(pose(1,:));
p_C_corners = T_C_W * [p_W_corners; ones(1, num_corners)];
p_C_corners = p_C_corners(1:3,:);

projected_pts = projectPoints(p_C_corners, K, D);

figure(1)
imshow(image); hold on;
plot(projected_pts(1,:), projected_pts(2,:), 'r.');
hold off;

% Undistort image with bilinear interpolation
tic;
img_undistorted = undistortImage(image,K,D,1);
disp(['Undistortion with bilinear interpolation completed in ' num2str(toc)]);

% Vectorized undistortion without bilinear interpolation
tic;
img_undistorted_vectorized = undistortImageVectorized(image,K,D);
disp(['Vectorized undistortion completed in ' num2str(toc)]);

figure();
subplot(1, 2, 1);
imshow(img_undistorted);
title('With bilinear interpolation');
subplot(1, 2, 2);
imshow(img_undistorted_vectorized);
title('Without bilinear interpolation');

offset_x = 0.04*3;
offset_y = 0.04;
s = 2*0.04;

[X, Y, Z] = meshgrid(0:1, 0:1, -1:0);

p_W_cube = [offset_x + X(:)*s, offset_y + Y(:)*s, Z(:)*s]';

p_C_cube = T_C_W* [p_W_cube; ones(1,8)];
p_C_cube = p_C_cube(1:3,:);

cube_pts = projectPoints(p_C_cube, K, zeros(4,1));

figure();
imshow(img_undistorted); hold on;

lw = 3;

% base layer of the cube
line([cube_pts(1,1), cube_pts(1,2)],[cube_pts(2,1), cube_pts(2,2)], 'color', 'red', 'linewidth', lw);
line([cube_pts(1,1), cube_pts(1,3)],[cube_pts(2,1), cube_pts(2,3)], 'color', 'red', 'linewidth', lw);
line([cube_pts(1,2), cube_pts(1,4)],[cube_pts(2,2), cube_pts(2,4)], 'color', 'red', 'linewidth', lw);
line([cube_pts(1,3), cube_pts(1,4)],[cube_pts(2,3), cube_pts(2,4)], 'color', 'red', 'linewidth', lw);

% top layer
line([cube_pts(1,1+4), cube_pts(1,2+4)],[cube_pts(2,1+4), cube_pts(2,2+4)], 'color', 'red', 'linewidth', lw);
line([cube_pts(1,1+4), cube_pts(1,3+4)],[cube_pts(2,1+4), cube_pts(2,3+4)], 'color', 'red', 'linewidth', lw);
line([cube_pts(1,2+4), cube_pts(1,4+4)],[cube_pts(2,2+4), cube_pts(2,4+4)], 'color', 'red', 'linewidth', lw);
line([cube_pts(1,3+4), cube_pts(1,4+4)],[cube_pts(2,3+4), cube_pts(2,4+4)], 'color', 'red', 'linewidth', lw);

% vertical lines
line([cube_pts(1,1), cube_pts(1,1+4)],[cube_pts(2,1), cube_pts(2,1+4)], 'color', 'red', 'linewidth', lw);
line([cube_pts(1,2), cube_pts(1,2+4)],[cube_pts(2,2), cube_pts(2,2+4)], 'color', 'red', 'linewidth', lw);
line([cube_pts(1,3), cube_pts(1,3+4)],[cube_pts(2,3), cube_pts(2,3+4)], 'color', 'red', 'linewidth', lw);
line([cube_pts(1,4), cube_pts(1,4+4)],[cube_pts(2,4), cube_pts(2,4+4)], 'color', 'red', 'linewidth', lw);

hold off;
set(gca,'position',[0 0 1 1],'units','normalized')











