function [x, y, hits, time_total] = ball_simulation(X, v0, offset, angle,
                                                   n_bounces, time_delta)
% Narise odbijanje kroglice po veriznici.
%
% Vhodni parametri:
% X = mnozica tock, ki opisujejo veriznico
% v0 = zacetna hitrost kroglice
% offset = relativni odmik kroglice od levega robu prvega clenka
% angle = kot (v rad od navpicnice v smeri urinega kazalca), pod katerim
%         kroglica zadane prvi clenek
% n_bounces = stevilo odbojev
% time_delta = casovna resolucija risanja poti kroglice
%
% Izhodni parametri:
% x = pozicija kroglice na x osi
% y = pozicija kroglice na y osi
% hits = stevilo odbojev
% time_total = cas odbijanja kroglice

    if nargin < 6
       time_delta = 0.005;
    end

    hits = 1;
    D = X(1, end) - X(1, 1);

    % Izracunamo zacetno pozicijo, na katero pade tocka
    plane = X(:, 2) - X(:, 1);
    pos = X(:, 1) + offset * plane;

    % Narisemo izracunamo zacetno hitrost, smer zacetnega spusta tocke
    velocity_start = [-v0*sin(angle); -v0*cos(angle)];
    initial_move = velocity_start / norm(velocity_start) * D/6;
    plot([pos(1), pos(1) - initial_move(1)], [pos(2), pos(2) - initial_move(2)], 'c-');

    % Kontrolno okno
    loc_text = text(0, -0.1, sprintf('x: %f\ny: %f\nv: %f', pos(1), pos(2), 0));

    % Izrisemo prvi dotik s krivuljo
    plot(pos(1), pos(2), 'ro', 'MarkerFaceColor', 'r')
    hit_text = text(pos(1) + 0.05, pos(2) - 0.05, sprintf('(%.03f, %.03f)\n', pos));

    time_total = 0;
    for hit = 2:n_bounces
        % Izracunamo hitrost po odboju
        velocity = calc_reflection_angle(plane, velocity_start);

        % Poiscemo cas naslednjega zadetka ter ustvarimo vektor vmesnih casov
        [t_impact, plane_idx] = find_impact_time(X, pos, velocity);
        t = [0:time_delta:t_impact t_impact];

        % Izracunamo tocke za risanje
        loc = pos + velocity * t;
        loc(2, :) -= 9.8 * t.^2 / 2;

        % Narisemo pot med obema dotikoma
        for i = 1:length(t)
            x = loc(1, i);
            y = loc(2, i);

            set(loc_text, 'String', sprintf('x: %f\ny: %f\nt: %f\n#hits: %d',
                x, y, time_total + t(i), hit - 1));
            plot(x, y, 'r.');
            pause(time_delta);
        end

        % Preverimo, da krogla ostane znotraj meja veriznice
        if plane_idx == -1
            printf('Kroglica je zapustila obmocje veriznice. Koncujem.\n')
            break
        end

        % Izracunamo koncno hitrost, novo odbojno ravnino ter koncno pozicijo
        hits = hit;
        velocity_start = velocity - [0; 9.8 * t_impact];
        plane = X(:, plane_idx + 1) - X(:, plane_idx);
        time_total += t_impact;
        pos = loc(:, end);

        % Popravimo graficne elemente na sliki
        delete(hit_text);
        plot(pos(1), pos(2), 'ro', 'MarkerFaceColor', 'r')
        hit_text = text(pos(1) + 0.05, pos(2) - 0.05, sprintf('(%.03f, %.03f)\n', pos));
    end

    % Popravimo kontrolno okno
    set(loc_text, 'String', sprintf('x: %f\ny: %f\nt: %f\n#hits: %d',
        pos(1), pos(2), time_total, hits));

    % Vrnemo koncno pozicijo
    x = pos(1);
    y = pos(2);
end
