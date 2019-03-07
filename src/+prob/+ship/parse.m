function ship = parse(o)
    ship = prob.ship.Ship(o.L, o.m, o.I_z, o.X_u, o.X_uu, o.Y_v, o.Y_vv, o.N_r, o.N_rrr, o.X_limit, o.N_limit);
end