function idx = find_link_at(pos, X, direction)
% Poisce clenek na veriznici X, ki se nahaja pod pozicijo `pos` glede na smer
% gibanja `direction`.
% 
% Vhodni parametri:
% X = mnozica tock, ki opisujejo veriznico
% pos = pozicija kroglice kot vektor (x, y)
% direction = smer gibanja kroglice, 
%       ce direction >= 0: kroglica se giblje desno
%       ce direction < 0: kroglica se giblje levo
%
% Izhodni parametri:
% idx = indeks clenka, ki je pod kroglico

    % dolocimo smer gibanja (iz hitrosti po x osi)
    dir_sign = ((sign(direction) >= 0) - 0.5) * 2;
    if dir_sign >= 0
        argfn = @(x) max(x);
    else
        argfn = @(x) min(x);
    end

    % dolocimo indekse interesantnih clenkov
    Xi = X(1, :);
    % ce je smer negativna, obrnemo, da funkcija res vraca argmax iz porocila
    Xi *= dir_sign;

    % clenek ustreza pogoju, da je prvi desno (levo) od kroglice
    [m, idx] = argfn(Xi > pos(1) * dir_sign);
    idx -= 1;  % ce se gibljemo v desno, je pravi clenek levi

    % ce ne uspemo najti clenka, vrnemo -1
    if m + (dir_sign < 0) != 1 || idx == 0
        idx = -1;
    end
end
