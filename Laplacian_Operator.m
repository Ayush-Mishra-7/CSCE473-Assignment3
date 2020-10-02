function output_image = Laplacian_Operator()

%First lets convert the image to double
image = imread('Images/175032.jpg')
figure(1);
imshow(image);
image = imgaussfilt(image,0.5);
figure(2);
imshow(image);
image = im2double(image);

lap_filter = [0 1 0; 1 -4 1; 0 1 0];


%output_image = conv2(image,lap_filter);
%output_image = edge(image, 'log', 0.2);
%figure(1);
%imshow(output_image);

f_img = zeros(size(image));

for i = 1:size(image,1) - 2
    for j = 1:size(image,2) - 2
        
        pixel_grad = sum(sum(lap_filter.*image(i:i+2, j:j+2)));
       
        f_img(i,j) = pixel_grad;
    end
end

figure(3);
imshow(f_img);

thres = 0.05;

f_img(f_img < thres) = 0;
f_img(f_img >= thres) = 1;

output_image = f_img;
figure(4);
imshow(output_image);

%output_image = im2bw(output_image);
%figure(4); imshow(output_image);


end