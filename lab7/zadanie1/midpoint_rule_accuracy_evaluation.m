function [ft_5, integral_1000, Nt, integration_error] = midpoint_rule_accuracy_evaluation()
    % Funkcja służy do numerycznego obliczania całki oznaczonej metodą prostokątów
    % (wariant z punktem środkowym) z funkcji gęstości prawdopodobieństwa awarii
    % urządzenia elektronicznego. Jej celem jest porównanie dokładności obliczeń
    % w zależności od liczby zastosowanych podprzedziałów całkowania.
    %
    % ft_5 – wartość funkcji gęstości prawdopodobieństwa obliczona dla t = 5.
    %
    % integral_1000 – przybliżona wartość całki oznaczonej na przedziale [0, 5]
    %   wyznaczona metodą prostokątów dla liczby podprzedziałów wynoszącej 1000.
    %
    % integration_error – wektor zawierający błędy bezwzględne numerycznego
    %   wyznaczenia wartości całki oznaczonej. Wartość integration_error(1,i)
    %   oznacza błąd obliczenia całki dla Nt(1,i) podprzedziałów:
    %   integration_error(1, i) = abs(integral_approximation - reference_value),
    %   gdzie reference_value to wzorcowa wartość całki.
    %
    % Nt – wektor wierszowy zawierający liczby podprzedziałów całkowania,
    %   dla których wyznaczane są przybliżenia całki i obliczany jest błąd.
    
    reference_value = 0.0473612919396179; % wartość wzorcowa całki

    ft_5 = failure_density_function(5); % wartość funkcji dla t = 5

    N = 1000; % liczba podprzedziałów
    x = linspace(0,5,N+1);
    integral_1000 = midpoint_rule(x);

    Nt = 5:50:10000;
    integration_error = zeros(1, length(Nt));

    for i = 1:length(Nt)
        N_local = Nt(i);
        x_local = linspace(0, 5, N_local + 1); % N+1 punktów
        integration_result = midpoint_rule(x_local);
        integration_error(i) = abs(integration_result - reference_value);
    end

    % Wykres w skali log-log
    figure;
    loglog(Nt, integration_error, 'b-o');
    grid on;
    xlabel('Liczba podprzedziałów Nt');
    ylabel('Błąd całkowania');
    title('Dokładność metody prostokątów (punkt środkowy)');
end

function integral_approximation = midpoint_rule(x)
    delta_x = x(2) - x(1);
    midpoints = (x(1:end-1) + x(2:end)) / 2;
    integral_approximation = sum(failure_density_function(midpoints)) * delta_x;
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
