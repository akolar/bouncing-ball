function X = solve_catenary(D, L, M)
% Izracuna mejne tocke clenkov, ki opisujejo veriznico z razdaljo med obesisci
% `D`, dolzino palic `L` ter njihovimi pripadajocimi tezami `M`.
% 
% Vhodni parametri:
% D = razmak med obesisci
% L = vektor dolzin (leve strani) palic
% M = vektor mas (leve strani) palic
%
% Izhodne spremenljivke:
% X = tocke mej med clenki {(x_i, y_i)}_i

    mi = [(M(1:end-1) + M(2:end)) / 2];  % razlike mi
    mi_n = M(end);  % poseben primer za mi_n, ker se ne mnozi z *2 pri delnih vsotah

    % izracunamo delne vsote (notranji oklepaj enacbe (12))
    cumsum_mi = [fliplr(2 * cumsum(fliplr(mi)) + mi_n), mi_n];

    % pomozna funkcija za izracun xi
    xi = @(u) L ./ sqrt(1 + (u/2 * cumsum_mi).^2);

    % pomozna funkcija za izracun U
    U = @(u) 2 * sum(xi(u)) - D;

    % minimiziramo U
    u = fzero(U, -1);

    % izracunamo xi ter dolocimo koordinate leve strani krivulje
    xi_0 = [0 xi(u)];
    pos_x = -D/2 + cumsum(xi_0);
    pos_y = cumsum(-sqrt([0, L.^2] - xi_0.^2));
    
    % vrnemo obe strani krivulje
    X = [pos_x, abs(fliplr(pos_x)); pos_y, fliplr(pos_y)];
end
