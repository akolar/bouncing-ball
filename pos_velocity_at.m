function [p, v] = pos_velocity_at(p0, v0, t)
% Vrne pozicijo in hitrost kroglice ob casu t, ce je zacetna hitrost v0 in
% pozicija p0.
%
% Vhodni parametri:
% p0 = zacetna pozicija
% v0 = zacetna hitrost
% t = casovna razlika
%
% Izhodne spremenljivke:
% p = nova pozicija
% v = nova hitrost

    p = p0 + v0 * t;
    p(2) -= 9.8 * t^2 / 2;
    v = v0 - [0; 9.8 * t];
end
