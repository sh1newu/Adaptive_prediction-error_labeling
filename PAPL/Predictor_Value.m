function [origin_PV_I] = Predictor_Value(origin_I)  
% ����˵��������origin_I��Ԥ��ֵ
% ���룺origin_I��ԭʼͼ��,ref_x,ref_y���ο����ص���������
% �����origin_PV_I��ԭʼͼ���Ԥ��ֵ��
[row,col] = size(origin_I); %����origin_I������ֵ
origin_PV_I = origin_I;  %�����洢origin_IԤ��ֵ������
for i=2:row  %ǰref_x����Ϊ�ο����أ�����Ԥ��
    for j=2:col  %ǰref_y����Ϊ�ο����أ�����Ԥ��
        a = origin_I(i-1,j);
        b = origin_I(i-1,j-1);
        c = origin_I(i,j-1);
        if b <= min(a,c)
            origin_PV_I(i,j) = max(a,c);
        elseif b >= max(a,c)
            origin_PV_I(i,j) = min(a,c);
        else
            origin_PV_I(i,j) = a + c - b;
        end
    end
end