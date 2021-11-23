function p_reproj = reprojectPoints(P,M,K)

%P: [nx3] 3D points in the world frame;
%m: [3x4] projection matrix
%K: [3x3] camera matrix

p_homo = (K*M*[P'; ones(1,length(P))])'; 
p_homo(:,1) = p_homo(:,1) ./ p_homo(:,3);
p_homo(:,2) = p_homo(:,2) ./ p_homo(:,3);

p_reproj = p_homo(:, 1:2);
end

