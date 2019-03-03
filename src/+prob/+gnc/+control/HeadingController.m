classdef HeadingController
   properties
       pid_controller
   end
   methods
        function this = HeadingController()
            K_p = 500;
            K_i = 0;
            K_d = 5000;
            this.pid_controller = simulator.gnc.control.PID_controller(K_p,K_i,K_d);
        end
        
        function this = reset(this)
            this.pid_controller = this.pid_controller.reset();
        end

        function [this,N] = calculate(this, x, T, psi_d)
            [this.pid_controller,N] = this.pid_controller.calculate(wrapToPi(psi_d-x(3)),T);
        end
   end
end


% function N = heading_controller(x,T,psi_d)
%     K_p = 500;
%     K_i = 0;
%     K_d = 5000;
%     persistent controller
%     if isempty(controller)
%         controller = PID_controller(K_p,K_i,K_d);
%     end
%     [controller,N] = controller.calculate(wrapToPi(psi_d-x(3)),T);
% end