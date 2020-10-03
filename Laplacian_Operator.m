function output_image = Laplacian_Operator(image,thres)

%First lets convert the image to double
figure(1);
imshow(image);
no_color_channels = size(image,3);
if no_color_channels > 1
    image = rgb2gray(image);
end

image = im2double(image);


lap_filter = [0 1 0; 1 -4 1; 0 1 0];


f_img = zeros(size(image));

for i = 1:size(image,1) - 2
    for j = 1:size(image,2) - 2
        
        pixel_grad = sum(sum(lap_filter.*image(i:i+2, j:j+2)));
       
        f_img(i+1,j+1) = pixel_grad;
    end
end

figure(2);
imshow(f_img);


%f_img(f_img < (thres/255)) = 0;
%f_img(f_img >= (thres/255)) = 1;

f_img = f_img > (thres/255);

output_image = f_img;
figure(3);
imshow(output_image);

%output_image = im2bw(output_image);
%figure(4); imshow(output_image);


end