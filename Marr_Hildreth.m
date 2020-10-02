function output_image = Marr_Hildreth()
%Steps
%filter the image with gaussian
%Compute the second derivative
%Threshold the image, if > 0 -> white, else <0 black

%Find the zero crossings
%Transistion from black to white

image = imread('Images/3096.jpg');

no_color_channels = size(image,3);

if no_color_channels > 1
    image = rgb2gray(image);
end
    
image = im2double(image);
    
sig = 0.5;
filter_size = (ceil(sig*3))*2 + 1;

%Creating the filter
image_filter = fspecial('gaussian', filter_size); 

%convolving the image with the filter
output_image = conv2(image,image_filter);
figure(1);
imshow(output_image);

%%Computing the second derivate
[image_gradientX, image_gradientY] = gradient(output_image);

[img_grad_secondXX, img_grad_secondXY] = gradient(image_gradientX);

[img_grad_secondYX, img_grad_secondYY] = gradient(image_gradientY);

second_derivative = img_grad_secondXX + img_grad_secondYY + img_grad_secondXY + img_grad_secondYX;

f_img = zeros(size(output_image));

for i = 1:size(output_image,1) - 2
    for j = 1:size(output_image,2) - 2
        
        if second_derivative(i,j) > 0 && second_derivative(i,j+1) <0
            f_img(i,j) = 1;
        end
        
    end
end

figure(2);
imshow(f_img);

end
