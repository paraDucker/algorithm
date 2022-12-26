function PlotCosts(pop)

global Factual

Costs=[pop.Cost];

plot(Costs(1,:),Costs(2,:),'r*','MarkerSize',8);
hold on
plot(Factual(:,1),Factual(:,2),'Color','blue','LineWidth',2);
legend('Obtained PF','Optimal PF');
hold off

xlabel('F_1 ');
ylabel('F_2 ');
grid on;

end