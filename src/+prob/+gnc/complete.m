function [uu,aux_dot] = complete(xx, aux, path, u_d, ship, settings)
    [psi_d,k_dot] = prob.gnc.guidance.autopilot(xx(1:2,:), xx(4,:), xx(5,:), aux(1,:), path, settings.guidance);
    [uu,i_u_dot] = prob.gnc.control.surge_heading(xx(3,:), xx(4,:), xx(6,:), psi_d, u_d, aux(2,:), ship, settings.control);
    aux_dot = [k_dot;i_u_dot];
end