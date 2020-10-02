function output = prewitt(image, threshold)
%SOBEL Summary of this function goes here
%  image must be in grayscale
close all;

image = im2double(image);
output = image;

% Ready the X and Y Masks
mask_X = [-1 0 1; -1 0 1; -1 0 1];
mask_Y = [-1 -1 -1; 0 0 0; 1 1 1];

for i = 1: size(image, 1) - 2
    for j = 1: size(image, 2) - 2
        
        grad_X = sum(sum(mask_X*image(i:i + 2, j:j + 2)));
        grad_Y = sum(sum(mask_Y.*image(i:i + 2, j:j + 2))); 
        output(i + 1, j + 1) = sqrt(grad_X.^2 + grad_Y.^2);
       
    end
end

output = output > threshold/255;

figure;
imshow(output);
title('My Prewitt');
figure
imshow(edge(image));
title('Edge()');
end

