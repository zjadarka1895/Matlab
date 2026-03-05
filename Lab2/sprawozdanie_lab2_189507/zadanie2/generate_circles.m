function [circle_areas, circles, a, b, r_max] = generate_circles(n_max)    % Losowanie rozmiarów prostokąta oraz maksymalnego promienia
    a = 200;
    b = 90;
    r_max = 30;

    % Macierz przechowująca okręgi
    circles = zeros(n_max, 3);
    circle_areas = zeros(n_max, 1);
    P = a*b;
    S=0;
    for i = 1:n_max    
        % okrąg przecina inny okrąg
       while(true)
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
                break;
            end
       end
       circles(i, :) = [X, Y, R];
       S_i = pi*R^2;
       S =S + S_i;
       ca = S/P*100;
       circle_areas(i,1)=ca;
    end
plot(circle_areas);
title("Stosunek pól kół do pola prostokąta");
xlabel("Liczba kół");
ylabel("Stosunek pól (%)");
grid on;
saveas(gcf, 'zadanie2.png')
end

%Twoim zadaniem jest zmodyfikowanie funkcji generate_circles z zadania 1 w taki sposób, aby:
%Obliczała skumulowany stosunek sumy pól kół do pola prostokąta (w procentach) dla kolejno dodawanych kół i zapisywała wynik w postaci wektora kolumnowego circle_areas.
%Wyświetlała wykres przedstawiający circle_areas.
%Zapisywała wygenerowany wykres do pliku w formacie PNG.
