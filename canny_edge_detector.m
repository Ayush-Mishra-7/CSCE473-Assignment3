function output_image  = canny_edge_detector()

image = imread('Images/3096.jpg');

L = 0.1;
H = 0.3;
sig = 0.2;

no_color_channels = size(image,3);

if no_color_channels > 1
    image = rgb2gray(image);
end
    
image = im2double(image);
    
sig = 0.5;
filter_size = (ceil(sig*3))*2 + 1;

%Creating the filter
image_filter = fspecial('gaussian', filter_size); 




end