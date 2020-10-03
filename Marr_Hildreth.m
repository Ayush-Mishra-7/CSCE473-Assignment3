function output_image = Marr_Hildreth(img,sig)
%Steps
%filter the img with gaussian
%Compute the second derivative
%Threshold the img, if > 0 -> white, else <0 black

%Find the zero crossings
%Transistion from black to white


no_color_channels = size(img,3);

if no_color_channels > 1
    img = rgb2gray(img);
end
    
img = im2double(img);
    
filter_size = (ceil(sig*3))*2 + 1;

%Creating the filter
%Log filter does the gaussian blur and at the same time calculates the
%Second derivative
img_filter = fspecial('log', filter_size, sig); 

%convolving the img with the filter
output_image = conv2(img,img_filter);
figure(1);
imshow(output_image);

%%Computing the second derivate
%[img_gradientX, img_gradientY] = gradient(output_img);

%[img_grad_secondXX, img_grad_secondXY] = gradient(img_gradientX);

%[img_grad_secondYX, img_grad_secondYY] = gradient(img_gradientY);

%second_derivative = img_grad_secondXX + img_grad_secondYY + img_grad_secondXY + img_grad_secondYX;

f_img = zeros(size(output_image));

%Checking for zero crossing
%loop through the points and check if the signs change in x-direction or
% if the sign changes in the y-direction
% Also checking if the pixel crosses zero crossing diagonally

for i = 2:size(output_image,1) - 2
    for j = 2:size(output_image,2) - 2
        if (output_image(i,j+1)>=0 && output_image(i,j-1)<0) || (output_image(i,j+1)<0 && output_image(i,j-1)>=0)
            f_img(i,j)= output_image(i,j+1);
        elseif (output_image(i+1,j)>=0 && output_image(i-1,j)<0) || (output_image(i+1,j)<0 && output_image(i-1,j)>=0)
            f_img(i,j)= output_image(i,j+1);
        elseif (output_image(i+1,j+1)>=0 && output_image(i-1,j-1)<0) || (output_image(i+1,j+1)<0 && output_image(i-1,j-1)>=0)
            f_img(i,j)= output_image(i,j+1);
        elseif (output_image(i-1,j+1)>=0 && output_image(i+1,j-1)<0) || (output_image(i-1,j+1)<0 && output_image(i+1,j-1)>=0)
            f_img(i,j)=output_image(i,j+1);
        end
    end
end



figure(2);
imshow(f_img);


end
