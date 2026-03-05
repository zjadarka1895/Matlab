function [xvec, xdif, xsolution, ysolution, iterations] = impedance_secant()
    % Metoda siecznych do znalezienia miejsca zerowego funkcji impedance_difference

    x0 = 1;    % pierwszy punkt startowy
    x1 = 10;   % drugi punkt startowy
    ytolerance = 1e-12;
    max_iterations = 1000;

    f0 = impedance_difference(x0);
    f1 = impedance_difference(x1);

    xvec = [];
    xdif = [];
    xsolution = Inf;
    ysolution = Inf;
    iterations = max_iterations;

    for ii = 1:max_iterations
        if f1 - f0 == 0
            warning('Dzielenie przez zero w metodzie siecznych – zatrzymano.');
            break;
        end

        x2 = x1 - f1 * (x1 - x0) / (f1 - f0);
        f2 = impedance_difference(x2);
        xvec(ii,1) = x2;

        if ii > 1
            xdif(ii-1,1) = abs(xvec(ii) - xvec(ii-1));
        end

        if abs(f2) < ytolerance
            xsolution = x2;
            ysolution = f2;
            iterations = ii;
            break;
        else
            x0 = x1;
            f0 = f1;
            x1 = x2;
            f1 = f2;
        end
    end

    % Wykresy
    figure;

    % Górny wykres – przybliżenia
    subplot(2,1,1);
    plot(xvec, '-o');
    title('Przybliżenia miejsca zerowego (metoda siecznych)');
    xlabel('Iteracja');
    ylabel('x');
    grid on;

    % Dolny wykres – różnice logarytmicznie
    subplot(2,1,2);
    semilogy(xdif, '-o');
    title('Różnice kolejnych przybliżeń (log)');
    xlabel('Iteracja');
    ylabel('|x_{i+1} - x_i|');
    grid on;
end

function impedance_delta = impedance_difference(f)
    R = 525;
    L = 3;
    C = 7e-5;
    Z_ref = 75;

    if f <= 0
        error('Częstotliwość musi być większa od zera.');
    end

    omega = 2 * pi * f;
    denominator = sqrt(1/R^2 + (omega * C - 1 / (omega * L))^2);
    Zf = 1 / denominator;

    impedance_delta = abs(Zf) - Z_ref;
end
