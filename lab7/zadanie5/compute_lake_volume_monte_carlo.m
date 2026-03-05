function [x, y, z, zmin, lake_volume] = compute_lake_volume_monte_carlo()
    % Wyznacza objętość jeziora metodą Monte Carlo.
    %
    % x/y/z - wektory wierszowe, które zawierają współrzędne x/y/z punktów
    %       wylosowanych w celu wyznaczenia przybliżonej objętości jeziora
    % zmin - minimalna dopuszczalna wartość współrzędnej z losowanych punktów
    % lake_volume - objętość jeziora wyznaczona metodą Monte Carlo

    N = 1e6;
    x = 100*rand(1,N); % [m]
    y = 100*rand(1,N); % [m]
    
    zmin = -100;
    z = zmin + (0 - zmin) * rand(1, N);  % z ∈ [zmin, 0]    
    V=100*100*abs(zmin);

    f_x_y = get_lake_depth(x,y);

    N1 = sum(z > f_x_y);
    
    lake_volume = V*N1/N;
end