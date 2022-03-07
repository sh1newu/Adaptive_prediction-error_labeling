function [CBS,type] = BitPlanes_Compress(Plane,Block_size,L_fix)
% ����˵����ѹ��λƽ�����Plane
% ���룺Plane��λƽ�����,Block_size���ֿ��С��,L_fix���������������
% �����CBS��λƽ��ѹ����������,type��λƽ�������з�ʽ��

%% ��λƽ�������в�����ѹ��������4�������з�ʽ��
BS_comp = cell(0); %������¼ѹ����λƽ�������
for t=0:3  %0��00,1��01,2��10,3��11
    %----------------����BMPR�㷨������λƽ��----------------%
    [origin_bits] = BitPlanes_Rearrange(Plane,Block_size,t);
    %----------------ѹ��������λƽ��ı�����----------------%
%     origin_bits=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    [compress_bits] = BitStream_Compress(origin_bits,L_fix);
    BS_comp{t+1} = compress_bits; %��¼ѹ���ı�����
end
%% �ж����������з�ʽ��ѹ�����������
len = Inf; %��ʾ�����
for t=0:3  %0��00,1��01,2��10,3��11
    bit_stream = BS_comp{t+1};
    num = length(bit_stream);
    if num < len
        CBS = bit_stream; %��¼��̵�ѹ��������
        type = t; %��¼λƽ�������з�ʽ
        len = num;    
    end 
end