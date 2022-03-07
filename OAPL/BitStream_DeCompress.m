function [origin_bits] = BitStream_DeCompress(compress_bits,L_fix)
% ����˵������ѹ��������
% ���룺compress_bits��ѹ����������,L_fix���������������
% �����origin_bits��ԭʼ��������

len_bits = length(compress_bits); %ͳ��ѹ���������ĳ���
comp_t = 0;%�������ѱ���ѹ���������ĳ���
origin_bits = zeros(); %������¼ԭʼ������
ori_t = 0; %������ԭʼ����������Ŀ
while comp_t<len_bits 
    label = compress_bits(comp_t+1); %ѹ���εĵ�һ������ֵ
    %-------------------��ʾ��������һ�α�������ѹ��������-------------------%
    if label==1 
        L_pre = 0;  %ǰ׺���λ
        for i=comp_t+1:len_bits
            if compress_bits(i) == 1
                L_pre = L_pre+1;
            else
                L_pre = L_pre+1; %ǰ׺�����0����
                break;
            end
        end
        comp_t = comp_t + L_pre; %���ڼ�¼��ͬ������ѹ�����ǰ׺����
        l_bits = compress_bits(comp_t+1:comp_t+L_pre);%���ڼ�¼��ͬ������ѹ������м䲿��
        comp_t = comp_t + L_pre; 
        [l] = Binary_Decimalism(l_bits); %�м䲿�ֵ�ֵ
        L = 2^L_pre + l; %��ͬ�������ĳ���
        bit = compress_bits(comp_t+1);  %���ڼ�¼��ͬ�������ı���ֵ
        comp_t = comp_t + 1;
        for i=1:L %��¼ԭʼ������
            ori_t = ori_t+1;
            origin_bits(ori_t) = bit;
        end
    %----------------��ʾ��������һ�α�������ֱ�ӽ�ȡ�ı�����----------------%
    elseif label==0
        if comp_t+L_fix+1<=len_bits
            comp_t = comp_t + 1; %���λ
            origin_bits(ori_t+1:ori_t+L_fix) = compress_bits(comp_t+1:comp_t+L_fix);
            ori_t = ori_t + L_fix;
            comp_t = comp_t + L_fix;
        else
            comp_t = comp_t + 1; %���λ
            re = len_bits - comp_t;
            origin_bits(ori_t+1:ori_t+re) = compress_bits(comp_t+1:comp_t+re);
            ori_t = ori_t + re;
            comp_t = comp_t + re;
        end
    end
end
