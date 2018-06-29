function [t, i] = find_impact_time(X, position, velocity, max_err)
% Poisce cas, ko kroglica naslednjic zadane veriznco, ter indeks clenka, kjer
% se to zgodi.
%
% Vhodni parametri:
% X = mnozica tock, ki opisujejo veriznico
% position = zacetna pozicija kroglice kot vektor (x, y)
% velocity = zacetna hitrost kroglice kot vektor (v_x, v_y)
% max_err = najvecja dovoljena napaka odmika
%
% Izhodne spremenljivke:
% t = cas naslednjega trka
% i = indeks clenka, na katerem se trk zgodi

    if nargin < 4
        max_err = 1e-10;
    end

    % Dolocimo meje iskalnega intervala
    if velocity(1) != 0
        % izracunamo najvecji mozen cas in pozicijo kroglice ob tem casu
        max_delta_x = X(1, end) * sign(velocity(1)) - position(1);
        t_max = max_delta_x / velocity(1);
        [new_pos, _] = pos_velocity_at(position, velocity, t_max);

        % kroglica se ob najvecjem moznem casu nahaja nad krivuljo => ni odboja
        if new_pos(2) > 0
            warning('Ball bounced out of bounds.')
            t = 2 * t_max;
            i = -1;
            return
        else  % sicer je odboj natanko en in v naslednjem intervalu
            interval = [0, t_max];
        end
    else  % vsa hitrost usmerjena v smeri osi y (pademo na isto tocko)
        interval = [0, 2.05 * velocity(2) / 9.8];
    end

    err = max_err + 1;
    % Uporabimo bisekcijo: Newtonova metoda v tem primeru ni najprimernejsa, saj
    % so odvodi funkcije odmika kroglice od veriznice nezvezni (ker je veriznica
    % definirana kot mnozica zlepkov). Dodatno ima funkcija odmika dve nicli:
    % eno pri t=0, drugo pri iskanem t* -- metoda lahko konvergira k obema
    % (npr.  ce sta si odbojni tocki blizu in odvod dovolj velik, da pridemo v
    % blizino prve nicle ob t=0, cetudi je zacetni priblizek dovolj blizu
    % t=t*).
    while abs(err) > max_err && interval(2) - interval(1) > eps
        % Srediscna tocka
        t = sum(interval) / 2;

        % Izracunamo pozicijo ob casu t
        [new_pos, _] = pos_velocity_at(position, velocity, t);

        % Poiscemo clenek pod kroglo ob casu t
        i = find_link_at(new_pos, X, velocity(1));
        if i == -1  % clenek ne obstaja => krogla je zapustila obmocje veriznice
            interval(2) = t;
        else 
            % Dolocimo kako dalec na clenku se nahaja kroglica
            ratio = (new_pos(1) - X(1, i)) / (X(1, i + 1) - X(1, i));
            err = X(2, i) + ratio * (X(2, i + 1) - X(2, i)) - new_pos(2);
            if err > 0  % krogla se nahaja pod krivuljo (prevelik t)
                interval(2) = t;
            else  % krogla se nahaja nad krivuljo (premajhen t)
                interval(1) = t;
            end
        end
    end

    % Bisekcija ni skonvergirala k nicli: interval je poljubno majhen,
    % napaka pa vecja od najvecje dovojene
    if abs(err) > max_err
        warning('Failed to converge')
        t = 2;
        i = -1;
    end
end
