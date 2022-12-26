clc
clear
close all
%% 参数初始化
c1 = 1.5;       % 学习因子
c2 = 1.5;
w=0.7;          % 惯性权重
D=10;           % 粒子维度 
maxgen = 100;   % 迭代次数
sizepop = 200;  % 种群大小
Vmax = 0.5;     % 速度的范围
Vmin = -0.5;  
popmax = 5;     % 搜索的范围
popmin = -5;
%% 种群初始化
for i = 1:sizepop
    % 随机产生一个种群
    pop(i,:) = rand(1,D)*10-5;    % 初始化位置
    V(i,:) = 0.5 * rands(1,D);   % 初始化速度
    % 适应度计算
    fitness(i) = fit(pop(i,:));
end
%% 个体极值和群体极值
[bestfitness,bestindex] = max(fitness);   % 默认将第一代的最大适应度值设置为最佳
zbest = pop(bestindex,:);   % 全局最佳
gbest = pop;                % 个体最佳
fitnessgbest = fitness;     % 个体最佳适应度值
fitnesszbest = bestfitness;   % 全局最佳适应度值
%% 迭代寻优
for i = 1:maxgen
       for j = 1:sizepop
        % 速度更新
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));  
        % 速度越界检查
        V(j,find(V(j,:)>Vmax)) = Vmax;   
        V(j,find(V(j,:)<Vmin)) = Vmin;
        % 种群更新
        pop(j,:) = pop(j,:) + V(j,:);
        % 个体范围越界检查
        pop(j,find(pop(j,:)>popmax)) = popmax;
        pop(j,find(pop(j,:)<popmin)) = popmin;
        % 适应度值计算
       fitness(j) = fit(pop(j,:)); 
       end
       for j = 1:sizepop
        % 个体最优更新
        if fitness(j) < fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        % 全局最优更新
        if fitness(j) < fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
       end 
    % 记录每一代的最优值
    yy(i) = fitnesszbest;          
end
%% 输出结果并绘图
[fitnesszbest zbest]
figure
plot(yy)
title('最优个体适应度','fontsize',12);
xlabel('进化代数','fontsize',12);
ylabel('适应度','fontsize',12);

 
