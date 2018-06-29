function exec_time(X, v0, offset, angle, N)
% Eksperimentalno doloci cas izvajanja pri posameznem stevilu odbojev za dano
% veriznico in spusceno kroglico. Rezultate izpise v obliki tabele in narise.
%
% Vhodni parametri:
% X = mnozica tock, ki opisujejo veriznico
% v0 = zacetna hitrost kroglice
% offset = relativni odmik kroglice od levega robu prvega clenka
% angle = kot (v rad od navpicnice v smeri urinega kazalca), pod katerim
%         kroglica zadane prvi clenek
% N = stevilo ponovitev eksperimenta

    if nargin < 5
        N = 5;
    end

    printf('Izvajam racunanje povprecnega casa izvajanja...\n\n');

    x = [1:5, 10:5:30, 40:10:100];  % stevilo odbojev
    y = zeros(size(x));  % cas izvajanja

    % Izmerimo cas izvajanja pri posameznem stevilu odbojev
    for j = 1:length(x)
        for i = 1:N
            tic;
            pos_after_n_hits(X, v0, offset, angle, x(j));
            y(j) += toc;
        end
    end
    y /= N;

    % Izpisemo tabelo
    printf('St. odbojev & Cas izvajanja [s]\n');
    for i = 1:length(x)
        printf('%d & %.02E\n', x(i), y(i));
    end

    % Narisemo graf
    figure;
    axis on;
    hold on;

    plot(x, y, 'ro');

    coef = polyfit(x, y, 1);
    x_ls = linspace(0, 100);
    plot(x_ls, polyval(coef, x_ls), 'k-');

    xlabel('St. odbojev');
    ylabel('Cas izvajanja [s]');
end
