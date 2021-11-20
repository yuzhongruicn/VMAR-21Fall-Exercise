function m_tilde = estimatePoseDLT(p,P,K)
% p: [nx2];
% P: [nx3];
% K: [3x3];

%normalization
p_normalized = (K \ [p ones(length(p),1)]')'; %反斜杠:矩阵左除， 单引号:转置;

num_corners = length(p_normalized);

Q = zeros(2*num_corners, 12);

for i = 1:num_corners
    u = p_normalized(i,1);
    v = p_normalized(i,2);
    
    Q(2*i-1, 1:3) = P(i,:);
    Q(2*i-1, 4) = 1;
    Q(2*i-1, 9:12) = -u*[P(i,:) 1];
    
    Q(2*i, 5:7) = P(i,:);
    Q(2*i, 8) = 1;
    Q(2*i, 9:12) = -u*[P(i,:) 1];
end

% solving Q.M = 0 using SVD
% [U,S,V] = svd(Q);
[~,~,V] = svd(Q);
m_tilde = V(:,end);
m_tilde = reshape(m_tilde, 4, 3)'; %记得取转置

if det(m_tilde(:, 1:3)) < 0
    m_tilde = m_tilde * -1;
end

R = m_tilde(:, 1:3);
[U_2,~,V_2] = svd(R);

R_tilde = U_2*V_2';

alpha = norm(R_tilde, 'fro') / norm(R, 'fro'); % Frobenius norm
t_tilde = alpha * m_tilde(:,4);

m_tilde = [R_tilde t_tilde];

    
end

