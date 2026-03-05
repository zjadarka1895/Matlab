function [A, b, U, T, w, x, r_norm, iteration_count] = solve_Gauss_Seidel()

N = randi([5000, 9000]);
[A, b] = generate_matrix(N);

max_iter = 1000;
tolerance = 1e-12; 
x = ones(N, 1); 
r_norm = zeros(1, max_iter+1); 
iteration_count = 0;

D = diag(diag(A)); 
L = tril(A, -1);   
U = triu(A, 1);    
T = D + L;       

r_norm(1) = norm(A*x - b);

for k = 1:max_iter
    x_prev = x;
    
    x = T \ (b - U * x_prev);
    
    iteration_count = iteration_count + 1;
    
    r_norm(k+1) = norm(A*x - b);
    
    if r_norm(k+1) < tolerance
        break;
    end
end

r_norm = r_norm(1:iteration_count+1);

w = T \ b;


semilogy(r_norm);
xlabel("Iteracja");
ylabel("Norma residuum");
title("Metoda Gaussa-Seidla");

print('zadanie5.png', '-dpng');
end