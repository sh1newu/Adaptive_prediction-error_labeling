function [stego_I]=hider(encrypt_I,D,Data_key)
[row,col] = size(encrypt_I); %����origin_I������ֵ
%% Ƕ��������Ϣ����Ϣ�����ߣ�
%% ����ȡ�õ�total_length
ptr4=1;
for j=2:col
    if ptr4>ceil(log2(row))+ceil(log2(col))
        break;
    end
    value = encrypt_I(2,j); %ԭʼ����ֵ
    [bin2_8] = Decimalism_Binary(value); %������ֵvalueת����8λ��������
    if ptr4+7>ceil(log2(row))+ceil(log2(col))
        total_length(ptr4:ceil(log2(row))+ceil(log2(col)))=bin2_8(1:ceil(log2(row))+ceil(log2(col))-ptr4+1);  %�滻��Ӧλƽ��ı���ֵ
        ptr4=ceil(log2(row))+ceil(log2(col))+1;
    else
        total_length(ptr4:ptr4+7)=bin2_8(1:8);  %�滻��Ӧλƽ��ı���ֵ
        ptr4=ptr4+8;
    end
end
init_i=total_length(1:ceil(log2(row)));
init_j=total_length(ceil(log2(row))+1:length(total_length));
init_i=Binary_Decimalism(init_i);
init_j=Binary_Decimalism(init_j);
%% ��ԭʼ������ϢD���м���
[Encrypt_D] = Encrypt_Data(D,Data_key);
%% ��Ƕ��������Ϣ
ptr5=1;
stego_I = encrypt_I;
for i=init_i+1:row
    if i==init_i+1
        jj=init_j+1;
    else
        jj=2;
    end
    if ptr5>length(Encrypt_D)
        break;
    end
    for j=jj:col
        if ptr5>length(Encrypt_D)
            break;
        end
        value = encrypt_I(i,j); %ԭʼ����ֵ
        [bin2_8] = Decimalism_Binary(value); %������ֵvalueת����8λ��������
        if ptr5+7>length(Encrypt_D)
            bin2_8(1:length(Encrypt_D)-ptr5+1) = Encrypt_D(ptr5:length(Encrypt_D)); %�滻��Ӧλƽ��ı���ֵ
            ptr5=length(Encrypt_D)+1;
        else
            bin2_8(1:8) = Encrypt_D(ptr5:ptr5+7); %�滻��Ӧλƽ��ı���ֵ
            ptr5=ptr5+8;
        end
        [value] = Binary_Decimalism(bin2_8); %���滻λƽ��Ķ�����ת����ʮ������
        stego_I(i,j) = value;
    end
end
