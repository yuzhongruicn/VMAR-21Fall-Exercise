close all;
clear all;

K = load('../data/K.txt');

p_W_corners = load('../data/p_W_corners.txt') * 0.01; % centimeters to meters
num_corners = length(p_W_corners);

all_pts2d = load('../data/detected_corners.txt');

img_nums = 210;
translations = zeros(img_nums, 3);
quaternions = zeros(img_nums, 4);

for img_index = 1:img_nums
    
    pts2d = all_pts2d(img_index, :); % 第img_index张图对应的投影点
    pts2d = reshape(pts2d, 2, num_corners)'; % 不应该直接写12？？  !别忘了reshape后需要转置
    
    m_tilde_dlt = estimatePoseDLT(pts2d, p_W_corners, K);
    
    R_C_W = m_tilde_dlt(1:3,1:3);
    t_C_W = m_tilde_dlt(1:3,4);
    rotMat = R_C_W';
    
    quaternions(img_index, :) = rotMatrix2Quat(rotMat) ;
    translations(img_index, :) = -R_C_W' * t_C_W;
    
end

fps = 30;
plotTrajectory3D(fps, translations', quaternions', p_W_corners');