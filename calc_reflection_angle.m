function v_refl = calc_reflection_angle(plane, velocity)
% Izracuna hitrost `v_refl` po odboju kroglice na ravnini `plane` z vhodno
% hitrostjo `velocity`.
% 
% Vhodni parametri
% plane = 2D vektor, ki opisuje smer ravnine (pravokoten na normalo)
% velocitiy = 2D vektor, ki opisuje hitrost gibanja kroglice v obeh dimenzijah
% 
% Izhodne spremenljivke
% v_refl = 2D vektor izhodne hitrosti

    % Dolocimo normiran vektor normale odbojne ravnine
    plane_normal = [0 1; -1 0] * plane / norm(plane);

    % S Householderjevim zrcaljenjem dolocimo nov vektor hitrosti
    v_refl = velocity - 2*plane_normal * (plane_normal' * velocity);
end
