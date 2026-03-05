function [dates, y, rmse_values, M, c_vpa, ya] = calculate_rmse_vpa()
    % W tej funkcji obliczenia wykonywane są na zmiennych vpa, jednakże spośród
    % zwracanych zmiennych tylko c_vpa jest wektorem zmiennych vpa.

    digits(120); % określa liczbę cyfr dziesiętnych w zmiennych vpa

    M = 70; % stopień wielomianu aproksymacyjnego

    load energy_2025

    dates = energy_2025.Germany.Wind.Dates;
    y = energy_2025.Germany.Wind.EnergyProduction;

    % Przycięcie wektora danych ze względu na limit czasu obliczeń 
    trim = 80;
    if numel(y) > trim
        dates = dates(1:trim,1);
        y = y(1:trim,1);
    end

    N = numel(y);
    degrees = [1, N-1];  % krótszy zakres stopni dla RMSE

    x_vpa = linspace(vpa(0), vpa(1), N)';
    y_vpa = vpa(y);

    rmse_values = zeros(numel(degrees),1);

    % Oblicz RMSE dla każdego stopnia
    for i = 1:numel(degrees)
        m = degrees(i);
        c_m = polyfit_qr_vpa(x_vpa, y_vpa, m);  % dopasuj wielomian
        c_m = flipud(c_m);                      
        yi = polyval_vpa(c_m, x_vpa);           
        rmse = sqrt(mean(double((yi - y).^2))); 
        rmse_values(i) = rmse;
    end

    % Aproksymacja wielomianem stopnia M
    c_vpa = polyfit_qr_vpa(x_vpa, y_vpa, M); 
    c_vpa = flipud(c_vpa);
    ya = double(polyval_vpa(c_vpa, x_vpa)); 

    % Wykres
    figure;

    subplot(2,1,1);
    plot(degrees, rmse_values, 'k.-');
    xlabel('Stopień wielomianu');
    ylabel('RMSE');
    title('RMSE aproksymacji w zależności od stopnia wielomianu');
    grid on;

    subplot(2,1,2);
    plot(dates, y, 'bo-', 'DisplayName', 'Dane rzeczywiste');
    hold on;
    plot(dates, ya, 'r-', 'LineWidth', 2, ...
        'DisplayName', sprintf('Aproksymacja M = %d', M));
    xlabel('Data');
    ylabel('Produkcja energii');
    title('Aproksymacja wielomianowa danych produkcji energii');
    legend('Location', 'best');
    grid on;
end

function y = polyval_vpa(coefficients, x)
% Oblicza wartość wielomianu w punktach x dla współczynników coefficients.
% Obliczenia wykonywane są na zmiennych vpa.
% coefficients – wektor współczynników wielomianu w kolejności od najwyższej potęgi
% x – wektor argumentów (zmienne vpa)
% y – wektor wartości wielomianu (zmienne vpa)

    n = length(coefficients);
    y = vpa(zeros(size(x)));  % inicjalizacja wyniku jako vpa

    for i = 1:n
        y = y .* x + coefficients(i);  % schemat Hornera
    end

    
end

function c = polyfit_qr_vpa(x, y, M)
     % Wyznacza współczynniki wielomianu aproksymacyjnego stopnia M
    % z zastosowaniem rozkładu QR.
    % c - kolumnowy wektor współczynników: [c_0; ...; c_M]

    A = vpa(zeros(numel(x), M+1)); % macierz Vandermonde'a
    for k = 0:M
        A(:, k+1) = x.^k;
    end

    [Q, R] = qr(A, 0); % economy QR
    c = R \ (Q' * y);
end