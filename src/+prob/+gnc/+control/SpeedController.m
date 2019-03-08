classdef SpeedController
   properties
       pid_controller
   end
   methods
        function this = SpeedController()
            K_p = 3000;
            K_i = 300;
            K_d = 0;
            this.pid_controller = prob.gnc.control.PID_controller(K_p,K_i,K_d);
        end

        function this = reset(this)
            this.pid_controller = this.pid_controller.reset();
        end
        
        function [this,X] = calculate(this, x, T, u_d)
            [this.pid_controller,X] = this.pid_controller.calculate(u_d-x(4),T);
        end
   end
end


% function X = speed_controller(x,T,u_d)
%     K_p = 3000;
%     K_i = 300;
%     K_d = 0;
%     persistent controller
%     if isempty(controller)
%         controller = PID_controller(K_p,K_i,K_d);
%     end
%     [controller,X] = controller.calculate(u_d-x(4),T);
% end