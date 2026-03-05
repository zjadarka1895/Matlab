function [N, x_uniform, y_fine_uniform, x_chebyshev, y_fine_chebyshev] = ...
        compare_uniform_vs_chebyshev()

% Porównanie interpolacji funkcji Rungego dla węzłów równomiernych i Czebyszewa.

    N = 16; % liczba węzłów interpolacji

    % Gęsta siatka testowa
    x_fine = linspace(-1, 1, 1000);
    runge_function = @(x) 1 ./ (1 + 25 * x.^2);
    y_fine_reference = runge_function(x_fine);

    % === 1. Węzły równomierne ===
    x_uniform = linspace(-1, 1, N);
   % y_uniform = runge_function(x_uniform);
    y_uniform = runge_function(x_uniform).'; % transpozycja do kolumny
    V_uniform = get_vandermonde_matrix(x_uniform);
    coeff_uniform = V_uniform\y_uniform;
    coeff_uniform = coeff_uniform(end:-1:1); % dla polyval
    y_fine_uniform = polyval(coeff_uniform, x_fine);

    % === 2. Węzły Czebyszewa II rodzaju ===
    x_chebyshev = get_chebyshev_nodes(N); % już jako wektor
   % y_chebyshev = runge_function(x_chebyshev).;
    y_chebyshev = runge_function(x_chebyshev).';

    V_chebyshev = get_vandermonde_matrix(x_chebyshev);
    coeff_chebyshev = V_chebyshev \ y_chebyshev;
    coeff_chebyshev = coeff_chebyshev(end:-1:1);
    y_fine_chebyshev = polyval(coeff_chebyshev, x_fine);

    % === 3. Wykresy ===
    figure;
    subplot(2,1,1);
    plot(x_fine, y_fine_reference, 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on;
    plot(x_fine, y_fine_uniform, 'm', 'LineWidth', 1.5, 'DisplayName', sprintf('Interpolacja (N = %d)', N));
    plot(x_uniform, y_uniform, 'mo', 'DisplayName', 'Węzły interpolacji');
    title('Interpolacja funkcji Rungego - węzły równomierne');
    legend('Location', 'eastoutside');
    xlabel('x');
    ylabel('f(x)');

    subplot(2,1,2);
    plot(x_fine, y_fine_reference, 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on;
    plot(x_fine, y_fine_chebyshev, 'b', 'LineWidth', 1.5, 'DisplayName', sprintf('Interpolacja (N = %d)', N));
    plot(x_chebyshev, y_chebyshev, 'bo', 'DisplayName', 'Węzły interpolacji');
    title('Interpolacja funkcji Rungego - węzły Czebyszewa');
    legend('Location', 'eastoutside');
    xlabel('x');
    ylabel('f(x)');

    set(gcf, 'Position', [100, 100, 1200, 800]);
end

function x = get_chebyshev_nodes(N)
    k = 1:N;
    x = cos((k - 1) * pi / (N - 1));
end


function V = get_vandermonde_matrix(x)
    x = x(:);  
    N = length(x);
    V = zeros(N);
    for i = 1:N
        for j = 1:N
            V(i, j) = x(i)^(j-1);
        end
    end
end