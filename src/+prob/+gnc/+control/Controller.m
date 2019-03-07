classdef Controller
   properties
       speed_controller
       heading_controller
       u_d
       psi_d
   end
   methods
        function this = Controller(u_d, psi_d)
            this.speed_controller = prob.gnc.control.SpeedController();
            this.heading_controller = prob.gnc.control.HeadingController();
            this.u_d = u_d;
            this.psi_d = psi_d;
        end
        
        function this = reset(this)
            this.speed_controller = this.speed_controller.reset();
            this.heading_controller = this.heading_controller.reset();
        end
        
        function this = update(this, u_d, psi_d)
            this.u_d = u_d;
            this.psi_d = psi_d;
        end
        
        function boolean = complete(this)
            boolean = false;
        end

        function [this,tau] = calculate(this, x,T)
            [this.speed_controller, X] = this.speed_controller.calculate(x,T, this.u_d);
            [this.heading_controller, N] = this.heading_controller.calculate(x,T,this.psi_d);
            tau = [X 0 N]';
        end
   end
end

% function tau = controller(x,T, u_d, psi_d)
%     tau = [speed_controller(x,T, u_d) 0 heading_controller(x,T,psi_d)]';
% end