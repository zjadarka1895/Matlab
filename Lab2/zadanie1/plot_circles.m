function [] = plot_circles(a, b, circles)
    % Ustawienie proporcji i osi
    axis equal;
    axis([0 a 0 b]);
    hold on;
    
    % Pętla po wszystkich okręgach
    for i = 1:size(circles, 1)
        X = circles(i, 1);
        Y = circles(i, 2);
        R = circles(i, 3);
        plot_circle(X, Y, R);
    end
    title ("Pecherzyki");

    hold off;
end
