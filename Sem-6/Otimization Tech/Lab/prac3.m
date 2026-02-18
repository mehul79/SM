clc
clear all

c = [2 1];
a = [1 2;1 -1];
b = [10;2];

z = @(x1,x2) 2*x1 + x2;
c1 = @(x1,x2) x1 + 2*x2 - 10;
c2 = @(x1,x2) x1 - x2 - 2;


figure
hold on

x1 = linspace(0,10,400);
for i=1:size(a,1)
    if(a(i,2) ~= 0)
        x2 = (b(i) - a(i,1)*x1)/a(i,2);
        plot(x1,x2, "LineWidth",1.5);
    end
end

yline(0, 'k', "LineWidth",1.5);
xlabel("x1");
ylabel("x2");
title("Feasible");
grid on

A = [a; eye(2)];
B = [b;0;0];
m = size(A,1);
pt = [];

for i=1:m
    for j=i+1:m
        AA = [A(i,:); A(j,:)];
        BB = [B(i); B(j)];
        x = AA\BB;
        pt = [pt x];
    end
end

pt = unique(pt', "rows")';
pt

FP = [];
Z = [];
for i=1:size(pt,2)
    x1 = pt(1,i);
    x2 = pt(2,i);
    if c1(x1,x2) <= 0 && ...
        c2(x1,x2) <= 0 && ...
        x1>=0 && x2>=0
        FP = [FP pt(:,i)];
        Z = [Z z(x1,x2)];
    end
end

FP
Z

[Zmax, idx] = max(Z);
optimal_point = FP(:, idx);

Zmax
optimal_point
    
