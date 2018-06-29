function valid = validate_ball_input(X, v0, offset, angle, n_bounces)
    valid = 0;

    % vektor hitrosti je usmerjen proti ravnini
    x1_perp = [0 1; -1 0] * (X(:, 2) - X(:, 1));
    v = [-v0*sin(angle); -v0*cos(angle)];
    valid += v' * x1_perp <= 0;

    valid += v0 <= 0;  % vektor hitrosti je pozitiven
    valid += offset < 0;  % odmik od zgornjega vogala clenka je med [0, 1]
    valid += offset > 1;
    valid += n_bounces <= 0;  % stevilo odbojev je pozitivno
end
