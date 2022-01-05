function scores = harris(img, patch_size, kappa)

sobal_para = [-1 0 1];
sobal_orth = [1 2 1];

Ix = conv2(sobal_orth', sobal_para, img, 'valid');
Iy = conv2(sobal_para', sobal_orth, img, 'valid');
Ixx = double(Ix .^2);
Iyy = double(Iy .^2);
Ixy = double(Ix .* Iy);

patch = ones(patch_size, patch_size);  %box filter
pr = floor(patch_size/2);  % patch radius
sIxx = conv2(Ixx, patch, 'valid');
sIyy = conv2(Iyy, patch, 'valid');
sIxy = conv2(Ixy, patch, 'valid');

trace = sIxx + sIyy;
determinant = sIxx .* sIyy -sIxy .^2;

scores = determinant - kappa * trace .^2;

scores(scores < 0) = 0;

scores = padarray(scores, [1+pr 1+pr]);

end