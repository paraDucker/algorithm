function [Non_Dominated_Solutions,Pareto_Front,NFEs,Elapsed_Time]=MOWCA_Unconstrained(objective_function,LB,UB,nvars,Npop,Nsr,dmax,max_it)

% INPUTS:

% objective_function:           Objective functions which you wish to minimize or maximize
% LB:                           Lower bound of a problem
% UB:                           Upper bound of a problem
% nvars:                        Number of design variables
% Npop                          Population size
% Nsr                           Number of rivers + sea
% dmax                          Evporation condition constant
% max_it:                       Maximum number of iterations

% OUTPUTS:

% Non_Dominated_Solutions:      Optimum non-dominated solutions
% Pareto_Front:                 Obtained optimum objective function values
% NFEs:                         Number of function evaluations
% Elapsed_Time                  Elasped time for solving an optimization problem
%% Default Values for MOWCA
format long g
if (nargin <5 || isempty(Npop)), Npop=50; end
if (nargin <6 || isempty(Nsr)), Nsr=4; end
if (nargin <7 || isempty(dmax)), dmax=1e-16; end
if (nargin <8 || isempty(max_it)), max_it=100; end
%% --------------------------------------------------------------------------
% Create initial population
tic
N_stream=Npop-Nsr;
NPF=Npop;    % Pareto Front Archive Size

ind.Position=[];
ind.Cost=[];
ind.Rank=[];
ind.DominationSet=[];
ind.DominatedCount=[];
ind.CrowdingDistance=[];

pop=repmat(ind,Npop,1);

for i=1:Npop
    pop(i).Position=LB+(UB-LB).*rand;
    pop(i).Cost=objective_function(pop(i).Position);
end

[pop, F]=NonDominatedSorting(pop);  % Non-dominated sorting
pop=CalcCrowdingDistance(pop,F);   % Calculate crowding distance
pop=SortPopulation(pop);     % Sort population
%------------- Forming Sea, Rivers, and Streams  --------------------------
sea=pop(1);
river=pop(2:Nsr);
stream=pop(Nsr+1:end);

cs=[sea.CrowdingDistance';[river.CrowdingDistance]';stream(1).CrowdingDistance];

f=0;
if length(unique(cs))~=1
    CN=cs-max(cs);
else
    CN=cs;
    f=1;
end

NS=round(abs(CN/(sum(CN)+eps))*N_stream);

if f~=1
    NS(end)=[];
end
NS=sort(NS,'descend');
% ------------------------- Modification on NS -----------------------
i=Nsr;
while sum(NS)>N_stream
    if NS(i)>1
        NS(i)=NS(i)-1;
    else
        i=i-1;
    end
end

i=1;
while sum(NS)<N_stream
    NS(i)=NS(i)+1;
end

if find(NS==0)
    index=find(NS==0);
    for i=1:size(index,1)
        while NS(index(i))==0
            NS(index(i))=NS(index(i))+round(NS(i)/6);
            NS(i)=NS(i)-round(NS(i)/6);
        end
    end
end

NS=sort(NS,'descend');
NB=NS(2:end);
%%
%----------- Main Loop for MOWCA --------------------------------------------
disp('********** Multi-objective Water Cycle Algorithm (MOWCA)************');
disp('*Iterations         Number of Pareto Front Members *');
disp('********************************************************************');
FF=zeros(max_it,numel(sea.Cost));
for i=1:max_it
    %---------- Moving stream to sea---------------------------------------
    for j=1:NS(1)
        stream(j).Position=stream(j).Position+2.*rand(1).*(sea.Position-stream(j).Position);
        
        stream(j).Position=min(stream(j).Position,UB);
        stream(j).Position=max(stream(j).Position,LB);
        
        stream(j).Cost=objective_function(stream(j).Position);
    end
    %---------- Moving Streams to rivers-----------------------------------
    for k=1:Nsr-1
        for j=1:NB(k)
            stream(j+sum(NS(1:k))).Position=stream(j+sum(NS(1:k))).Position+2.*rand(1,nvars).*(river(k).Position-stream(j+sum(NS(1:k))).Position);
            
            stream(j+sum(NS(1:k))).Position=min(stream(j+sum(NS(1:k))).Position,UB);
            stream(j+sum(NS(1:k))).Position=max(stream(j+sum(NS(1:k))).Position,LB);
            
            stream(j+sum(NS(1:k))).Cost=objective_function(stream(j+sum(NS(1:k))).Position);
        end
    end
    %---------- Moving rivers to Sea --------------------------------------
    for j=1:Nsr-1
        river(j).Position=river(j).Position+2.*rand(1,nvars).*(sea.Position-river(j).Position);
        
        river(j).Position=min(river(j).Position,UB);
        river(j).Position=max(river(j).Position,LB);
        
        river(j).Cost=objective_function(river(j).Position);
    end
    %-------------- Evaporation condition and raining process--------------
    % Check the evaporation condition for rivers and sea
    for k=1:Nsr-1
        if ((norm(river(k).Position-sea.Position)<dmax) || rand<0.1)
            for j=1:NB(k)
                stream(j+sum(NS(1:k))).Position=LB+rand(1,nvars).*(UB-LB);
            end
        end
    end
    % Check the evaporation condition for streams and sea
    for j=1:NS(1)
        if ((norm(stream(j).Position-sea.Position)<dmax))
            stream(j).Position=LB+rand(1,nvars).*(UB-LB);
        end
    end
    %----------------------------------------------------------------------
    pop=[pop;sea;river;stream];
    
    [pop, F]=NonDominatedSorting(pop);  % Non-dominated sorting
    pop=CalcCrowdingDistance(pop,F);   % Calculate crowding distance
    pop=SortPopulation(pop);     % Sort population
    
    pop=pop(1:NPF);
    
    [pop, F]=NonDominatedSorting(pop);  % Non-dominated sorting
    pop=CalcCrowdingDistance(pop,F);   % Calculate crowding distance
    [pop, F]=SortPopulation(pop);     % Sort population
    
    sea=pop(1);river=pop(2:Nsr);stream=pop(Nsr+1:end);
    F1=pop(F{1});
    
    dmax=dmax-(dmax/max_it);
    disp(['Iteration: ',num2str(i),'      ((Number of Members in the Pareto Front)):  ',num2str(numel(F{1}))]);
    FF(i,:)=sea.Cost;
    
    % Plot F1 costs
    figure(1);
    PlotCosts(F1);
    pause(0.01)

end
%% Optimization Results
toc;
Elapsed_Time=toc;
NFEs=Npop*max_it;

k=1;
a=[river.Position stream.Position];
A=zeros(N_stream+Nsr-1,nvars);
for i=1:N_stream+Nsr-1
    A(i,:)=a(1,k:i*nvars);
    k=k+nvars;
end
Non_Dominated_Solutions=[sea.Position;A];

b=[[river.Cost]';[stream.Cost]'];
Pareto_Front=[sea.Cost';b];

end
