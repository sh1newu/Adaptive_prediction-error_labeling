clear
clc
% I = imread('E:\Adaptive_prediction-error_labeling\image\test\Airplane.tiff');
 I = imread('E:\Adaptive_prediction-error_labeling\image\test\Lena.tiff');
% I = imread('E:\Adaptive_prediction-error_labeling\image\test\Man_512.tiff');
% I = imread('E:\Adaptive_prediction-error_labeling\image\test\Jetplane.tiff');
% I = imread('E:\Adaptive_prediction-error_labeling\image\test\Baboon.tiff');
% I = imread('E:\Adaptive_prediction-error_labeling\image\test\Tiffany.tiff');
% I = imread('E:\Adaptive_prediction-error_labeling\image\test\peppers.tiff');
% I = imread('E:\BOWS2OrigEp3\1478.pgm');
% I = imread('E:\BOSSbase_1.01\5162.pgm');
% I = rgb2gray(I);
origin_I = double(I);
%% ������������������
num = 2100000;%512*512=2097152
rand('seed',0); %��������
D = round(rand(1,num)*1); %�����ȶ������
%% ����ͼ�������Կ��ͼ���ϴ��Կ
Image_key = 1;
Data_key = 2;
%% ��ʼ
[encrypt_I]=owner(origin_I,Image_key);

[stego_I]=hider(encrypt_I,D,Data_key);

[exD]=receiver1(stego_I,Data_key);

[recover_I]=receiver2(stego_I,Image_key);
%---------------ͼ��Ա�----------------%
figure;
subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
subplot(222);imshow(encrypt_I,[]);title('����ͼ��');
subplot(223);imshow(stego_I,[]);title('����ͼ��');
subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
figure;
subplot(221);imhist(uint8(origin_I));title('ԭʼͼ��');
subplot(222);imhist(uint8(encrypt_I));title('����ͼ��');
subplot(223);imhist(uint8(stego_I));title('����ͼ��');
subplot(224);imhist(uint8(recover_I));title('�ָ�ͼ��');
%---------------����ж�----------------%
if  length(exD)>length(D)
    check1 = isequal(D,exD(1:length(D)));
    num_emD=length(D);
else
    check1 = isequal(D(1:length(exD)),exD);
    num_emD=length(exD);
end
[m,n] = size(origin_I);
bpp = num_emD/(m*n);
check2 = isequal(origin_I,recover_I);
if check1 == 1
    disp('��ȡ������Ƕ��������ȫ��ͬ��')
else
    disp('Warning��������ȡ����')
end
if check2 == 1
    disp('�ع�ͼ����ԭʼͼ����ȫ��ͬ��')
else
    disp('Warning��ͼ���ع�����')
end
%---------------������----------------%
if check1 == 1 && check2 == 1
    disp(['Embedding capacity equal to : ' num2str(num_emD)])
    disp(['Embedding rate equal to : ' num2str(bpp)])
    fprintf(['�ò���ͼ��------------ OK','\n\n']);
else
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end
