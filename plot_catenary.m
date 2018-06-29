function plot_catenary(X)
% Narise veriznico podano s tockami X.
%
% Vhodni parametri:
% X = mnozica tock, ki opisujejo veriznico

    hold on;
    % Narisemo veriznico
    plot(X(1,:),X(2,:), 'b-', 'LineWidth', 2);
    plot(X(1,:),X(2,:), 'bo', 'MarkerSize', 5, 'MarkerFaceColor', 'b');

    % Nastavimo izgled grafa
    grid on;
    axis square;
    daspect([1 1 1]);
    axis([X(1, 1), X(1, end), ceil(min(X(2,:))-1), 1]);
end
