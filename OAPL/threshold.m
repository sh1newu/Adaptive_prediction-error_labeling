function [T]=threshold(origin_I,origin_PV_I)
[row,col] = size(origin_I); %计算origin_I的行列值
T=zeros(1,33);
for z=0:1:16
    if z==0 || z==1
    else
       %% 计算预测误差绝对值
        [Map_origin_I] = abs(origin_I-origin_PV_I);
        Map_origin_I=Map_origin_I(2:row,2:col);
        Map_origin_I=Map_origin_I+1;
        hist_Map_origin_I = tabulate([Map_origin_I(:)' z+1]); %统计每个误差值（绝对值）个数
        hist_Map_origin_I = hist_Map_origin_I(1:z,:,:); %0~13
        bbb=sortrows(hist_Map_origin_I,-2);%降序排列
        %% 求code
        code=zeros(1,z);%每个误差值对应的编码次序，如code（1）为误差0的编码次序，为4，可进一步调用A{1,4}或A{1,code（1）}表示其编码。
        for i=1:z
            code(bbb(i,1))=i;
        end
    end
    [A,len1]=query(z);
    if z<=15 && z>=8
        C={[0 1],[1 0],[0 0],[1 1 0],[1 1 1]};len2=12;
    elseif z==0
        C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],[0 0 0 0],[1 1 1 1 0],[1 1 1 1 1]};len2=32;
    elseif z<=32 && z>=16
        C={[0 1],[1 0],[0 0],[1 1]};len2=8;
    elseif z<=7 && z>=4
        C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0],[1 1 1]};len2=16;
    elseif z==1
        C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],[0 0 0 0],[1 1 1 1]};len2=26;
    elseif z<=3 && z>=2
        C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0],[1 1 1 0],[1 1 1 1]};len2=21;
    end
    length_C=length(C);
    Map_origin_I=origin_I-origin_PV_I;% 备份
    Map=zeros(row,col);%辅助信息，位置图
    for i=1:row
        for j=1:col
            if i==1 || j==1
                Map(i,j)=-1;
            elseif abs(Map_origin_I(i,j))>=z
                Map(i,j)=0;
            else
                Map(i,j)=1;
            end
        end
    end
    %标签图
    for i=1:row
        for j=1:col
            if Map(i,j)~=0 %前ref_x行、前ref_y列作为参考像素，不标记
                Map_origin_I(i,j) = -1;
            else
                x = origin_I(i,j); %原始值
                pv = origin_PV_I(i,j); %预测值
                for t=7:-1:0
                    if floor(x/(2^t)) ~= floor(pv/(2^t))
                        ca = 8-t-1; %用来记录像素值的标记类别
                        break;
                    else
                        ca = 8;
                    end
                end
                Map_origin_I(i,j) = ca; %表示有ca位MSB相同，即可以嵌入ca位信息
            end
        end
    end
    Map_origin_I=Map_origin_I+2;
    hist_Map_origin_I1 = tabulate([Map_origin_I(:)' length_C+2]); %统计每个误差值（绝对值）个数
    hist_Map_origin_I1 = hist_Map_origin_I1(2:length_C+1,:,:); %0~13
    ccc=sortrows(hist_Map_origin_I1,-2);%降序排列
    Map_origin_I=Map_origin_I-2;
    edoc=zeros(1,length_C);%每个误差值对应的编码次序，如code（1）为误差0的编码次序，为4，可进一步调用A{1,4}或A{1,code（1）}表示其编码。
    for i=1:length_C
        edoc(ccc(i,1)-1)=i;
    end
    rtp=1;v=0;
    for i=2:row
        for j=2:col
            if Map_origin_I(i,j) ~= -1
                k=Map_origin_I(i,j);
                if k>=7
                    v=v+8-length(C{1,edoc(k+1)});
                else
                    rtp=rtp+7-k;
                    v=v+8-length(C{1,edoc(k+1)});
                end
            end
        end
    end
    sign=v-rtp+1;
    %% 替换
    count=0;
    Map_origin_I=origin_I-origin_PV_I;%误差
    for i=2:row
        for j=2:col
            if Map(i,j)==1
                if z==1
                    count=count+8;
                else
                if Map_origin_I(i,j)==0
                    count=count+8-length(A{1,code(1)});
                elseif Map_origin_I(i,j)>0
                    count=count+7-length(A{1,code(Map_origin_I(i,j)+1)});
                else
                    count=count+7-length(A{1,code(abs(Map_origin_I(i,j))+1)});
                end
                end
            end
        end
    end
    %% ----------------------压缩位平面----------------------%
    [compress_bits,~] = BitPlanes_Compress(Map(2:row,2:col),4,3);
    LC=length(compress_bits);
    if LC >= (row-1)*(col-1)
        LC = (row-1)*(col-1);
    end
    T(z+1)=sign+count-LC-len1-len2;
end
[~,T]=max(T);
T=T-1;