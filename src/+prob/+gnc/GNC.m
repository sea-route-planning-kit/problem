classdef GNC
   properties
       controller
       guidance
   end
   methods
        function this = GNC(path)
            this.controller = simulator.gnc.control.Controller(0, 0);
            this.guidance = simulator.gnc.guidance.Guidance(path);
        end
        
        function this = reset(this)
            this.controller = this.controller.reset();
            this.guidance = this.guidance.reset();
        end
        
        function this = update(this,path)
            this.guidance.path = path;
        end
        
        function boolean = complete(this)
            boolean = this.guidance.complete;
        end

        function [this,tau] = calculate(this, x,T)
            
            [this.guidance,u_d,psi_d] = this.guidance.calculate(x);
            
            this.controller = this.controller.update(u_d,psi_d);
            [this.controller,tau] = this.controller.calculate(x,T);
        end
   end
end

% function tau = gnc(x,T,path)
%     [u_d,psi_d] = guidance(x,path);
%     tau = controller(x,T,u_d,psi_d);
% end