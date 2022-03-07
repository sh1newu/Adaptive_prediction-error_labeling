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
%% 产生二进制秘密数据
num = 2100000;%512*512=2097152
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数
%% 设置图像加密密钥和图像混洗密钥
Image_key = 1;
Data_key = 2;
%% 开始
[encrypt_I]=owner(origin_I,Image_key);

[stego_I]=hider(encrypt_I,D,Data_key);

[exD]=receiver1(stego_I,Data_key);

[recover_I]=receiver2(stego_I,Image_key);
%---------------图像对比----------------%
figure;
subplot(221);imshow(origin_I,[]);title('原始图像');
subplot(222);imshow(encrypt_I,[]);title('加密图像');
subplot(223);imshow(stego_I,[]);title('载密图像');
subplot(224);imshow(recover_I,[]);title('恢复图像');
figure;
subplot(221);imhist(uint8(origin_I));title('原始图像');
subplot(222);imhist(uint8(encrypt_I));title('加密图像');
subplot(223);imhist(uint8(stego_I));title('载密图像');
subplot(224);imhist(uint8(recover_I));title('恢复图像');
%---------------结果判断----------------%
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
    disp('提取数据与嵌入数据完全相同！')
else
    disp('Warning！数据提取错误！')
end
if check2 == 1
    disp('重构图像与原始图像完全相同！')
else
    disp('Warning！图像重构错误！')
end
%---------------结果输出----------------%
if check1 == 1 && check2 == 1
    disp(['Embedding capacity equal to : ' num2str(num_emD)])
    disp(['Embedding rate equal to : ' num2str(bpp)])
    fprintf(['该测试图像------------ OK','\n\n']);
else
    fprintf(['该测试图像------------ ERROR','\n\n']);
end
