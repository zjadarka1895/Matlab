function [dates, y, rmse_values, M, c, ya] = calculate_rmse()
% 1) Wyznacza pierwiastek błędu średniokwadratowego w zależności od stopnia
%    aproksymacji wielomianowej danych przedstawiających produkcję energii.
% 2) Wyznacza i przedstawia na wykresie aproksymację wielomianową wysokiego
%    stopnia danych przedstawiających produkcję energii.

    M = 90; % stopień wielomianu aproksymacyjnego (dla wykresu)

    load energy_2025

    % TODO: ustaw kraj i źródło
    dates = energy_2025.Germany.Wind.Dates;
    y = energy_2025.Germany.Wind.EnergyProduction;

    N = numel(y);
    degrees = 1:N-1;

    x = linspace(0, 1, N)';

    rmse_values = zeros(numel(degrees), 1);

    % Oblicz RMSE dla każdego stopnia
    for m = degrees
        c_m = polyfit_qr(x, y, m);      % dopasuj wielomian stopnia m
        c_m = c_m(end:-1:1);            % dostosuj kolejność dla polyval
        yi = polyval(c_m, x);           % oblicz wartości aproksymacji
        rmse = sqrt(mean((yi - y).^2)); % oblicz RMSE
        rmse_values(m) = rmse;          % zapisz RMSE dla stopnia m
    end

    % Aproksymacja wielomianem stopnia M (dla wykresu danych)
    c = polyfit_qr(x, y, M);
    c = c(end:-1:1); % dopasuj do polyval
    ya = polyval(c, x);

    % Wykres danych rzeczywistych i aproksymacji
       % Tworzenie jednego okna graficznego z dwoma wykresami
    figure;

    % --- GÓRNY WYKRES: RMSE vs stopień wielomianu ---
    subplot(2,1,1);
    plot(degrees, rmse_values, 'k.-');
    xlabel('Stopień wielomianu');
    ylabel('RMSE');
    title('RMSE aproksymacji w zależności od stopnia wielomianu');
    grid on;

    % --- DOLNY WYKRES: Dane rzeczywiste i aproksymacja ---
    subplot(2,1,2);
    plot(dates, y, 'bo-', 'DisplayName', 'Dane rzeczywiste');
    hold on;
    if M > 89
        plot(dates, ya, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Aproksymacja M=%d', M));
    end
    xlabel('Data');
    ylabel('Produkcja energii');
    title('Aproksymacja wielomianowa danych produkcji energii');
    legend('Location', 'best');
    grid on;

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
