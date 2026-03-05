function [xvec, xdif, xsolution, ysolution, iterations] = velocity_secant()
    % Metoda siecznych do znalezienia miejsca zerowego funkcji impedance_difference

    x0 = 1;    % pierwszy punkt startowy
    x1 = 40;   % drugi punkt startowy
    ytolerance = 1e-12;
    max_iterations = 1000;

    f0 = velocity_difference(x0);
    f1 = velocity_difference(x1);

    xvec = [];
    xvec(1,1) = (x0+x1)/2;

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
        f2 = velocity_difference(x2);
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
