function [matrix_sizes, condition_numbers, interpolation_error_exact, interpolation_error_perturbed] = ...
        ill_conditioning_effects()
% Określa wpływ współczynnika uwarunkowania macierzy Vandermonde'a na dokładność interpolacji.
% Generuje trzy wykresy ilustrujące uwarunkowanie macierzy i błędy interpolacji.
%
% matrix_sizes - rozmiar testowych macierzy Vandermonde'a
% condition_numbers - współczynniki uwarunkowania testowych macierzy Vandermonde'a
% interpolation_error_exact - maksymalna różnica między referencyjnymi
%       a obliczonymi współczynnikami wielomianu, gdy b zawiera
%       wartości funkcji kwadratowej 
% interpolation_error_perturbed - maksymalna różnica między referencyjnymi
%       a obliczonymi współczynnikami wielomianu, gdy b zawiera
%       zaburzone wartości funkcji kwadratowej 


    % Inicjalizacja danych
    matrix_sizes = 5:100;
    num_points = length(matrix_sizes);

    % Prealokacja danych
    condition_numbers = zeros(1, num_points);
    interpolation_error_exact = zeros(1, num_points);
    interpolation_error_perturbed = zeros(1, num_points);

    %===========================================================================
    % Część 1: Obliczanie współczynnika uwarunkowania macierzy Vandermonde'a
    %===========================================================================
    for index = 1:num_points
        size_n = matrix_sizes(index);
        interpolation_nodes = linspace(-1, 1, size_n)';
        V = get_vandermonde_matrix(interpolation_nodes); % TODO

        % condition_numbers(index) = % TODO
        condition_numbers(index) = cond(V)
    end

    % Szukam progu złego uwarunkowania
    threshold_index = find(condition_numbers >= 1e8, 1);

    % Wykres 1
    tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
    nexttile;
    semilogy(matrix_sizes, condition_numbers)  % TODO
    title('Obliczanie współczynnika uwarunkowania macierzy Vandermondea');
    xlabel('N');
    ylabel('Wsp');

    if ~isempty(threshold_index)
        size_threshold = matrix_sizes(threshold_index);
        xline(size_threshold, '--', 'cond(V) > 10^8', 'LabelOrientation',...
            'horizontal', 'LabelVerticalAlignment', 'top',...
            'LabelHorizontalAlignment', 'left', 'Color', [0.494 0.184 0.556]);
    end
    % TODO

    %===========================================================================
    % Część 2: Obliczenie błędu interpolacji dla dokładnych danych (f(x)=x^2)
    %===========================================================================
    for index = 1:num_points
        size_n = matrix_sizes(index);
        interpolation_nodes = linspace(-1, 1, size_n)';
        V = get_vandermonde_matrix(interpolation_nodes); % TODO

        a2 = 1;
        b_exact = a2*interpolation_nodes.^2; % f(x) = a2*x^2
        % TODO:
        reference_coefficients = [0; 0; a2; zeros(size_n - 3, 1)];
        % computed_coefficients =
        computed_coefficients = V \ b_exact;
         interpolation_error_exact(index) =...
            max(abs(computed_coefficients - reference_coefficients));
    end

    % Wykres 2
    nexttile;
    plot(matrix_sizes, interpolation_error_exact) % TODO
    title('Obliczenie błędu interpolacji dla dokładnych danych (f(x)=x^2)');
    xlabel('N');
    ylabel('Err');
    %===========================================================================
    % Część 3: Obliczenie błędu interpolacji dla danych zaburzonych
    %===========================================================================
    for index = 1:num_points
        size_n = matrix_sizes(index);
        interpolation_nodes = linspace(-1, 1, size_n)';
        V = get_vandermonde_matrix(interpolation_nodes); % TODO
        a2 = 1;
        b_perturbed = a2*interpolation_nodes.^2 + rand(size_n, 1) * 1e-9;
        % TODO:
        reference_coefficients = [0; 0; a2; zeros(size_n - 3, 1)];
        % computed_coefficients =
        computed_coefficients = V \ b_perturbed;
        interpolation_error_perturbed(index) =...
            max(abs(computed_coefficients - reference_coefficients));
    end

    % Wykres 3
    nexttile;
    semilogy(matrix_sizes, interpolation_error_perturbed) % TODO
    title('Obliczenie błędu interpolacji dla danych zaburzonych');
    xlabel('N');
    ylabel('Err');
end


function V = get_vandermonde_matrix(x)
    x = x(:);  
    N = length(x);
    V = zeros(N);
    for i = 1:N
        for j = 1:N
            V(i, j) = x(i)^(j-1);
        end
    end
end