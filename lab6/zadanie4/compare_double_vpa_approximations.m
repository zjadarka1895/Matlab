function [dates, y, M, x_fine, c, ya, c_vpa, yv] = compare_double_vpa_approximations()
% function [dates, y, rmse_values, M, c, ya] = calculate_rmse()
% 1) Wyznacza pierwiastek błędu średniokwadratowego w zależności od stopnia
%    aproksymacji wielomianowej danych przedstawiających produkcję energii.
% 2) Wyznacza i przedstawia na wykresie aproksymację wielomianową wysokiego
%    stopnia danych przedstawiających produkcję energii.
    digits(120); % określa liczbę cyfr dziesiętnych w zmiennych vpa

    M = 90; % stopień wielomianu aproksymacyjnego (dla wykresu)

    load energy_2025

    dates = energy_2025.Germany.Wind.Dates;
    y = energy_2025.Germany.Wind.EnergyProduction;

    N = numel(y);
    degrees = 1:N-1;
    
    x_vpa = linspace(vpa(0),vpa(1),N)';
    x = double(x_vpa);

        % siatka gęsta
    nodes = 4; % określa stopień zagęszczenia siatki gęstej
    x_fine_vpa = linspace(vpa(0),vpa(1),(N-1)*nodes+1)';
    x_fine = double(x_fine_vpa);

    rmse_values = zeros(numel(degrees), 1);

    % Oblicz RMSE dla każdego stopnia

    % Aproksymacja wielomianem stopnia M (dla wykresu danych)
    c = polyfit_qr(x, y, M);
    c = c(end:-1:1); % dopasuj do polyval
    ya = polyval(c, x_fine);
    
    y_vpa = vpa(y);
    
    c_vpa = polyfit_qr_vpa(x_vpa, y_vpa, M);
    c_vpa = c_vpa(end:-1:1); % odwrócenie kolejności wektora c: dostosowanie do polyval
    yv = double(polyval_vpa(c_vpa, x_fine_vpa));
    
    % Wykres danych rzeczywistych i aproksymacji
       % Tworzenie jednego okna graficznego z dwoma wykresami
    ymax = max(y)*2;
    ymin = -0.25*ymax;
    ax = axis;
    ax(3) = ymin;
    ax(4) = ymax;
    axis(ax)
    % --- WYKRES 1: double---
    subplot(3,1,1);
    plot(dates, y, 'k.-');
    hold on;
    if M > 0
        plot(linspace(dates(1), dates(end), length(x_fine)), ya, 'r-', 'LineWidth', 2, ...
             'DisplayName', sprintf('Aproksymacja M=%d', M));
    end
    xlabel('Daty');
    ylabel('Aproksymacja double');
    title('Aproksymacja w zależności od precyzji');
    ylim([ymin, ymax]);
    grid on;

    % --- WYKRES 2: vpa---
    subplot(3,1,2);
    plot(dates, y, 'bo-', 'DisplayName', 'Dane rzeczywiste');
    hold on;
    if M > 0
        plot(linspace(dates(1), dates(end), length(x_fine)), yv, 'r-', 'LineWidth', 2, ...
             'DisplayName', sprintf('Aproksymacja M=%d', M));
    end
    xlabel('Data');
    ylabel('Aproksymacja vpa');
    title('Aproksymacja wielomianowa vpa');
    legend('Location', 'best');
    ylim([ymin, ymax]);

    grid on;

    % --- WYKRES 3: Zakres wartości współczynników ---
    subplot(3,1,3);
    plot_c_range(c, c_vpa);


end

function c = polyfit_qr(x, y, M)
    % Wyznacza współczynniki wielomianu aproksymacyjnego stopnia M
    % z zastosowaniem rozkładu QR.
    % c - kolumnowy wektor współczynników: [c_0; ...; c_M]

    A = zeros(numel(x), M+1); % macierz Vandermonde'a
    for k = 0:M
        A(:, k+1) = x.^k;
    end

    [Q, R] = qr(A, 0); % economy QR
    c = R \ (Q' * y);
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


function plot_c_range(c, c_vpa)
    c1log = sort(log10(abs(c)+1e-50)); % 1e-50: zabezpieczenie przez c(i)=0
    c2log = sort(log10(abs(c_vpa)+1e-50));

    plot(c1log,'kx-'); hold on
    plot(c2log,'bo-')
    hold off

    title('Zakres wartości współczynników c: double vs. vpa')
    xlabel('Indeks po sortowaniu według |c|')
    ylabel('$$\log_{10}\left(10^{-50} + |c|\right)$$', 'Interpreter', 'latex')

    legend('precyzja double', 'precyzja vpa', 'Location', 'eastoutside' );
end