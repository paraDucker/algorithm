clc;
clear;
close all;
global Factual nvars
%% FON (多目标基准函数)
nvars=8;                    % 决策变量个数
objective_function=@FON;
LB=ones(1,nvars)*-2;
UB=ones(1,nvars)*2;
% --------- Pareto最优前沿面 ----------------
X=[(-1/sqrt(8)):(0.0001/sqrt(8)):(1/sqrt(8))]';
Xactual=repmat(X,1,nvars);
for i=1:length(X)
    Factual(i,:)=objective_function(Xactual(i,:));
end
%% -------------------------- MOWCA ---------------------------------------
[Non_Dominated_Solutions,Pareto_Front,Used_NFEs,Elapsed_Time]=MOWCA_Unconstrained(objective_function,LB,UB,nvars);
% -------画最终结果图 ---------
plot(Pareto_Front(:,1),Pareto_Front(:,2),'ro','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k',...
    'MarkerSize',4);
hold on
plot(Factual(:,1),Factual(:,2),'Color','blue','LineWidth',2)
legend('Obtained PF','Optimal PF');
hold off