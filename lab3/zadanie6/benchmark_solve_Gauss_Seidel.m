function [A, b, x, vec_loop_times, vec_iteration_count] = benchmark_solve_Gauss_Seidel(vN)

% Inicjalizacja zmiennych wyjściowych
vec_loop_times = zeros(1, length(vN));
vec_iteration_count = zeros(1, length(vN));
A = cell(1, length(vN));
b = cell(1, length(vN));
x = cell(1, length(vN));

for i = 1:length(vN)
    N = vN(i);
    
    % Generowanie macierzy i wektora
    [A{i}, b{i}] = generate_matrix(N);
    
    % Dekompozycja macierzy (poza pomiarem czasu)
    D = diag(diag(A{i}));
    L = tril(A{i}, -1);
    U = triu(A{i}, 1);
    T = D + L;
    
    % Inicjalizacja zmiennych metody
    x_prev = ones(N, 1);
    x{i} = x_prev;
    iteration_count = 0;
    tolerance = 1e-12;
    
    % Pomiar czasu tylko dla pętli iteracyjnej
    tic;
    while true
        % Obliczenie nowego przybliżenia
        x{i} = T \ (b{i} - U * x_prev);
        
        iteration_count = iteration_count + 1;
        
        % Sprawdzenie warunku stopu
        current_residuum = norm(A{i}*x{i} - b{i});
        if current_residuum < tolerance || iteration_count >= 1000
            break;
        end
        
        x_prev = x{i};
    end
    vec_loop_times(i) = toc;
    vec_iteration_count(i) = iteration_count;
end

% Generowanie wykresów
figure;

% Wykres górny - czas obliczeń
subplot(2,1,1);
    plot(vN, vec_loop_times);
    title("Czas obliczeń");
    xlabel("Rozmiar macierzy");
    ylabel("Czas");

    subplot(2,1,2);
    plot(vN, vec_iteration_count);
    title("Liczba iteracji");
    xlabel("Rozmiar macierzy");
    ylabel("Liczba iteracji");

% Zapis wykresu do pliku
print('zadanie6.png', '-dpng');
end