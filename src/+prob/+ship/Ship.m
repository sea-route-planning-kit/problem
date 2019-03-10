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
        dCdu
        dCdv
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
            
            this.dCdu = [0         0         0;
                0         0         this.m;
                0         -this.m   0 ];
            
            this.dCdv = [0         0         this.m;
                0         0         0;
                this.m    0         0 ];
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
            D = -[this.X_u + this.X_uu*abs(u)      0                                   0;
                0                                this.Y_v + this.Y_vv*abs(v)     0;
                0                                0                                   this.N_r + this.N_rrr*r^2];
        end
        
        function dDdu = dDdu(this, u)
            dDdu = [ -this.X_uu*sign(u) 0 0;
                zeros(2,3) ];
        end
        
        function dDdv = dDdv(this, v)
            dDdv = [ zeros(1,3);
                0 -this.Y_vv*sign(v) 0;
                zeros(1,3) ];
        end
        
        function dDdr = dDdr(this, r)
            dDdr = [ zeros(2,3);
                0 0 -2*this.N_rrr*r ];
        end
        
        function [A,B] = linearize(this, x)
            eta = x(1:3);
            nu = x(4:6);
            psi = eta(3);
            u = nu(1);
            v = nu(2);
            r = nu(3);
            
            C = this.C(nu);
            D = this.D(nu);
            
            dfdpsi = [ prob.ship.R_der(eta(3))*nu;
                zeros(3,1) ];
            
            dfdu = [ prob.ship.R(psi)*[1;0;0];
                -this.M_inv*(this.dCdu*nu + C*[1;0;0] + this.dDdu(u)*nu + D*[1;0;0]) ];
            
            dfdv = [ prob.ship.R(psi)*[0;1;0];
                -this.M_inv*(this.dCdv*nu + C*[0;1;0] + this.dDdv(v)*nu + D*[0;1;0]) ];
            
            dfdr = [ prob.ship.R(psi)*[0;0;1];
                -this.M_inv*(C*[0;0;1] + this.dDdr(r)*nu + D*[0;0;1]) ];
            
            
            
            
            A = [ zeros(6,2), dfdpsi, dfdu, dfdv, dfdr ];
            
            B = [ zeros(3,3); this.M_inv ];
        end
        
        function x_dot = f(this, x, tau)
            eta = x(1:3);
            nu = x(4:6);
            psi = eta(3);
            % Ignoring wind and wave for now
            x_dot = [ prob.ship.R(psi)*nu;
                this.M_inv*(tau - this.C(nu)*nu - this.D(nu)*nu) ];
        end
        
        function trajectory = simulate(this, x0, controller, max_time, stop_condition)
            T = 1;
            N = max_time/T;
            x_n = zeros(9,N);

            x_n(1:6,1) = x0.Data()';
            for i=2:N
                x = x_n(1:6,i-1);
                if (isa(controller,'function_handle'))
                    u = controller(x,T);
                    controller_complete = false;
                else
                    [controller, u] = controller.calculate(x,T);
                    controller_complete = controller.complete();
                end
                [~,x_next] = ode45(@(t,x) this.f(x,u), [0 T], x);
                x_n(1:6,i) = x_next(end,:);
                x_n(7:9,i) = u;
                if (controller_complete || (~isempty(stop_condition) && stop_condition(x)))
                    x_n = x_n(:,1:i);
                    N = i;
                    break;
                end
            end
            trajectory = timeseries(x_n',(0:(N-1))*T+x0.Time(1));
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
