function [uu,i_u_dot] = surge_heading(psi, u, r, psi_d, u_d, i_u, ship, settings)

    [X,i_u_dot] = prob.gnc.control.surge(u, u_d, i_u, ship, settings);
    N = prob.gnc.control.heading(psi, r, psi_d, ship, settings);
    uu = [X;N];
end

