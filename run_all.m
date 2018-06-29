% Zazene interaktivni vmesnik za prikaz veriznice z vnesenimi parametri ter
% simulacijo spusta kroglice.

clf;

% Zberemo parametre veriznice
D = input('Razmak obesisc: ');
L = input('Dolzine palic: ');
M = input('Mase palic: ');

% Preverimo veljavnost vhoda
if validate_catenary_input(D, L, M);
    printf('Napacni vhodni parametri veriznice\n');
    return
end

% Izracunamo ter narisemo veriznico
X = solve_catenary(D, L, M);
plot_catenary(X);

% Zberemo parametre spusta kroglice
v0 = input('Hitrost kroglice: ');
offset = input('Relativna lokacija kroglice na prvem clenku (0<=r<=1): ');
angle = input('Kot: ');
n_bounces = input('St. odbojev (n>=1): ');

% Preverimo veljavnost vhoda 
if validate_ball_input(X, v0, offset, angle, n_bounces);
    printf('Napacni vhodni parametri kroglice\n');
    return
end

% Simuliramo odboje
[x, y, n, t] = ball_simulation(X, v0, offset, angle, n_bounces);
printf('\nPo %d odbojih in %.03f s krogla zadane točko (%.05f, %.05f) na clenku %d\n',
       n, t, x, y, find_link_at(x, X, 1));

printf('\n');
input('Pritisni [enter] za nadaljevanje...');
printf('\n');

% Izmerimo cas racunanja
exec_time(X, v0, offset, angle);
