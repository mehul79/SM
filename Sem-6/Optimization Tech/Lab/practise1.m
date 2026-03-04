clc
clear
close all

%% Phase-1 (Problem Definition)

c = [2 5];
a = [1 2;
     1 1];
b = [6;4];

z  = @(x1,x2) 2*x1 + 5*x2;
c1 = @(x1,x2) x1 + 2*x2 - 6;
c2 = @(x1,x2) x1 + x2 - 4;

%% Phase-2 (Plot Constraints)

figure
hold on
x1 = linspace(0,10,400);

for i = 1:size(a,1)
    if a(i,2) ~= 0
        x2 = (b(i) - a(i,1)*x1)/a(i,2);
        plot(x1,x2,'LineWidth',1.5)
    else
        xline(b(i)/a(i,1),'LineWidth',1.5)
    end
end

yline(0,'k','LineWidth',1.5)
xline(0,'k','LineWidth',1.5)

xlabel('x1')
ylabel('x2')
title('LPP using Graphical Method (>= Constraints)')
grid on

%% Phase-3 (Find All Intersection Points)

pt = [];
A = [a; eye(2)];
B = [b; 0; 0];
m = size(A,1);

for i = 1:m
    for j = i+1:m
        AA = [A(i,:); A(j,:)];
        BB = [B(i); B(j)];
        x = AA \ BB;
        pt = [pt x];
    end
end

%% Phase-4 (Find Feasible Points)

pt = unique(pt','rows')';
FP = [];
Z  = [];

for i = 1:size(pt,2)
    
    x1 = pt(1,i);
    x2 = pt(2,i);
    
    if c1(x1,x2) >= 0 && ...
       c2(x1,x2) >= 0 && ...
       x1 >= 0 && x2 >= 0
        
        FP = [FP [x1; x2]];
        Z  = [Z z(x1,x2)];
        
        plot(x1,x2,'*r','MarkerSize',10)
    end
end

hold off

%% Phase-5 (Check Optimal Value)

if isempty(Z)
    disp('No feasible solution')
else
    [Zmax, idx] = max(Z);
    optimal_point = FP(:,idx);
    
    fprintf('Feasible Points:\n')
    disp(FP')
    
    fprintf('Objective Values:\n')
    disp(Z')
    
    fprintf('Optimal Point: (%.2f , %.2f)\n',optimal_point(1),optimal_point(2))
    fprintf('Maximum Value: %.2f\n',Zmax)
end
