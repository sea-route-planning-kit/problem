function psi_d = heading(p, u, v, p_k, p_k1, settings)
    U = sqrt(u.^2+v.^2);
    beta = asin(v./U);
    
    %Delta = 60;
    d_p = p_k1 - p_k;
    d_p_current = p-p_k1;
    
    alpha_k = atan2(d_p(2), d_p(1));    
    %epsillon = prob.ship.R2(alpha_k)'*(p-p_k);
    %e = epsillon(2);
    e = -d_p_current(1,:) .* sin(alpha_k) + d_p_current(2,:) .*cos(alpha_k);
    
    chi_t = alpha_k;
    psi_d = chi_t + atan(-e/settings.Delta) - beta;
end