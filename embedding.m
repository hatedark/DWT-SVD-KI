clc
close all

%host

rgbimage=imread('original/host.jpg');
temp = rgbimage;
[cols, rows, channel, ~] = size(rgbimage);
%figure;
%imshow(rgbimage);
%title('Original color image');
[h_LL,h_LH,h_HL,h_HH]=dwt2(rgbimage,'haar');
img=h_LL;
red1=img(:,:,1);
green1=img(:,:,2);
blue1=img(:,:,3);
[U_imgr1,S_imgr1,V_imgr1]= svd(red1);
[U_imgg1,S_imgg1,V_imgg1]= svd(green1);
[U_imgb1,S_imgb1,V_imgb1]= svd(blue1);

%watermark

rgbimage=imread('original/watermark.png');
rgbimage = imresize(rgbimage, [cols rows], 'nearest');
%figure;
%imshow(rgbimage);
%title('Watermark image');
[w_LL,w_LH,w_HL,w_HH]=dwt2(rgbimage,'haar');
img_wat=w_LL;
red2=img_wat(:,:,1);
green2=img_wat(:,:,2);
blue2=img_wat(:,:,3);
[U_imgr2,S_imgr2,V_imgr2]= svd(red2);
[U_imgg2,S_imgg2,V_imgg2]= svd(green2);
[U_imgb2,S_imgb2,V_imgb2]= svd(blue2);


% watermarking

S_wimgr=S_imgr1+(0.10*S_imgr2);
S_wimgg=S_imgg1+(0.10*S_imgg2);
S_wimgb=S_imgb1+(0.10*S_imgb2);


wimgr = U_imgr1*S_wimgr*V_imgr1';
wimgg = U_imgg1*S_wimgg*V_imgg1';
wimgb = U_imgb1*S_wimgb*V_imgb1';

wimg=cat(3,wimgr,wimgg,wimgb);
newhost_LL=wimg;

%output

rgb2=idwt2(newhost_LL,h_LH,h_HL,h_HH,'haar');
imwrite(uint8(rgb2),'original/Watermarked.jpg');
%figure;imshow(uint8(rgb2));title('Watermarked Image');

figure;
subplot(2, 2, 1);
imshow(temp, []);
title('Host image');
subplot(2, 2, 2);
imshow(uint8(rgb2), []);
title('Watermarked Image');
subplot(2, 2, 3);
imshow(rgbimage, []);
title('Watermark Logo');