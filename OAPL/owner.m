function [encrypt_I]=owner(origin_I,Image_key)
[row,col] = size(origin_I); %����origin_I������ֵ
max_length=ceil(log2(row))+ceil(log2(col))+3;
%% Ԥ����
[origin_PV_I] = Predictor_Value(origin_I);
%% ����ֵ
T=threshold(origin_I,origin_PV_I);
% T=14;
% T=16;
A=query(T);
if T==0 || T==1
    code1=[];
else
    %% ����Ԥ��������ֵ
    [Map_origin_I] = abs(origin_I-origin_PV_I);
    Map_origin_I=Map_origin_I(2:row,2:col);
    Map_origin_I=Map_origin_I+1;
    hist_Map_origin_I = tabulate([Map_origin_I(:)' T+1]); %ͳ��ÿ�����ֵ������ֵ������
    hist_Map_origin_I = hist_Map_origin_I(1:T,:,:); %0~13
    bbb=sortrows(hist_Map_origin_I,-2);%��������
    %% ��code
    code=zeros(1,T);%ÿ�����ֵ��Ӧ�ı��������code��1��Ϊ���0�ı������Ϊ4���ɽ�һ������A{1,4}��A{1,code��1��}��ʾ����롣
    for i=1:T
        code(bbb(i,1))=i;
    end
    code1=[];
    for i=1:T
        code1(length(code1)+1:length(A{1,code(i)})+length(code1))=A{1,code(i)};
    end
end
% code1=[A{1,code(1)} A{1,code(2)} A{1,code(3)} A{1,code(4)} ...
%     A{1,code(5)} A{1,code(6)} A{1,code(7)} A{1,code(8)} ...
%     A{1,code(9)} A{1,code(10)} A{1,code(11)} A{1,code(12)} A{1,code(13)} A{1,code(14)}];
if T<=15 && T>=8
    C={[0 1],[1 0],[0 0],[1 1 0],[1 1 1]};
elseif T==0
    C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],[0 0 0 0],[1 1 1 1 0],[1 1 1 1 1]};
elseif T<=32 && T>=16
        C={[0 1],[1 0],[0 0],[1 1]};
elseif T<=7 && T>=4
    C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0],[1 1 1]};
elseif T==1
    C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],[0 0 0 0],[1 1 1 1]};
elseif T<=3 && T>=2
    C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0],[1 1 1 0],[1 1 1 1]};
end
length_C=length(C);
Map_origin_I = origin_I-origin_PV_I;
Map=zeros(row,col);%������Ϣ��λ��ͼ
for i=1:row
    for j=1:col
        if i==1 || j==1
            Map(i,j)=-1;
        elseif abs(Map_origin_I(i,j))>=T
            Map(i,j)=0;
        else
            Map(i,j)=1;
        end
    end
end

for i=1:row
    for j=1:col
        if Map(i,j)~=0 %ǰref_x�С�ǰref_y����Ϊ�ο����أ������
            Map_origin_I(i,j) = -1;   
        else
            x = origin_I(i,j); %ԭʼֵ
            pv = origin_PV_I(i,j); %Ԥ��ֵ
            for t=7:-1:0  
                if floor(x/(2^t)) ~= floor(pv/(2^t))
                    ca = 8-t-1; %������¼����ֵ�ı�����
                    break;
                else
                    ca = 8; 
                end
            end
            Map_origin_I(i,j) = ca; %��ʾ��caλMSB��ͬ��������Ƕ��caλ��Ϣ
        end        
    end
end

Map_origin_I=Map_origin_I+2;
hist_Map_origin_I1 = tabulate([Map_origin_I(:)' length_C+2]); %ͳ��ÿ�����ֵ������ֵ������
hist_Map_origin_I1 = hist_Map_origin_I1(2:length_C+1,:,:); %0~13
ccc=sortrows(hist_Map_origin_I1,-2);%��������
Map_origin_I=Map_origin_I-2;
edoc=zeros(1,length_C);%ÿ�����ֵ��Ӧ�ı��������code��1��Ϊ���0�ı������Ϊ4���ɽ�һ������A{1,4}��A{1,code��1��}��ʾ����롣
for i=1:length_C
    edoc(ccc(i,1)-1)=i;
end
% C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],...
%     [0 0 0 0 1],[1 1 1 1 0],[0 0 0 0 0 1]};
code2=[];
for i=1:length_C
    code2(length(code2)+1:length(C{1,edoc(i)})+length(code2))=C{1,edoc(i)};
end

%% ----------------------ѹ��λƽ��----------------------%
[compress_bits,type] = BitPlanes_Compress(Map(2:row,2:col),4,3);
if type==0
    type=[0 0];
elseif type==1
    type=[0 1];
elseif type==2
    type=[1 0];
elseif type==3
    type=[1 1];
end

