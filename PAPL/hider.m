function [stego_I]=hider(encrypt_I,A,D,Data_key)

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
%% ��ԭʼ������ϢD���м���
[Encrypt_D] = Encrypt_Data(D,Data_key);
%% ��Ƕ��������Ϣ
ptr3=1;
stego_I=encrypt_I;
for i=init_i+1:row
    if i==init_i+1
        jj=init_j+1;
    else
        jj=2;
    end
    if ptr3>length(Encrypt_D)
        break;
    end
    for j=jj:col
        if ptr3>length(Encrypt_D)
            break;
        end
        [bin2_8] = Decimalism_Binary(encrypt_I(i,j)); %��ʮ��������ת����8λ����������
        for k=1:16
            if bin2_8(1:length(A{1,k}))==A{1,k}
                if ptr3+7-length(A{1,k})>length(Encrypt_D)
                    bin2_8((length(A{1,k}))+1:length(Encrypt_D)-ptr3+(length(A{1,k}))+1) = Encrypt_D(ptr3:length(Encrypt_D)); %�滻��Ӧλƽ��ı���ֵ
                    ptr3=length(Encrypt_D)+1;
                else
                    bin2_8((length(A{1,k}))+1:8)=Encrypt_D(ptr3:ptr3+(7-length(A{1,k})));
                    ptr3=ptr3+8-length(A{1,k});
                end
                break;
            end
        end
        stego_I(i,j)=Binary_Decimalism(bin2_8);
    end
end