function imageAttack(wimage)   %ˮӡ����ʵ��
%% ���й������� %%
disp('1-->���������');
disp('2-->��˹��ͨ�˲�');
disp('3-->����ͼ��');
disp('4-->��ת����');
disp('5-->ֱ�Ӽ��')
begin=input('��ѡ�񹥻���1-5����')
switch begin
        % ��������� 
    case 1
        Aimage1=wimage;
        Wnoise=20*randn(size(Aimage1));
        Aimage1=Aimage1+Wnoise;
        subplot(2,3,4),imshow(Aimage1,[]),title('������������ͼ��');
        att=Aimage1;
        %imwrite(att,'whitenoiseimage.bmp');
        % ��˹��ͨ�˲� 
    case 2
        Aimage2=wimage;
        H=fspecial('gaussian',[4,4],0.5);
        Aimage2=imfilter(Aimage2,H);
        subplot(2,3,4),imshow(Aimage2,[]),title('��˹��ͨ�˲����ͼ��');
        att=Aimage2;
        %imwrite(att,'gaussianimage.bmp')
        % ���й��� 
    case 3
        Aimage3=wimage;
        Aimage3(1:128,1:128)=256;
        subplot(2,3,4),imshow(Aimage3,[]),title('���к��ͼ��');
        att=Aimage3;
        %imwrite(att,'cutpartimage.bmp');
        % ��ת���� 
    case 4
        Aimage4=wimage;
        Aimage4=imrotate(Aimage4,0.55,'bilinear','crop');
        Aimage_4=mat2gray(Aimage4);
        subplot(2,3,4),imshow(Aimage_4,[]),title('��ת10 �Ⱥ��ͼ��');
        att=Aimage_4;
        imwrite(att,'rotatedimage.bmp');
        % û���ܵ����� 
    case 5
        subplot(2,3,4),imshow(wimage,[]),title('ֱ����ȡ��ͼ��');
        att=wimage;
        %imwrite(att,'directimage.bmp');
end