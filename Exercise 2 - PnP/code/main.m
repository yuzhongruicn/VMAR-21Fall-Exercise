close all;
clear all

%% Load Files
img_index = 1;

undimg_path = sprintf('../data/images_undistorted/img_%04d.jpg', img_index);
undimg = imread(undimg_path);

K = load('../data/K.txt');

p_W_corners = load('../data/p_W_corners.txt') * 0.01; % centimeters to meters
num_corners = length(p_W_corners);

all_pts2d = load('../data/detected_corners.txt');
pts2d = all_pts2d(img_index, :); % 第img_index张图对应的投影点
pts2d = reshape(pts2d, 2, num_corners)'; % 不应该直接写12？？  !别忘了reshape后需要转置


%% Find the camera pose wrt the world using DLT
m_tilde_dlt = estimatePoseDLT(pts2d, p_W_corners, K);

%% Plot the original 2D points and the reprojected ones on the image
p_reproj = reprojectPoints(p_W_corners, m_tilde_dlt, K);

figure(1);
imshow(undimg); hold on;
plot(pts2d(:,1), pts2d(:,2), 'o'); hold on;
plot(p_reproj(:,1), p_reproj(:,2), '+');
legend('Original points','Reprojected points');
hold off;

%% Produce a 3D plot containing the corner positions and a visualization of the camera axis
figure(2);

scatter3(p_W_corners(:,1), p_W_corners(:,2), p_W_corners(:,3)); hold on;
axis equal;

camup([0 1 0]);
view([0 0 -1]);

R_C_W = m_tilde_dlt(1:3,1:3);
t_C_W = m_tilde_dlt(1:3,4);
rotMat = R_C_W';
pos = -R_C_W' * t_C_W;

scaleFactorArrow = .05;

axisX = quiver3(pos(1),pos(2),pos(3), rotMat(1,1),rotMat(2,1),rotMat(3,1), 'r', 'ShowArrowHead', 'on', 'AutoScale', 'on', 'AutoScaleFactor', scaleFactorArrow);
axisY = quiver3(pos(1),pos(2),pos(3), rotMat(1,2),rotMat(2,2),rotMat(3,2), 'g', 'ShowArrowHead', 'on', 'AutoScale', 'on', 'AutoScaleFactor', scaleFactorArrow);
axisZ = quiver3(pos(1),pos(2),pos(3), rotMat(1,3),rotMat(2,3),rotMat(3,3), 'b', 'ShowArrowHead', 'on', 'AutoScale', 'on', 'AutoScaleFactor', scaleFactorArrow);



