function [Encrypt_D] = Encrypt_Data(D,Data_key)
% ����˵������ԭʼ������ϢD����bit��������
% ���룺D��ԭʼ������Ϣ��,Data_key�����ݼ�����Կ��
% �����Encrypt_D�����ܵ�������Ϣ��
num_D = length(D); %��Ƕ������D�ĳ���
Encrypt_D = D;  %�����洢����������Ϣ������
%% ������Կ������D������ͬ�����0/1����
rand('seed',Data_key); %��������
E = round(rand(1,num_D)*1); %������ɳ���Ϊnum_D��0/1����
%% ����E��ԭʼ������ϢD����������
for i=1:num_D  
    Encrypt_D(i) = bitxor(D(i),E(i));
end
end