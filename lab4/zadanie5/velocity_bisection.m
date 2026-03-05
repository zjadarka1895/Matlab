function [xvec, xdif, xsolution, ysolution, iterations] = velocity_bisection()
    % Wyznacza miejsce zerowe funkcji impedance_difference metodą bisekcji.
    % xvec - kolejne przybliżenia
    % xdif - różnice między kolejnymi przybliżeniami
    % xsolution - znalezione miejsce zerowe
    % ysolution - wartość funkcji w tym punkcie
    % iterations - liczba iteracji do zbieżności

    a = 1; 
    b = 40; 
    ytolerance = 1e-12;
    max_iterations = 1000;

    fa = velocity_difference(a);
    fb = velocity_difference(b);

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
        fc = velocity_difference(c);

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

function velocity_delta = velocity_difference(t)
% t - czas od startu rakiety
u=2000;
m0=150000;
q=2700;
g=1.622;
M=700;
 if t <= 0 
        error('Czas musi być w wiekszy od zera');
 end
v = u * log(m0 / (m0 - q * t)) - g * t;
velocity_delta = v-M;

end
