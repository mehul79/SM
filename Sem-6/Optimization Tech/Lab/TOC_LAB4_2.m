clc
clear all
%% Phase-1: input parameter
C = [3 -5 0 0];
z = @(X) C*X;
b = [6;-9];
A = [1 1 1 0;
    -2 1 0 1];

%% Phase-2: choose and form BV pairs
m = size(A,1);
n = size(A,2);
ncm = nchoosek(n,m);
pairs = nchoosek(1:n,m);

%% Phase-3: BFS
basic_sol = [];
basic_f_sol = [];
for i=1:ncm
    basic_index = pairs(i,:);
    y = zeros(n,1);
    X = A(:,basic_index)\b;
    y(basic_index) = X;
    basic_sol = [basic_sol y];
    if(X>=0)
        basic_f_sol = [basic_f_sol y];
    end
end

%% Phase-4: solution
disp("basic solutions")
disp(basic_sol);
disp("basic feasible solutions")
disp(basic_f_sol);
cost = z(basic_f_sol);
[optimal_val, index] = min(cost);
optimal_solution = basic_f_sol(:,index);

disp("Optimal Solution");
disp(optimal_solution);
