function [circles, a, b, r_max] = generate_circles(n_max)
    % Losowanie rozmiarów prostokąta oraz maksymalnego promienia
    a = 200;
    b = 90;
    r_max = 30;

    % Macierz przechowująca okręgi
    circles = zeros(n_max, 3);
    
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
    end

end



