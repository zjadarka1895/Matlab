function [index_number, Edges, I, B, A, b, r] = page_rank()
    index_number = 189507;
    N = 7; 
    d = 0.85; 
    b_value = (1 - d) / N;

    Edges = [
        1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 7;
        4, 6, 3, 4, 5, 5, 6, 7, 5, 6, 4, 6, 4, 7, 6
    ];

    I = speye(N); 
    B = sparse(Edges(2,:), Edges(1,:), 1, N, N);
    
    L = sum(B, 1)';  
    
    A = spdiags(1 ./ L, 0, N, N); 
    M = I - d * (B * A); 

    b = b_value * ones(N, 1);
    
    %zadanie 5
    r = M \ b; 
    bar(r);
    title("Page rank");
    xlabel("Page");
    ylabel("PR");
end
