function [node_counts, exact_runge, exact_sine, V, interpolated_runge, interpolated_sine] =...
    plot_runge_sine_interpolations()

    node_counts = [4, 6, 10, 16];

    runge_function = @(x) 1 ./ (1 + 25 * x.^2);
    sine_function = @(x) sin(2 * pi * x);

    x_fine = linspace(-1, 1, 1000);
    exact_runge = runge_function(x_fine);
    exact_sine = sine_function(x_fine);

    V = cell(1, length(node_counts));
    interpolated_runge = cell(1, length(node_counts));
    interpolated_sine = cell(1, length(node_counts));

    figure;
    subplot(2,1,1);
    plot(x_fine, exact_runge, 'k--', 'LineWidth', 2, 'DisplayName', 'Wartości wzorcowe');
    hold on;
    title('Interpolacja funkcji Rungego');
    xlabel('x');
    ylabel('f(x)');

    subplot(2,1,2);
    plot(x_fine, exact_sine, 'k--', 'LineWidth', 2, 'DisplayName', 'Wartości wzorcowe');
    hold on;
    title('Interpolacja funkcji sinusoidalnej');
    xlabel('x');
    ylabel('f(x)');

    colors = lines(length(node_counts)); 

    for i = 1:length(node_counts)
        N = node_counts(i);
        x_nodes = linspace(-1, 1, N)';
        V{i} = get_vandermonde_matrix(x_nodes);

        % --- Runge ---
        y_runge = runge_function(x_nodes);
        coeff_runge = V{i} \ y_runge;
        coeff_runge = coeff_runge(end:-1:1); % do polyval
        interpolated_runge{i} = polyval(coeff_runge, x_fine);

        % --- Sine ---
        y_sine = sine_function(x_nodes);
        coeff_sine = V{i} \ y_sine;
        coeff_sine = coeff_sine(end:-1:1); % do polyval
        interpolated_sine{i} = polyval(coeff_sine, x_fine);

        subplot(2,1,1);
        plot(x_fine, interpolated_runge{i}, 'Color', colors(i,:), 'DisplayName', ...
            sprintf('Interpolacja (N = %d)', N));

        subplot(2,1,2);
        plot(x_fine, interpolated_sine{i}, 'Color', colors(i,:), 'DisplayName', ...
            sprintf('Interpolacja (N = %d)', N));
    end

    subplot(2,1,1);
    legend('Location', 'eastoutside');
    subplot(2,1,2);
    legend('Location', 'eastoutside');

    set(gcf, 'Position', [100 100 1200 800]);
end

function V = get_vandermonde_matrix(x)
    N = length(x);
    V = zeros(N); 
    for i = 1:N
        for j = 1:N
            V(i, j) = x(i)^(j-1);
        end
    end
end