%% AUX
[Map_origin_I2] = origin_I-origin_PV_I;%���
ptr=1;ptr1=1;aux=[0,0];code0=[0,0];
for i=2:row
    for j=2:col
        [bin2_8] = Decimalism_Binary(origin_I(i,j)); %��ʮ������
        if Map_origin_I(i,j) ~= -1
            k=Map_origin_I(i,j);
            code0(ptr1:length(C{1,edoc(k+1)})+ptr1-1)=C{1,edoc(k+1)}; ptr1=ptr1+length(C{1,edoc(k+1)});
            if k<7
                aux(ptr:ptr+6-k)=bin2_8(k+2:8);
                ptr=ptr+7-k;
            end
        else
            if T==1
                continue;
            else
            code0(ptr1:length(A{1,code(abs(Map_origin_I2(i,j))+1)})+ptr1-1)=[A{1,code(abs(Map_origin_I2(i,j))+1)}]; ptr1=ptr1+length(A{1,code(abs(Map_origin_I2(i,j))+1)});
            if Map_origin_I2(i,j)>0
                aux(ptr)=1; ptr=ptr+1;
            elseif Map_origin_I2(i,j)<0
                aux(ptr)=0; ptr=ptr+1;
            end
            end
        end
    end
end

%% ���㳤��
len_bin0=Decimalism_Binary(length(code0));
len_bin1=Decimalism_Binary(length(aux));
len_bin2=Decimalism_Binary(length(compress_bits));
if length(len_bin0) < max_length
    len = length(len_bin0);
    B = len_bin0;
    len_bin0 = zeros(1,max_length);
    for i=1:len
        len_bin0(max_length-len+i) = B(i); %�洢len_Bin�ĳ�����Ϣ
    end
end
if length(len_bin1) < max_length
    len = length(len_bin1);
    B = len_bin1;
    len_bin1 = zeros(1,max_length);
    for i=1:len
        len_bin1(max_length-len+i) = B(i); %�洢len_Bin�ĳ�����Ϣ
    end
end
if length(compress_bits) >= (row-1)*(col-1)
    len_bin2 = Decimalism_Binary((row-1)*(col-1));Maptemp=Map(2:row,2:col);compress_bits=Maptemp(:)';
end
if length(len_bin2) < max_length
    len = length(len_bin2);
    B = len_bin2;
    len_bin2 = zeros(1,max_length);
    for i=1:len
        len_bin2(max_length-len+i) = B(i); %�洢len_Bin�ĳ�����Ϣ
    end
end
TT=Decimalism_Binary(T);
%% ͳ�ƻָ�ʱ��Ҫ�ĸ�����Ϣ��code0,encrypt_code,len_Bin��encrypt_aux��
Side_Information = [len_bin1,len_bin2,code1,code2,type,aux,compress_bits];
init=zeros(1,ceil(log2(row))+ceil(log2(col)));
bitstream=[init,TT,len_bin0,code0,Side_Information];

% tic
%% λƽ������
ptr2=1;
vacate_I = origin_I;
for i=2:row
    for j=2:col
        value = origin_I(i,j); %ԭʼ����ֵ
        [bin2_8] = Decimalism_Binary(value); %������ֵvalueת����8λ��������
        if ptr2+7>length(bitstream)
            bin2_8(1:length(bitstream)-ptr2+1) = bitstream(ptr2:length(bitstream)); %�滻��Ӧλƽ��ı���ֵ
            ptr2=length(bitstream)+1;
        else
            bin2_8(1:8) = bitstream(ptr2:ptr2+7); %�滻��Ӧλƽ��ı���ֵ
            ptr2=ptr2+8;
        end
        [value] = Binary_Decimalism(bin2_8); %���滻λƽ��Ķ�����ת����ʮ������
        vacate_I(i,j) = value;
        if ptr2>length(bitstream)
            break;
        end
    end
    if ptr2>length(bitstream)
        break;
    end
end
if j==col
    init_j=Decimalism_Binary(1);
    init_i=Decimalism_Binary(i);
else  
    init_j=Decimalism_Binary(j);
    init_i=Decimalism_Binary(i-1);
end
if length(init_i) < ceil(log2(row))
    len = length(init_i);
    B = init_i;
    init_i = zeros(1,ceil(log2(row)));
    for i=1:len
        init_i(ceil(log2(row))-len+i) = B(i); %�洢len_Bin�ĳ�����Ϣ
    end
end
if length(init_j) < ceil(log2(col))
    len = length(init_j);
    B = init_j;
    init_j = zeros(1,ceil(log2(col)));
    for i=1:len
        init_j(ceil(log2(col))-len+i) = B(i); %�洢len_Bin�ĳ�����Ϣ
    end
end
init=[init_i init_j];
%% ��ԭʼͼ��origin_I���г��μ���
[encrypt_I] = Encrypt_Image(vacate_I,Image_key);

ptr3=1;
for j=2:col
    if ptr3>length(init)
        break;
    end
    value = encrypt_I(2,j); %ԭʼ����ֵ
    [bin2_8] = Decimalism_Binary(value); %������ֵvalueת����8λ��������
    if ptr3+7>length(init)
        bin2_8(1:length(init)-ptr3+1) = init(ptr3:length(init)); %�滻��Ӧλƽ��ı���ֵ
        ptr3=length(init)+1;
    else
        bin2_8(1:8) = init(ptr3:ptr3+7); %�滻��Ӧλƽ��ı���ֵ
        ptr3=ptr3+8;
    end
    [value] = Binary_Decimalism(bin2_8); %���滻λƽ��Ķ�����ת����ʮ������
    encrypt_I(2,j) = value;
end
% toc
