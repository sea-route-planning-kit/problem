function N = heading(psi, r, psi_d, ship, settings)

    K_p_psi = settings.heading.K_p;
    K_d_psi = settings.heading.K_d;

    N = - K_p_psi * wrapToPi(psi - psi_d) - K_d_psi * r;

    N = min(ship.N_limit(2), N);
    N = max(ship.N_limit(1), N);
end

