function output_image  = canny_edge_detector(L,H,sig)

img = imread('Images/Lena.jpg');
figure(1);
imshow(img);



no_color_channels = size(img,3);

if no_color_channels > 1
    img = rgb2gray(img);
end
    
img = im2double(img);
    

%filter_size = (ceil(sig*3))*2 + 1;

%Creating the filter
img_filter = fspecial('gaussian',sig);
%img = conv2(img,img_filter);
%figure(2);
%imshow(img);
%filter_der_x = img_filter.* [1 -1];

img1 = conv2(img,sig);
figure(2);
imshow(img1);

[f_x,f_y] = gradient(img_filter);
imgx = conv2(img1,f_x,'same');
figure(3);
imshow(imgx);

imgy = conv2(img1,f_y,'same');
figure(4);
imshow(imgy);

grad_img = sqrt((imgx.^2) + (imgy.^2));
figure(5);
imshow(grad_img);
%%We want the image orientation in all four quadrants
orient_img = (atan2(imgy, imgx))*(180/pi);
figure(6);
imshow(orient_img);

%Choosing 8 neighbours for this therefore we need
% we need to quantize the image in those directions

%To do that we need to supress the image to 0 , 45, 90, 135
%135-179
%https://sbme-tutorials.github.io/2018/cv/notes/4_week4.html#canny-edge-detection-algorithm

for i = 1:size(orient_img,1)
    for j = 1:size(orient_img,2)
        if ((orient_img(i,j) > -22.5 && orient_img(i,j) <= 22.5) || (orient_img(i,j) <= -157.5 ) || (orient_img(i,j) > 157.5) )
            %Have the gradient angle be 0
            orient_img(i,j) = 0;
        elseif ((orient_img(i,j) > 22.5 && orient_img(i,j) <= 57.5) || (orient_img(i,j) <= -112.5  && orient_img(i,j) > -157.5) )
            %Have the gradient angle be 45
            orient_img(i,j) = 45;
        elseif ((orient_img(i,j) > 57.5 && orient_img(i,j) <= 112.5) || (orient_img(i,j) <= -67.5  && orient_img(i,j) > -112.5) )
            %Have the gradient angle be 95
            orient_img(i,j) = 90;
        elseif ((orient_img(i,j) > 112.5 && orient_img(i,j) <= 157.5) || (orient_img(i,j) <= -22.5  && orient_img(i,j) > -67.5) )
            %Have the gradient angle be 135
            orient_img(i,j) = 135;
        end
    end
end
%disp(orient_img);


%Now we do the non-maximum supression
f_img = zeros(size(img1,1),size(img1,2));

for i = 2:size(f_img,1) - 2 
    for j = 2:size(f_img,2)-2
        %Checking the interpolation of the pixel
        %If the pixel is maximum we take it or else we don't
        if (orient_img(i,j) == 0)
            check_pixel = (grad_img(i,j));
            if (check_pixel > grad_img(i,j+1) && check_pixel > grad_img(i,j-1))
               f_img(i,j) = 1 ;
            end
        elseif (orient_img(i,j) == 45)
            check_pixel = (grad_img(i,j));
            if (check_pixel > grad_img(i+1,j-1) && check_pixel > grad_img(i-1,j+1))
               f_img(i,j) = 1 ;
            end
       elseif (orient_img(i,j) == 90)
            check_pixel = (grad_img(i,j));
            if (check_pixel > grad_img(i-1,j) && check_pixel > grad_img(i+1,j))
               f_img(i,j) = 1 ;
            end
       elseif (orient_img(i,j) == 135)
            check_pixel = (grad_img(i,j));
            if (check_pixel > grad_img(i+1,j+1) && check_pixel > grad_img(i-1,j-1))
               f_img(i,j) = 1 ;
            end
        end
        
    end
end


%%Now where ever we have f_img to be 1 we set that pixel to the value of
%%the gradient
for i = 2:size(f_img,1) - 2 
    for j = 2:size(f_img,2)-2
        if (f_img(i,j) == 1)
            f_img(i,j) = grad_img(i,j);
        end
    end
end


figure(7);
imshow(f_img);

%Create a new matrix to store the values
hyst_out = zeros(size(f_img,1), size(f_img,2));

%Now we implement Hystersis thresholding
for i = 1:size(hyst_out,1)
    for j = 1:size(hyst_out,2)
        %First check for weak edge
        if f_img(i,j) < L
           hyst_out(i,j) = 0; 
        %Check for strong edge
        elseif f_img(i,j) > H
            hyst_out(i,j) = 1;
        %Checking for inbetween
        elseif (f_img(i,j) < H && f_img(i,j) > L)
            if( f_img(i+1,j)>H || f_img(i-1,j)>H || f_img(i,j+1)>H || f_img(i,j-1)>H || f_img(i-1, j-1)>H || f_img(i-1, j+1)>H || f_img(i+1, j+1)>H || f_img(i+1, j-1)>H)
                hyst_out(i,j) = 1;
            end
        end
        
    end
end

output_image = hyst_out;

figure(8);
imshow(hyst_out);
title('final Output');
end
