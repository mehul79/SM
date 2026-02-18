clc
clear all

c = [-0.01 0.5 0 0];
A = [2 5 1 0; 1 1 0 1];
B = [80; 20];
z = @(x) c*x;

n = size(A,2);
m = size(A,1);
ncm = nchoosek(n,m);
pairs = nchoosek(1:n, m);

basic_sol = [];
basic_f_sol = [];
for i=1:ncm
    basic_index = pairs(i,:);
    y = zeros(n,1);
    X = A(:, basic_index)\B;
    y(basic_index) = X;
    basic_sol = [basic_sol y];
    if (X>=0)
        basic_f_sol = [basic_f_sol y];
       
    end
end


cost = z(basic_f_sol);
[Zmax, idx] = max(cost);

optimal_sol = basic_f_sol(:, idx);

disp("optimal sol");
disp(Zmax);


disp("optimal points");
fprintf("%.2f %.2f", optimal_sol(1), optimal_sol(2));
