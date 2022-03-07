function [Plane_Matrix] = BitPlanes_Recover(Plane_bits,Block_size,type,row,col)
% ����˵��������BMPR�㷨����̽��������ָ���λƽ�����
% ���룺Plane_bits��λƽ���������,Block_size���ֿ��С��,type�������з�ʽ��,row,col���������������
% �����Plane_Matrix��λƽ�����

Plane_Matrix = zeros(row,col);
m = floor(row/Block_size); 
n = floor(col/Block_size);
num = 0; %����
%-------------------�ֿ��ڰ��б������ֿ�䰴�б�������-�У�------------------%
if type==0 %0��00
    for i=1:m  %�ֿ�֮�䰴�б���
        for j=1:n
            begin_x = (i-1)*Block_size+1; %��Ӧ�ֿ����ʼ����
            begin_y = (j-1)*Block_size+1;
            end_x = i*Block_size; %��Ӧ�ֿ�Ľ�������
            end_y = j*Block_size;
            for x=begin_x:end_x  %�ֿ�֮�ڰ��б���
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end 
        end
        if col-n*Block_size>=1  %��ʣ����
            begin_y = n*Block_size+1;
            end_y = col;
            for x=begin_x:end_x  %�ֿ�֮�ڰ��б���
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end
        end  
    end
    if row-m*Block_size>=1 %��ʣ����
        begin_x = m*Block_size+1; 
        end_x = row;
        for j=1:n
            begin_y = (j-1)*Block_size+1;
            end_y = j*Block_size;
            for x=begin_x:end_x  %�ֿ�֮�ڰ��б���
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end  
        end  
    end
    if row-m*Block_size>=1 && col-n*Block_size>=1 %����ʣ������
        begin_x = m*Block_size+1;
        begin_y = n*Block_size+1;
        end_x = row;
        end_y = col;
        for x=begin_x:end_x  %�ֿ�֮�䰴�б���
            for y=begin_y:end_y
                num = num+1;
                Plane_Matrix(x,y) = Plane_bits(num);
            end
        end  
    end
%-------------------�ֿ��ڰ��б������ֿ�䰴�б�������-�У�------------------%
elseif type==1 %1��01
    for j=1:n  %�ֿ�֮�䰴�б���
        for i=1:m
            begin_x = (i-1)*Block_size+1; %��Ӧ�ֿ����ʼ����
            begin_y = (j-1)*Block_size+1;
            end_x = i*Block_size; %��Ӧ�ֿ�Ľ�������
            end_y = j*Block_size;
            for x=begin_x:end_x  %�ֿ�֮�ڰ��б���
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end 
        end
        if row-m*Block_size>=1  %��ʣ����
            begin_x = m*Block_size+1;
            end_x = row;
            for x=begin_x:end_x  %�ֿ�֮�ڰ��б���
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end
        end  
    end
    if col-n*Block_size>=1 %��ʣ����
        begin_y = n*Block_size+1; 
        end_y = col;
        for i=1:m
            begin_x = (i-1)*Block_size+1;
            end_x = i*Block_size;
            for x=begin_x:end_x  %�ֿ�֮�ڰ��б���
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end  
        end  
    end
    if row-m*Block_size>=1 && col-n*Block_size>=1 %����ʣ������
        begin_x = m*Block_size+1;
        begin_y = n*Block_size+1;
        end_x = row;
        end_y = col;
        for x=begin_x:end_x  %�ֿ�֮�䰴�б���
            for y=begin_y:end_y
                num = num+1;
                Plane_Matrix(x,y) = Plane_bits(num);
            end
        end  
    end
%-------------------�ֿ��ڰ��б������ֿ�䰴�б�������-�У�------------------%
elseif type==2 %2��10
    for i=1:m  %�ֿ�֮�䰴�б���
        for j=1:n
            begin_x = (i-1)*Block_size+1; %��Ӧ�ֿ����ʼ����
            begin_y = (j-1)*Block_size+1;
            end_x = i*Block_size; %��Ӧ�ֿ�Ľ�������
            end_y = j*Block_size; 
            for y=begin_y:end_y  %�ֿ�֮�ڰ��б���
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end 
        end
        if col-n*Block_size>=1  %��ʣ����
            begin_y = n*Block_size+1;
            end_y = col;
            for y=begin_y:end_y  %�ֿ�֮�ڰ��б���
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end 
        end  
    end
    if row-m*Block_size>=1 %��ʣ����
        begin_x = m*Block_size+1; 
        end_x = row;
        for j=1:n
            begin_y = (j-1)*Block_size+1;
            end_y = j*Block_size;
            for y=begin_y:end_y  %�ֿ�֮�ڰ��б���
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end   
        end  
    end
    if row-m*Block_size>=1 && col-n*Block_size>=1 %����ʣ������
        begin_x = m*Block_size+1;
        begin_y = n*Block_size+1;
        end_x = row;
        end_y = col;
        for y=begin_y:end_y  %�ֿ�֮�ڰ��б���
            for x=begin_x:end_x  
                num = num+1;
                Plane_Matrix(x,y) = Plane_bits(num);
            end
        end   
    end
%-------------------�ֿ��ڰ��б������ֿ�䰴�б�������-�У�------------------%
else %type==3��3��11
    for j=1:n  %�ֿ�֮�䰴�б���
        for i=1:m
            begin_x = (i-1)*Block_size+1; %��Ӧ�ֿ����ʼ����
            begin_y = (j-1)*Block_size+1;
            end_x = i*Block_size; %��Ӧ�ֿ�Ľ�������
            end_y = j*Block_size;
            for y=begin_y:end_y  %�ֿ�֮�ڰ��б���
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end  
        end
        if row-m*Block_size>=1  %��ʣ����
            begin_x = m*Block_size+1;
            end_x = row;
            for y=begin_y:end_y  %�ֿ�֮�ڰ��б���
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end
        end  
    end
    if col-n*Block_size>=1 %��ʣ����
        begin_y = n*Block_size+1; 
        end_y = col;
        for i=1:m
            begin_x = (i-1)*Block_size+1;
            end_x = i*Block_size;
            for y=begin_y:end_y  %�ֿ�֮�ڰ��б���
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end  
        end  
    end
    if row-m*Block_size>=1 && col-n*Block_size>=1 %����ʣ������
        begin_x = m*Block_size+1;
        begin_y = n*Block_size+1;
        end_x = row;
        end_y = col;
        for y=begin_y:end_y  %�ֿ�֮�ڰ��б���
            for x=begin_x:end_x  
                num = num+1;
                Plane_Matrix(x,y) = Plane_bits(num);
            end
        end  
    end 
end