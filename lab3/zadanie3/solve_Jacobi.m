function [A,b,M,w,x,r_norm,iteration_count] = solve_Jacobi()
% A - macierz z równania macierzowego A * x = b
% b - wektor prawej strony równania macierzowego A * x = b
% M - macierz pomocnicza opisana w instrukcji do Laboratorium 3
%       – sprawdź wzór (5) w instrukcji, który definiuje M jako M_J.
% w - wektor pomocniczy opisany w instrukcji do Laboratorium 3
%       – sprawdź wzór (5) w instrukcji, który definiuje w jako w_J.
% x - rozwiązanie równania macierzowego wyznaczone metodą Jacobiego
% r_norm - wektor norm residuum kolejnych przybliżeń rozwiązania; 
%       – r_norm(i) jest równy norm(A*x-b), gdzie x stanowi i-te przybliżenie rozwiązania
%       - r_norm(1) = norm(A*ones(N,1)-b)
% iteration_count - liczba iteracji wymagana do wyznaczenia rozwiązania
%       metodą Jacobiego
N =5000; 
[A,b] = generate_matrix(N);
L = tril(A, -1); 
U = triu(A, 1);  
D = diag(diag(A));
M = -D\(L+U);
w = D\b;
x = ones(N,1);
r_norm = [];


inorm = norm(A*x-b);
r_norm = inorm;
iteration_count=0;
while(inorm>1e-12 && iteration_count<1000)
    x = M*x + w;
    inorm = norm(A*x-b);
    iteration_count = iteration_count+1;
    r_norm = [ r_norm, inorm ];
end
%plot(r_norm);
semilogy(r_norm);
xlabel("Iteracja");
ylabel("Norma residuum");
title("Metoda Jacobiego");

end