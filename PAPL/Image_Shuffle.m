function [I1] = Image_Shuffle(I,Shuffle_key)
% ����˵������ͼ��I���ݻ�ϴ����SH���л�ϴ
% ���룺I��ԭʼͼ�����,SH����ϴ���У�
% �����sh_I����ϴ���ͼ�����
[row,col] = size(I);
I1=I;
I=I(2:row,2:col);
[m,n] = size(I);
rand('seed',Shuffle_key); %��������
SH = randperm(m*n); %���ɴ�СΪrow*col��α�������
Shuffle = reshape(SH,m,n); %���ɾ���,��������
x_I = zeros(1,numel(Shuffle)); %����һά��ϴ����
for j=1:n
    for i=1:m
        x = Shuffle(i,j); %��i,j�����ҵ�λ������Ϊx
        x_I(x) = I(i,j);
    end
end
sh_I = reshape(x_I,m,n);
I1(2:row,2:col)=sh_I;
end