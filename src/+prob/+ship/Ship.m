classdef Ship
   properties
      L
      m
      I_z
      X_u
      X_uu
      Y_v
      Y_vv
      N_r
      N_rrr
      X_limit
      N_limit
      %% Other
      M
      M_inv
   end
   methods
      function this = Ship(L, m, I_z, X_u, X_uu, Y_v, Y_vv, N_r, N_rrr, X_limit, N_limit)
         this.L = L;
         this.m = m;
         this.I_z = I_z;
         this.X_u = X_u;
         this.X_uu = X_uu;
         this.Y_v = Y_v;
         this.Y_vv = Y_vv;
         this.N_r = N_r;
         this.N_rrr = N_rrr;
         
         this.X_limit = X_limit;
         this.N_limit = N_limit;
         
         this.M = [this.m 0 0;
                   0 this.m 0;
                   0 0 this.I_z];
         this.M_inv = inv(this.M);
      end
      
      function C = C(this, nu)
          u = nu(1);
          v = nu(2);
          C = [0        0         -this.m*v;
               0        0         this.m*u;
               this.m*v -this.m*u 0         ];
      end
      function D = D(this, nu)
          u = nu(1);
          v = nu(2);
          r = nu(3);
          D = [this.X_u + this.X_uu*abs(u)  0                                   0;
               0                                this.Y_v + this.Y_vv*abs(v)     0;
               0                                0                                   this.N_r + this.N_rrr*r^2];
      end
      
      function x_dot = f(this, x, tau)
          eta = x(1:3);
          nu = x(4:6);
          psi = eta(3);
          % Ignoring wind and wave for now
          x_dot = [ simulator.ship.R(psi)*nu;
                    this.M_inv*(tau - this.C(nu)*nu + this.D(nu)*nu) ];
      end      
      
      %% Helpers for trajectory prediction, should maybe not be here
      function n = n(this, nu)
          n = this.M\(this.C(nu)*nu + this.D(nu)*nu);
      end
      function N = N(this, nu)
          u = nu(1);
          v = nu(2);
          r = nu(3);
          N = [(this.X_u + 2*this.X_uu*abs(u))/this.m       -r                                              -v;
               r                                           (this.Y_v + 2*this.Y_vv*abs(v))/this.m           u;
               0                                            0                                               (this.N_r + 3*this.N_rrr*r^2)/this.I_z ];
      end
   end
   methods(Static)      
      function dxx = f_static(xx, uu, ship_model)
        m = ship_model.m;
        I_z = ship_model.I_z;
        X_u = ship_model.X_u;
        X_uu = ship_model.X_uu;
        Y_v = ship_model.Y_v;
        Y_vv = ship_model.Y_vv;
        N_r = ship_model.N_r;
        N_rrr = ship_model.N_rrr;

        psi = xx(3,:);
        nu = xx(4:6,:);
        u = nu(1,:);
        v = nu(2,:);
        r = nu(3,:);

        tau = [
            uu(1,:);
            0;
            uu(2,:);
            ];

        M = [
            m, 0, 0;
            0, m, 0;
            0, 0, I_z;
            ];

        C = [
            0, 0, -m*v;
            0, 0, m*u;
            m*v, -m*u, 0;
            ];

        D = -[
            X_u + X_uu*abs(u), 0, 0;
            0, Y_v + Y_vv*abs(v), 0;
            0, 0, N_r + N_rrr*r.^2;
            ];

        N = C + D;

        dnu = M \ (-N*nu + tau);

        dx = cos(psi) .* u - sin(psi) .* v;
        dy = sin(psi) .* u + cos(psi) .* v;
        dpsi = r;

        dxx = [
            dx;
            dy;
            dpsi;
            dnu;
            ];

      end
  end
end
