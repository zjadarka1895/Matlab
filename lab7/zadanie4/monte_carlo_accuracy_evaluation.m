function [ft_5, yrmax, Nt, xr, yr, integration_error] = monte_carlo_accuracy_evaluation()
    % Numeryczne całkowanie metodą Monte Carlo.
    reference_value = 0.0473612919396179; % wartość referencyjna całki
    ft_5 = failure_density_function(5);   % wartość funkcji dla t = 5

    xmax = 5;                             % przedział całkowania: [0, 5]
    yrmax = 0.06;                         % maksymalna wartość funkcji w [0,5]

    Nt = 5:50:10000;                      % liczba próbek
    integration_error = zeros(1, length(Nt));
    xr = cell(1, length(Nt));
    yr = cell(1, length(Nt));

    for i = 1:length(Nt)
        N_local = Nt(i);
        [integral_result, x_points, y_points] = monte_carlo_integral(N_local, xmax, yrmax);
        integration_error(i) = abs(integral_result - reference_value);

        xr{1, i} = x_points;
        yr{1, i} = y_points;
    end

    figure;
    loglog(Nt, integration_error);
    grid on;
    xlabel('Liczba losowań Nt');
    ylabel('Błąd całkowania');
    title('Dokładność metody Monte Carlo');

end


function [integral_approximation, x, y] = monte_carlo_integral(N, xmax, ymax)
    % Oblicza przybliżoną wartość całki oznaczonej z funkcji gęstości
    % prawdopodobieństwa (failure_density_function) przy użyciu
    % metody Monte Carlo.
    %
    % N – liczba losowanych punktów
    % xmax – koniec przedziału całkowania [0, xmax]
    % ymax – górna granica wartości funkcji w przedziale [0, xmax]
    %        (musi spełniać warunek ymax ≥ max(f(x)))
    % integral_approximation – przybliżona wartość całki
    % x – wektor wierszowy o długości N z wylosowanymi wartościami x z [0, xmax]
    % y – wektor wierszowy o długości N z wylosowanymi wartościami y z [0, ymax]
    x = rand(1, N) * xmax;
    y = rand(1, N) * ymax;

    f_x = failure_density_function(x);

    N1 = sum(y <= f_x);

    integral_approximation = xmax*ymax*N1/N;
end

function ft = failure_density_function(t)
    % Zwraca wartości funkcji gęstości prawdopodobieństwa wystąpienia awarii
    % urządzenia elektronicznego dla zadanych wartości czasu t.
    %
    % t – wektor wartości czasu (wyrażonych w latach), dla których obliczane
    %   są wartości funkcji gęstości prawdopodobieństwa.
    %
    % ft – wektor zawierający wartości funkcji gęstości prawdopodobieństwa
    %      odpowiadające kolejnym elementom wektora t.

    ft = 1 / (3 * sqrt(2*pi)) * exp(-((t - 10).^2) / (2 * 3^2));
end
