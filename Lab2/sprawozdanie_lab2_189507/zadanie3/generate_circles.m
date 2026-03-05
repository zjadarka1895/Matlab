 function [rand_counts, counts_mean, circles, a, b, r_max]= generate_circles(n_max)
 % Losowanie rozmiarów prostokąta oraz maksymalnego promienia
    a = 200;
    b = 90;
    r_max = 30;
    try_num = 0;
    sum_try = 0;

    % Macierz przechowująca okręgi
    circles = zeros(n_max, 3);
    rand_counts = zeros(1, n_max);
    counts_mean = zeros(1, n_max);

    
    for i = 1:n_max    
       while(true)
            try_num = try_num+1;
            valid = true;
            R = randi([1, r_max]);  % R z zakresu (0, r_max]
            X = randi([0, a]);      % X z zakresu (0, a]
            Y = randi([0, b]);      % Y z zakresu (0, b])
    
            % Powtórzenie losowania, jeśli okrąg wykracza poza prostokąt
            if X + R > a || X - R < 0 || Y + R > b || Y - R < 0
                valid=false;
            end
            for j = 1:i-1
                X2 = circles(j, 1);
                Y2 = circles(j, 2);
                R2 = circles(j, 3);
                dist = sqrt((X - X2)^2 + (Y - Y2)^2);
                
                % Jeżeli odległość między środkami jest mniejsza niż suma promieni
                % lub okrąg zawiera inny okrąg
                if dist <= (R + R2) 
                    valid = false;
                    break;
                end
            end
            %nie trzeba powtarzać losowania
            if valid
                rand_counts(i) = try_num;
                sum_try = sum_try + try_num;
                counts_mean(i) = sum_try/i;
                try_num = 0;
                break;
            end
            
       end
       circles(i, :) = [X, Y, R];
    end
    subplot(2,1,1);
    plot(rand_counts);
    title("Liczba losowań okręgu");
    xlabel("Numer okręgu");
    ylabel("Ilość prób");

    subplot(2,1,2);
    plot(counts_mean);
    title("Średnia liczba losowań");
    xlabel("Numer okręgu");
    ylabel("Średnia ilość losowań");
    
end



