function [recover_I]=receiver2(stego_I,Image_key,A)
[row,col] = size(stego_I);
max_length=ceil(log2(row))+ceil(log2(col))+3;
%% 先提取得到total_length
ptr4=1;
for j=2:col
    if ptr4>ceil(log2(row))+ceil(log2(col))
        break;
    end
    value = stego_I(2,j); %原始像素值
    [bin2_8] = Decimalism_Binary(value); %将像素值value转换成8位二进制数
    for k=1:16
        if bin2_8(1:length(A{1,k}))==A{1,k}
            if ptr4+7-length(A{1,k})>ceil(log2(row))+ceil(log2(col))
                total_length(ptr4:ceil(log2(row))+ceil(log2(col)))=bin2_8(length(A{1,k})+1:ceil(log2(row))+ceil(log2(col))-ptr4+1+length(A{1,k}));  %替换对应位平面的比特值
                ptr4=ceil(log2(row))+ceil(log2(col))+1;
                break;
            else
                total_length(ptr4:ptr4+7-length(A{1,k}))=bin2_8(length(A{1,k})+1:8);  %替换对应位平面的比特值
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
%% 还原图像（接收者2）
%%首先提取全部辅助信息
ptr9=1;
for i=2:row
    for j=2:col
        value = stego_I(i,j); %原始像素值
        [bin2_8] = Decimalism_Binary(value); %将像素值value转换成8位二进制数
        for k=1:16
            if bin2_8(1:length(A{1,k}))==A{1,k}
                exaux(ptr9:ptr9+7-length(A{1,k}))=bin2_8(length(A{1,k})+1:8); %替换对应位平面的比特值
                ptr9=ptr9+8-length(A{1,k});
                break;
            end
        end
        if i==init_i+1 && j==init_j+1
            break;
        end
    end
    if i==init_i+1 && j==init_j+1
        break;
    end
end
%%还原
exEncrypt_Side_Information=exaux(ceil(log2(row))+ceil(log2(col))+1:length(exaux));
[exSide_Information] = Encrypt_Data(exEncrypt_Side_Information,Image_key);
node1=max_length;
node2=node1+max_length;
exlen_bin1=exSide_Information(0+1:node1);
exlen_bin2=exSide_Information(node1+1:node2);
node3=node2+86;
node4=node3+34;
excode1=exSide_Information(node2+1:node3);
excode2=exSide_Information(node3+1:node4);
node5=node4+2;
extype=exSide_Information(node4+1:node5);
extype=Binary_Decimalism(extype);
exlen_bin1=Binary_Decimalism(exlen_bin1);
exlen_bin2=Binary_Decimalism(exlen_bin2);
node6=node5+exlen_bin1;
node7=node6+exlen_bin2;
exaux2=exSide_Information(node5+1:node6);
excompress_bits=exSide_Information(node6+1:node7);

%%解密变长码字、辅助信息。
Plane_Matrix=zeros(row-1,col-1);
if exlen_bin2==Binary_Decimalism((row-1)*(col-1))
    nn=1;
    for i=1:col-1
        for j=1:row-1
            Plane_Matrix(j,i)=excompress_bits(nn);
            nn=nn+1;
        end
    end
else
    %% ------------------解压缩位平面的压缩比特流-------------------%
    [Plane_bits] = BitStream_DeCompress(excompress_bits,3);
    %% --------------------恢复位平面的原始矩阵---------------------%
    [Plane_Matrix] = BitPlanes_Recover(Plane_bits,4,extype,row-1,col-1);
    % isequal(Map(2:512,2:512),Plane_Matrix)
end
ptr10=1;B=[];
for i=1:16
    for j=1:16
        if excode1(ptr10:ptr10+length(A{1,j})-1)==A{1,j}
            B{1,i}=A{1,j};      %%B{1,1}对应误差为0，B{1,2}对应误差绝对值为1.。。
            ptr10=ptr10+length(A{1,j});
            break;
        end
    end
end
ptr11=1;E=[];
for i=1:9
    for j=1:9
        if excode2(ptr11:ptr11+length(A{1,j})-1)==A{1,j}
            E{1,i}=A{1,j};      %%B{1,1}对应误差为0，B{1,2}对应误差绝对值为1.。。
            ptr11=ptr11+length(A{1,j});
            break;
        end
    end
end

%% 反混洗
[reshuffle_I] = Image_ReShuffle(stego_I,Image_key);
%% 先解密第一行和第一列%% 解密整个图像
[recover_temp] = Encrypt_Image(reshuffle_I,Image_key);
recover_I=reshuffle_I;
recover_I(1,1:col)=recover_temp(1,1:col);
recover_I(1:row,1)=recover_temp(1:row,1);
%%预测还原（0-13）并填补（14-。。。）
%%此时用到了位置图。
ptr9=1;
for i=2:row
    for j=2:col
        [bin2_8] = Decimalism_Binary(recover_I(i,j)); %将十进制整数转换成8位二进制数组
        a = recover_I(i-1,j);
        b = recover_I(i-1,j-1);
        c = recover_I(i,j-1);
        if b <= min(a,c)
            PV = max(a,c);
        elseif b >= max(a,c)
            PV = min(a,c);
        else
            PV = a + c - b;
        end
        if Plane_Matrix(i-1,j-1)==1
            for k=1:16
                if bin2_8(1:length(B{1,k}))==B{1,k}
                    if k==1
                        recover_I(i,j)=PV;
                    else
                        if exaux2(ptr9)==1
                            e=k-1;
                        else
                            e=-(k-1);
                        end
                        ptr9=ptr9+1;
                        recover_I(i,j)=PV+e;
                    end
                    break;
                end
            end
        else%%Map(i,j)==0
            for k=1:9
                if bin2_8(1:length(E{1,k}))==E{1,k}
                    L=k-1;
                    PV=Decimalism_Binary(PV);
                    if L==8
                            bin2_8(1:8)=PV(1:8);
                    elseif L==7
                            bin2_8(1:7)=PV(1:7);
                            bin2_8(8)=~PV(8);
                    elseif L==0
                        bin2_8(1)=~PV(1);
                        bin2_8(2:8)=exaux2(ptr9:ptr9+6);
                        ptr9=ptr9+7;
                    else
                        bin2_8(1:L)=PV(1:L);
                        bin2_8(L+1)=~PV(L+1);
                        bin2_8(L+2:8)=exaux2(ptr9:ptr9+6-L);
                        ptr9=ptr9+7-L;
                    end
                    recover_I(i,j)=Binary_Decimalism(bin2_8);
                    break;
                end
            end
        end
    end
end
