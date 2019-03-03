classdef PID_controller
   properties
        K_p
        K_i
        K_d
        
        error_last
        error_integral
   end
   methods
        function this = PID_controller(K_p, K_i, K_d)
            this.K_p = K_p;
            this.K_i = K_i;
            this.K_d = K_d;
            this.error_integral = 0;
        end
        
        function this = reset(this)
            this.error_last = [];
            this.error_integral = 0;
        end

        function [this,u] = calculate(this, error, T)
            if isempty(this.error_last)
                this.error_last = error;
            end
            this.error_integral = this.error_integral + error;

            u = this.K_p*error + this.K_i*this.error_integral*T + this.K_d*(error-this.error_last)/T;

            this.error_last = error;
        end
   end
end
