function imageAttack(wimage)   %水印攻击实验
%% 进行攻击测试 %%
disp('1-->加入白噪声');
disp('2-->高斯低通滤波');
disp('3-->剪切图像');
disp('4-->旋转攻击');
disp('5-->直接检测')
begin=input('请选择攻击（1-5）：')
switch begin
        % 加入白噪声 
    case 1
        Aimage1=wimage;
        Wnoise=20*randn(size(Aimage1));
        Aimage1=Aimage1+Wnoise;
        subplot(2,3,4),imshow(Aimage1,[]),title('加入白噪声后的图象');
        att=Aimage1;
        %imwrite(att,'whitenoiseimage.bmp');
        % 高斯低通滤波 
    case 2
        Aimage2=wimage;
        H=fspecial('gaussian',[4,4],0.5);
        Aimage2=imfilter(Aimage2,H);
        subplot(2,3,4),imshow(Aimage2,[]),title('高斯低通滤波后的图象');
        att=Aimage2;
        %imwrite(att,'gaussianimage.bmp')
        % 剪切攻击 
    case 3
        Aimage3=wimage;
        Aimage3(1:128,1:128)=256;
        subplot(2,3,4),imshow(Aimage3,[]),title('剪切后的图象');
        att=Aimage3;
        %imwrite(att,'cutpartimage.bmp');
        % 旋转攻击 
    case 4
        Aimage4=wimage;
        Aimage4=imrotate(Aimage4,0.55,'bilinear','crop');
        Aimage_4=mat2gray(Aimage4);
        subplot(2,3,4),imshow(Aimage_4,[]),title('旋转10 度后的图象');
        att=Aimage_4;
        imwrite(att,'rotatedimage.bmp');
        % 没有受到攻击 
    case 5
        subplot(2,3,4),imshow(wimage,[]),title('直接提取的图像');
        att=wimage;
        %imwrite(att,'directimage.bmp');
end