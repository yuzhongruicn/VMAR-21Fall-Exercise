function undistorted_img = undistortImage(img,K,D,bilinear_interpilation)

if nargin < 4
    bilinear_interpilation = 0;
end

[height, width] = size(img);
undistorted_img = uint8(zeros(height,width));

for x = 1:width
    for y = 1:height
        x_d = distortPoints([x-1;y-1],D,K);
        u = x_d(1); v = x_d(2);
        
        u1 = floor(u); v1 = floor(v);
        if bilinear_interpilation > 0
            a = u-u1; b = v-v1;
            if u1+1 > 0 && u1+1 <= width && v1+1 > 0 && v1+1 <= height
                undistorted_img(y,x) = (1-b) * ((1-a)*img(v1,u1) + a*img(v1,u1+1)) ...
                                      + b * ((1-a)*img(v1+1,u1) + a*img(v1+1,u1+1));
            end
        else
            if u1 > 0 && u1 <= width && v1 > 0 && v1 <= height
                undistorted_img(y,x) = img(v1,u1);
            end
        end
    end
end
end

