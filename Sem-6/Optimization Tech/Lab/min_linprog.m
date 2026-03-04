clc
clear

% Objective function (Minimize Z = 3x1 - 5x2)
f = [3 -5];

% Inequality constraints A*x <= b
A = [ 1  1;
     -2  1;
      1  2];

b = [6;
    -9;
     6];

% Lower bounds (x1 >= 0, x2 >= 0)
lb = [0 0];

% Solve using linprog
[x_opt, z_opt] = linprog(f, A, b, [], [], lb);

% Display results
disp('Optimal Solution:')
disp(x_opt)

disp('Minimum Value of Z:')
disp(z_opt)
