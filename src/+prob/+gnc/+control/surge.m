function [X,i_dot] = surge(u, u_d, i, ship, settings)

    K_p_u = settings.surge.K_p;
    K_i_u = settings.surge.K_i;

    X0 = - K_p_u * (u - u_d) - K_i_u * i;

    X0 = min(ship.X_limit(2), X0);
    X0 = max(ship.X_limit(1), X0);

    X_ff = u_d .* (-ship.X_u - ship.X_uu * abs(u_d));

    X = X0+X_ff;
    i_dot = u_d - u;
end

