clc
clear all

c = [3 -5];
a = [1 1;2 -1];
b = [6; 9];

z = @(x1,x2) 3*x1 -5*x2;
c1 = @(x1,x2) x1+x2-6;
c2 = @(x1,x2) 2*x1-x2-9;


figure
hold on
x1 = linspace(0,10,400);

for i=1:size(a,1)
    if(a(i,2) ~= 0)
        x2 = (b(i)-a(i,1)*x1)/a(i,2);
        plot(x1,x2, 'LineWidth',1.5);
    else
        x_val = b(i)/a(i,1);
        xline(x_val, 'LineWidth',1.5);
    end
end

yline(0, 'k', 'LineWidth',1.5);
xlabel("x1");
ylabel("x2");
title("Feasible Region");
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

pt = unique(pt', 'rows')';
FP = [];
Z = [];

pt

for i=1:size(pt,2)
    x1 = pt(1,i);
    x2 = pt(2,i);
    if c1(x1,x2) <= 0 && ...
        c2(x1,x2) <= 0 && ...
        x1>=0 && x2>=0
        FP = [FP pt(:,i)];
        Z = [Z z(x1,x2)];
        plot(x1,x2,'*r','MarkerSize',10);
    end
end

hold off

FP
Z


[Zmin, idx] = min(Z);
optimal_point = FP(:, idx);

optimal_point
Zmin