% The watermark image is embedded into the color image by DCT transformation 
% 将水印图像做DCT变换嵌入到彩色图像中 
clc;
clear all;
wtype = 'dct2';
iwtype = 'idct2';
originalImage=imread('lena256.bmp');
alpha=0.1;    % Embedded factor       嵌入因子 
dim_i=size(originalImage);
rm=dim_i(1);
cm=dim_i(2);
% Embedding formula         设嵌入公式v‘=v（1+aXk）中的a=0.1
% Display carrier image          显示原始图片
subplot(2,2,1);
imshow(originalImage);title('Original Image');

% Read and display watermark images         水印图片
watermark=imread('mark32.bmp');
watermark = rgb2gray(watermark);
subplot(2,2,2);
imshow(watermark);title('Watermark Image');

% DCT transform of watermark image      对水印图片做DCT变换
watermark_dct=blkproc(watermark,[8,8],'dct2');
waterseria=watermark_dct(:);  % 列向量
% Extract green channel     提取绿色分量
image=imread('lena256.bmp');  % 重新读取一次原始图像，为了分离和复原颜色通道更方便。
image_g=image(:,:,2);
% DCT transformed for green channel   对绿色分量进行DCT变换
dct_image_g=blkproc(image_g,[8,8],wtype);   
dct_image1=dct_image_g;
k=1;
for i=1:rm/8
    for j=1:cm/8
        x=(i-1)*8;y=(j-1)*8;
        ave=(dct_image_g(x+3,y+5)+dct_image_g(x+5,y+5)+dct_image_g(x+4,y+4)+dct_image_g(x+4,y+6)+dct_image_g(x+2,y+7))/5;
        dct_image1(x+4,y+5)=ave+alpha*waterseria(k);
        k=k+1;
    end
end
image2=blkproc(dct_image1,[8,8],iwtype);  % 反DCT变换
%将嵌入水印的绿色分量加到原图中
image(:,:,2)=image2;
% 计算PSNR
PSNR=psnr(image_g,image2);
image = uint8(image);
%加水印之后的图片
subplot(2,2,3);
imshow(image)
name='嵌入水印图像';
title(strcat(num2str(name),'   k=',num2str(alpha),'   PSNR=',num2str(PSNR)));
imwrite(image,'withmark.bmp','bmp');

%% 水印提取
%提取绿色分量
outpicture = imread('withmark.bmp');
out_image=outpicture(:,:,2);  %提取绿色分量
%水印提取过程
outdct_image=blkproc(out_image,[8,8],wtype);  %dct变换 
%提取频谱
k=1;
for i=1:rm/8
    for j=1:cm/8
        x=(i-1)*8;y=(j-1)*8;
        ave=(outdct_image(x+3,y+5)+outdct_image(x+5,y+5)+outdct_image(x+4,y+4)+outdct_image(x+4,y+6)+outdct_image(x+2,y+7))/5;
        outwaterseria(k)=(outdct_image(x+4,y+5)-ave)/alpha;
        k=k+1;
    end
end

k=1;
for i=1:rm/8
    for j=1:cm/8
        outwatermark_dct(j,i)=outwaterseria(k);
        k=k+1;
    end 
end
outwatermark=blkproc(outwatermark_dct,[8,8],iwtype);
outwatermark = uint8(outwatermark);
%% 计算NC（归一化相关系数）%%
NC=nc(outwatermark,watermark)
subplot(2,2,4);
imshow(outwatermark);
name = 'Extract image';
title(strcat(num2str(name),   '  NC=',num2str(NC)));

