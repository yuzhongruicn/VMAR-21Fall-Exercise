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


%% Produce a 3D plot containing the corner positions and a visualization of the camera axis
figure(2);

