function [value] = Binary_Decimalism(bin2_8)
% ����˵����������������ת����ʮ��������
% �����bin2_8�����������飩
% ���룺value��ʮ����������
value = 0;
len = length(bin2_8);
for i=1:len
    value = value + bin2_8(i)*(2^(len-i));
end