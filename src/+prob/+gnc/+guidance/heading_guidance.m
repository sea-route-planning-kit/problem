function psi_d = heading_guidance(x, p_k, p_k1)
    p = x(1:2);
    u = x(4);
    v = x(5);
    U = sqrt(u^2+v^2);
    
    Delta = 60;
    
    alpha_k = atan2(p_k1(2)-p_k(2), p_k1(1)-p_k(1));
    
    epsillon = prob.ship.R2(alpha_k)'*(p-p_k);
    e = epsillon(2);
    
    psi_d = alpha_k + atan(-e/Delta) - asin(v/U);
end