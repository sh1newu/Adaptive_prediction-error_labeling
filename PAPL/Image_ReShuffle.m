function [II] = Image_ReShuffle(sh_I,Shuffle_key)
% ����˵������ͼ��I���ݻ�ϴ����SH���л�ϴ
% ���룺sh_I����ϴ��ͼ�����,SH����ϴ���У�
% �����re_I���ָ����ͼ�����
[row,col] = size(sh_I);
II=sh_I;
sh_I=sh_I(2:row,2:col);
[m,n] = size(sh_I);
rand('seed',Shuffle_key); %��������
SH = randperm(m*n); %���ɴ�СΪrow*col��α�������
num = numel(SH);
I1 = reshape(sh_I,1,m*n); %��sh_Iת����һά����
x_I = zeros(1,m*n); %����һά�ָ�����
for i=1:num
    x = SH(i); %���ҵ�����
    x_I(i) = I1(x);
end
re_I = reshape(x_I,m,n);
II(2:row,2:col)=re_I;
end