function [dates, y, M, c, ya] = test_approximation()
% Wyznacza aproksymację wielomianową danych przedstawiających produkcję energii.
% Dla kraju C oraz źródła energii S:
% dates - wektor energy_2025.C.S.Dates (daty pomiaru produkcji energii)
% y - wektor energy_2025.C.S.EnergyProduction (poziomy miesięcznych produkcji energii)
% M - stopień wielomianu aproksymacyjnego
% c - współczynniki wielomianu aproksymacyjnego: c = [c_M; ...; c_1; c_0]
% ya - wartości wielomianu aproksymacyjnego wyznaczone dla punktów danych
%       (rozmiar wektora ya powinien być taki sam jak rozmiar wektora y)

    load energy_2025

    dates = energy_2025.Germany.Wind.Dates; % TODO
    y = energy_2025.Germany.Wind.EnergyProduction; % TODO

    M = 12; % stopień wielomianu aproksymacyjnego

    N = numel(y); % liczba danych
    x = linspace(0,1,N)'; % znormalizowana dziedzina aproksymowanych danych

    c = polyfit_qr(x,y,M); % wsp. wielomianu 

    c = c(end:-1:1); % odwrócenie kolejności elementów wektora c; dostosowanie do polyval

    ya = polyval(c,x); % wyznaczenie wartości wielomianu aproksymacyjnego

   
    % TODO:
    figure;
    plot(dates, y, 'bo-', 'DisplayName', 'Dane rzeczywiste');
    hold on;
    plot(dates, ya, 'r-', 'LineWidth', 2, 'DisplayName', 'Aproksymacja');
    xlabel('Data');
    ylabel('Produkcja energii');
    title('Aproksymacja wielomianowa produkcji energii');
    legend show;
    grid on;
    % wykres

end

function c = polyfit_qr(x, y, M)
    % Wyznacza współczynniki wielomianu aproksymacyjnego stopnia M
    % z zastosowaniem rozkładu QR.
    % c - kolumnowy wektor wsp. wielomianu c = [c_0; ...; c_M]

    A = zeros(numel(x),M+1); % macierz Vandermonde o rozmiarze [n,M+1]
    % TODO:
    for k = 0:M
        A(:,k+1) = x.^k;
    end

    [q1, r1] = qr(A, 0); % economy QR factorization
    c = r1 \ (q1.' * y);
     

end