function impedance_delta = impedance_difference(f)
    % Stałe
    R = 525;            % rezystancja (Ohm)
    L = 3;              % indukcyjność (H)
    C = 7e-5;           % pojemność (F)
    Z_ref = 75;         % wartość odniesienia

    % Sprawdzenie poprawności częstotliwości
    if f <= 0
        error('Częstotliwość musi być większa od zera.');
    end

    % Obliczanie modułu impedancji |Z(f)|
    omega = 2 * pi * f;
    numerator = 1;
    denominator = sqrt(1/R^2 + (omega * C - 1 / (omega * L))^2);
    Zf = numerator / denominator;

    % Różnica względem wartości odniesienia
    impedance_delta = Zf - Z_ref;
end
