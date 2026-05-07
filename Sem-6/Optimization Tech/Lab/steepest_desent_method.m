% 4iterations, X1=[1,1]

format short
clear all
clc

%% Phase 1 - Define objective function
syms x1 x2
f = x1 - x2 + 2*x1^2 + 2*x1*x2 + x2^2;

fx = inline(f);                
fobj = @(x) fx(x(1), x(2));    

%% Phase 2 - Compute gradient
grad = gradient(f);
G = inline(grad);              
gradx = @(x) G(x(1), x(2));    

%% Phase 3 - Compute Hessian Matrix
H1 = hessian(f);
Hx = inline(H1);               

%% Phase 4 - Iterations
x0 = [1 1];        
maxiter = 4;       
tol = 10^(-3);     
iter = 0;          

x = [1; 1];        

while norm(gradx(x0)) > tol && iter < maxiter
    % X = [x; x0];          
    S = -gradx(x0);        
    H = Hx(x0);            
    
    lambda = S' * S / (S' * H * S);   
    
    xnew = x0 + lambda .* S';         
    x0 = xnew;                        
    
    iter = iter + 1;                  
end

%% Phase 5 - Print the solution
fprintf('Optimal Solution X = [%f, %f]\n', x0(1), x0(2))
fprintf('Optimal Value f(x) = %f\n', fobj(x0))