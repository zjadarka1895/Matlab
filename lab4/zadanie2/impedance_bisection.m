function [xvec, xdif, xsolution, ysolution, iterations] = impedance_bisection()
    % Wyznacza miejsce zerowe funkcji impedance_difference metodą bisekcji.
    % xvec - kolejne przybliżenia
    % xdif - różnice między kolejnymi przybliżeniami
    % xsolution - znalezione miejsce zerowe
    % ysolution - wartość funkcji w tym punkcie
    % iterations - liczba iteracji do zbieżności

    a = 1; 
    b = 10; 
    ytolerance = 1e-12;
    max_iterations = 1000;

    fa = impedance_difference(a);
    fb = impedance_difference(b);

    if fa * fb > 0
        error('Brak zmiany znaku funkcji na końcach przedziału. Metoda bisekcji nie może być zastosowana.');
    end

    xvec = [];
    xsolution = Inf;
    ysolution = Inf;
    iterations = max_iterations;

    for ii = 1:max_iterations
        c = (a + b) / 2;
        xvec(ii,1) = c;
        fc = impedance_difference(c);

        if abs(fc) < ytolerance
            xsolution = c;
            ysolution = fc;
            iterations = ii;
            break
        else
            if fa * fc < 0
                b = c;
                fb = fc;
            else
                a = c;
                fa = fc;
            end
        end
    end

    % Oblicz różnice między kolejnymi przybliżeniami
    xdif = abs(diff(xvec));

    % Wykresy
    figure;
    
    % Górny wykres - przybliżenia
    subplot(2,1,1);
    plot(xvec, '-o');
    title('Przybliżenia miejsca zerowego');
    xlabel('Iteracja');
    ylabel('x');
    grid on;

    % Dolny wykres - logarytm różnic
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
