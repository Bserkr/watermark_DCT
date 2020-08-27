% The watermark image is embedded into the color image by DCT transformation 
% ��ˮӡͼ����DCT�任Ƕ�뵽��ɫͼ���� 
clc;
clear all;
wtype = 'dct2';
iwtype = 'idct2';
originalImage=imread('lena256.bmp');
alpha=0.1;    % Embedded factor       Ƕ������ 
dim_i=size(originalImage);
rm=dim_i(1);
cm=dim_i(2);
% Embedding formula         ��Ƕ�빫ʽv��=v��1+aXk���е�a=0.1
% Display carrier image          ��ʾԭʼͼƬ
subplot(2,2,1);
imshow(originalImage);title('Original Image');

% Read and display watermark images         ˮӡͼƬ
watermark=imread('mark32.bmp');
watermark = rgb2gray(watermark);
subplot(2,2,2);
imshow(watermark);title('Watermark Image');

% DCT transform of watermark image      ��ˮӡͼƬ��DCT�任
watermark_dct=blkproc(watermark,[8,8],'dct2');
waterseria=watermark_dct(:);  % ������
% Extract green channel     ��ȡ��ɫ����
image=imread('lena256.bmp');  % ���¶�ȡһ��ԭʼͼ��Ϊ�˷���͸�ԭ��ɫͨ�������㡣
image_g=image(:,:,2);
% DCT transformed for green channel   ����ɫ��������DCT�任
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
image2=blkproc(dct_image1,[8,8],iwtype);  % ��DCT�任
%��Ƕ��ˮӡ����ɫ�����ӵ�ԭͼ��
image(:,:,2)=image2;
% ����PSNR
PSNR=psnr(image_g,image2);
image = uint8(image);
%��ˮӡ֮���ͼƬ
subplot(2,2,3);
imshow(image)
name='Ƕ��ˮӡͼ��';
title(strcat(num2str(name),'   k=',num2str(alpha),'   PSNR=',num2str(PSNR)));
imwrite(image,'withmark.bmp','bmp');

%% ˮӡ��ȡ
%��ȡ��ɫ����
outpicture = imread('withmark.bmp');
out_image=outpicture(:,:,2);  %��ȡ��ɫ����
%ˮӡ��ȡ����
outdct_image=blkproc(out_image,[8,8],wtype);  %dct�任 
%��ȡƵ��
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
%% ����NC����һ�����ϵ����%%
NC=nc(outwatermark,watermark)
subplot(2,2,4);
imshow(outwatermark);
name = 'Extract image';
title(strcat(num2str(name),   '  NC=',num2str(NC)));

