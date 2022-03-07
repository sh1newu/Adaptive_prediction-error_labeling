function [recover_I]=receiver2(stego_I,Image_key)
[row,col] = size(stego_I);
max_length=ceil(log2(row))+ceil(log2(col))+3;
%% 先提取得到total_length
ptr8=1;
for j=2:col
    if ptr8>ceil(log2(row))+ceil(log2(col))
        break;
    end
    value = stego_I(2,j); %原始像素值
    [bin2_8] = Decimalism_Binary(value); %将像素值value转换成8位二进制数
    if ptr8+7>ceil(log2(row))+ceil(log2(col))
        total_length(ptr8:ceil(log2(row))+ceil(log2(col)))=bin2_8(1:ceil(log2(row))+ceil(log2(col))-ptr8+1);  %替换对应位平面的比特值
        ptr8=ceil(log2(row))+ceil(log2(col))+1;
    else
        total_length(ptr8:ptr8+7)=bin2_8(1:8);  %替换对应位平面的比特值
        ptr8=ptr8+8;
    end
end
init_i=total_length(1:ceil(log2(row)));
init_j=total_length(ceil(log2(row))+1:length(total_length));
init_i=Binary_Decimalism(init_i);
init_j=Binary_Decimalism(init_j);
[stego_I1]= Encrypt_Image(stego_I,Image_key);
%% 提取秘密信息（接收者1）
ptr9=1;
for i=2:row
    for j=2:col
        value = stego_I1(i,j); %原始像素值
        [bin2_8] = Decimalism_Binary(value); %将像素值value转换成8位二进制数
        exaux(ptr9:ptr9+7)=bin2_8(1:8); %替换对应位平面的比特值
        ptr9=ptr9+8;
        if i==init_i+1 && j==init_j+1
            break;
        end
    end
    if i==init_i+1 && j==init_j+1
        break;
    end
end


%%还原
node0=ceil(log2(row))+ceil(log2(col));
node1=node0+8;
T=exaux(node0+1:node1);
T=Binary_Decimalism(T);

[A,length_AA]=query(T);

if T<=15 && T>=8
    C={[0 1],[1 0],[0 0],[1 1 0],[1 1 1]};length_C1=12;length_C2=5;
elseif T==0
    C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],[0 0 0 0],[1 1 1 1 0],[1 1 1 1 1]};length_C1=32;length_C2=9;
elseif T<=32 && T>=16
    C={[0 1],[1 0],[0 0],[1 1]};length_C1=8;length_C2=4;
elseif T<=7 && T>=4
    C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0],[1 1 1]};length_C1=16;length_C2=6;
elseif T==1
    C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],[0 0 0 0],[1 1 1 1]};length_C1=26;length_C2=8;
elseif T<=3 && T>=2
    C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0],[1 1 1 0],[1 1 1 1]};length_C1=21;length_C2=7;
end

node2=node1+max_length;
exlen_bin0=exaux(node1+1:node2);
exlen_bin0=Binary_Decimalism(exlen_bin0);
node3=node2+exlen_bin0;
excode0=exaux(node2+1:node3);
excode0=[excode0,zeros(1,100)];
node4=node3+max_length;
exlen_bin1=exaux(node3+1:node4);
node5=node4+max_length;
exlen_bin2=exaux(node4+1:node5);
node6=node5+length_AA;
excode1=exaux(node5+1:node6);
node7=node6+length_C1;
excode2=exaux(node6+1:node7);
node8=node7+2;
extype=exaux(node7+1:node8);
extype=Binary_Decimalism(extype);
exlen_bin1=Binary_Decimalism(exlen_bin1);
exlen_bin2=Binary_Decimalism(exlen_bin2);
node9=node8+exlen_bin1;
node10=node9+exlen_bin2;
exaux2=exaux(node8+1:node9);
excompress_bits=exaux(node9+1:node10);

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
if T==1
else
    for i=1:T
        for j=1:T
            if excode1(ptr10:ptr10+length(A{1,j})-1)==A{1,j}
                B{1,i}=A{1,j};      %%B{1,1}对应误差为0，B{1,2}对应误差绝对值为1.。。
                ptr10=ptr10+length(A{1,j});
                break;
            end
        end
    end
end
ptr11=1;E=[];
for i=1:length_C2
    for j=1:length_C2
        if excode2(ptr11:ptr11+length(C{1,j})-1)==C{1,j}
            E{1,i}=C{1,j};      %%B{1,1}对应误差为0，B{1,2}对应误差绝对值为1.。。
            ptr11=ptr11+length(C{1,j});
            break;
        end
    end
end
%%HUANYUANXIANGSUZHI
recover_I=stego_I1;
ptr12=1; ptr13=1;
for i=2:row
    for j=2:col
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
            if T ==1
                recover_I(i,j)=PV;
            else
                for k=1:T
                    if excode0(ptr12:ptr12+length(B{1,k})-1)==B{1,k}
                        if k==1
                            ptr12=length(B{1,k})+ptr12;
                            recover_I(i,j)=PV;
                        else
                            if exaux2(ptr13)==1
                                e=k-1;
                            else
                                e=-(k-1);
                            end
                            ptr12=length(B{1,k})+ptr12;
                            ptr13=ptr13+1;
                            recover_I(i,j)=PV+e;
                        end
                        break;
                    end
                end
            end
        else%%Map(i,j)==0
            [bin2_8] = [0 0 0 0 0 0 0 0]; %将十进制整数转换成8位二进制数组
            for k=1:length_C2
                if excode0(ptr12:ptr12+length(E{1,k})-1)==E{1,k}
                    L=k-1;
                    PV=Decimalism_Binary(PV);
                    if L==8
                        bin2_8(1:8)=PV(1:8);
                    elseif L==7
                        bin2_8(1:7)=PV(1:7);
                        bin2_8(8)=~PV(8);
                    elseif L==0
                        bin2_8(1)=~PV(1);
                        bin2_8(2:8)=exaux2(ptr13:ptr13+6);
                        ptr13=ptr13+7;
                    else
                        bin2_8(1:L)=PV(1:L);
                        bin2_8(L+1)=~PV(L+1);
                        bin2_8(L+2:8)=exaux2(ptr13:ptr13+6-L);
                        ptr13=ptr13+7-L;
                    end
                    recover_I(i,j)=Binary_Decimalism(bin2_8);
                    ptr12=length(E{1,k})+ptr12;
                    break;
                end
            end
        end
    end
end