function [exD]=receiver1(stego_I,Data_key,A)
[row,col] = size(stego_I);
%% Ƕ��������Ϣ����Ϣ�����ߣ�
%% ����ȡ�õ�total_length
%% ����ȡ�õ�total_length
ptr4=1;
for j=2:col
    if ptr4>ceil(log2(row))+ceil(log2(col))
        break;
    end
    value = stego_I(2,j); %ԭʼ����ֵ
    [bin2_8] = Decimalism_Binary(value); %������ֵvalueת����8λ��������
    for k=1:16
        if bin2_8(1:length(A{1,k}))==A{1,k}
            if ptr4+7-length(A{1,k})>ceil(log2(row))+ceil(log2(col))
                total_length(ptr4:ceil(log2(row))+ceil(log2(col)))=bin2_8(length(A{1,k})+1:ceil(log2(row))+ceil(log2(col))-ptr4+1+length(A{1,k}));  %�滻��Ӧλƽ��ı���ֵ
                ptr4=ceil(log2(row))+ceil(log2(col))+1;
                break;
            else
                total_length(ptr4:ptr4+7-length(A{1,k}))=bin2_8(length(A{1,k})+1:8);  %�滻��Ӧλƽ��ı���ֵ
                ptr4=ptr4+8-length(A{1,k});
                break;
            end
        end
    end
end
init_i=total_length(1:ceil(log2(row)));
init_j=total_length(ceil(log2(row))+1:length(total_length));
init_i=Binary_Decimalism(init_i);
init_j=Binary_Decimalism(init_j);
%% ��ȡ������Ϣ��������1��
ptr5=1;
exD=zeros(1,10);
for i=init_i+1:row
    if i==init_i+1
        jj=init_j+1;
    else
        jj=2;
    end
    for j=jj:col
        [bin2_8] = Decimalism_Binary(stego_I(i,j)); %��ʮ��������ת����8λ����������
        for k=1:16
            if bin2_8(1:length(A{1,k}))==A{1,k}
                exD(ptr5:ptr5+(7-length(A{1,k})))=bin2_8((length(A{1,k})+1):8);
                ptr5=ptr5+(8-length(A{1,k}));
                break;
            end
        end
    end
end
%---------------���ݽ���----------------%
[exD] = Encrypt_Data(exD,Data_key);