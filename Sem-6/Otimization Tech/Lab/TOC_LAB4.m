clc 
clear all
clear figure
% Input Parameters 
c=[6,5,0,0];
a=[1 1 1 0 ; 3 2 0 1];
b=[5;12];
z=@(x) c*x;
% m no. of constraints and n is no. of variables in standard form
m=size(a,1)
n=size(a,2)

% Phase 2 (find basic solution and basic feasible solutions 
basicsol=[];
basicfsol=[];
ncm=nchoosek(n,m)
pair=nchoosek(1:n,m)
for i=1:ncm
    basic_var_index=pair(i,:)
    y=zeros(n,1);
    x=a(:,basic_var_index)\b;
    y(basic_var_index)=x;
    basicsol=[basicsol y];
    if(x>=0)
        basicfsol = [basicfsol y]; % Store basic feasible solution
    end
end
disp(basicsol)
disp(basicfsol)

% Phase 3 (Optimal Solution and Optimal Value ) 
cost= z(basicfsol)
[optimal_val index]=max(cost)
optimal_solution = basicfsol(:, index);
disp('Optimal Solution:');
disp(optimal_solution);

