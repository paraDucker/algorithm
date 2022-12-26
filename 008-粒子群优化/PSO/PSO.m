clc
clear
close all
%% ������ʼ��
c1 = 1.5;       % ѧϰ����
c2 = 1.5;
w=0.7;          % ����Ȩ��
D=10;           % ����ά�� 
maxgen = 100;   % ��������
sizepop = 200;  % ��Ⱥ��С
Vmax = 0.5;     % �ٶȵķ�Χ
Vmin = -0.5;  
popmax = 5;     % �����ķ�Χ
popmin = -5;
%% ��Ⱥ��ʼ��
for i = 1:sizepop
    % �������һ����Ⱥ
    pop(i,:) = rand(1,D)*10-5;    % ��ʼ��λ��
    V(i,:) = 0.5 * rands(1,D);   % ��ʼ���ٶ�
    % ��Ӧ�ȼ���
    fitness(i) = fit(pop(i,:));
end
%% ���弫ֵ��Ⱥ�弫ֵ
[bestfitness,bestindex] = max(fitness);   % Ĭ�Ͻ���һ���������Ӧ��ֵ����Ϊ���
zbest = pop(bestindex,:);   % ȫ�����
gbest = pop;                % �������
fitnessgbest = fitness;     % ���������Ӧ��ֵ
fitnesszbest = bestfitness;   % ȫ�������Ӧ��ֵ
%% ����Ѱ��
for i = 1:maxgen
       for j = 1:sizepop
        % �ٶȸ���
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));  
        % �ٶ�Խ����
        V(j,find(V(j,:)>Vmax)) = Vmax;   
        V(j,find(V(j,:)<Vmin)) = Vmin;
        % ��Ⱥ����
        pop(j,:) = pop(j,:) + V(j,:);
        % ���巶ΧԽ����
        pop(j,find(pop(j,:)>popmax)) = popmax;
        pop(j,find(pop(j,:)<popmin)) = popmin;
        % ��Ӧ��ֵ����
       fitness(j) = fit(pop(j,:)); 
       end
       for j = 1:sizepop
        % �������Ÿ���
        if fitness(j) < fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        % ȫ�����Ÿ���
        if fitness(j) < fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
       end 
    % ��¼ÿһ��������ֵ
    yy(i) = fitnesszbest;          
end
%% ����������ͼ
[fitnesszbest zbest]
figure
plot(yy)
title('���Ÿ�����Ӧ��','fontsize',12);
xlabel('��������','fontsize',12);
ylabel('��Ӧ��','fontsize',12);

 
