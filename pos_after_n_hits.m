function [x, y, hit, time_total] = pos_after_n_hits(X, v0, offset, angle, n_bounces)
% Izracuna pozicijo kroglice po `n_bounces` odbojih.
%
% Vhodni parametri:
% X = mnozica tock, ki opisujejo veriznico
% v0 = zacetna hitrost kroglice
% offset = relativni odmik kroglice od levega robu prvega clenka
% angle = kot (v rad od navpicnice v smeri urinega kazalca), pod katerim
%         kroglica zadane prvi clenek
% n_bounces = stevilo odbojev
%
% Izhodni parametri:
% x = pozicija kroglice na x osi
% y = pozicija kroglice na y osi
% hit = stevilo odbojev
% time_total = cas odbijanja kroglice

    hit = 1;

    % Izracunamo zacetno pozicijo, na katero pade tocka
    plane = X(:, 2) - X(:, 1);
    pos = X(:, 1) + offset * plane;

    % Narisemo izracunamo zacetno hitrost
    velocity_start = [-v0*sin(angle); -v0*cos(angle)];
    time_total = 0;
    for hit = 2:n_bounces
        % Izracunamo hitrost po odboju
        velocity = calc_reflection_angle(plane, velocity_start);

        % Dolocimo cas naslednjega dotika
        [t_impact, plane_idx] = find_impact_time(X, pos, velocity);

        % Preverimo, da krogla ostane znotraj meja veriznice
        if plane_idx == -1
            printf('Kroglica je zapustila obmocje veriznice. Koncujem.\n')
            break
        end

        % Izracunamo koncno hitrost, novo odbojno ravnino ter koncno pozicijo
        velocity_start = velocity - [0; 9.8 * t_impact];
        plane = X(:, plane_idx + 1) - X(:, plane_idx);
        time_total += t_impact;

        pos = pos + velocity * t_impact;
        pos(2) -= 9.8 * t_impact^2 / 2;
    end

    % Vrnemo koncno pozicijo
    x = pos(1);
    y = pos(2);
end
