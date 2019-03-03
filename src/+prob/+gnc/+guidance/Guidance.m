classdef Guidance
   properties
       path
       k
   end
   methods
        function this = Guidance(path)
            this.path = path;
            this.k = 1;
        end
        
        function this = reset(this)
            this.k = 1;
        end
        
        function this = update(this, path)
            this.path = path;
        end
        
        function boolean = switching_condition(this, p)
            p_k1 = this.path(this.k+1,:)';
            R = 30;
            boolean = ((p_k1(1)-p(1))^2 + (p_k1(2)-p(2))^2 <= R^2);
        end
        
        function boolean = complete(this)
            boolean = this.k > size(this.path,1)-1;
        end

        function [this,u_d,psi_d] = calculate(this, x)
            path_complete = this.k > size(this.path,1)-1;
            if path_complete
                u_d = 0.01;
                psi_d = simulator.gnc.guidance.heading_guidance(x, this.path(this.k-1,:)', this.path(this.k,:)');
            else
                p_k = this.path(this.k,:)';
                p_k1 = this.path(this.k+1,:)';
                p = x(1:2);

                u_d = 5;
                psi_d = simulator.gnc.guidance.heading_guidance(x, p_k, p_k1); %% p instead of p_k?
                % Switching
                if this.switching_condition(p)%((p_k1(1)-p(1))^2 + (p_k1(2)-p(2))^2 <= R^2)
                    this.k = this.k+1;
                end
            end
        end
   end
end


% function [u_d, psi_d] = guidance(x, path)
%     persistent k;
%     if isempty(k)
%         k = 1;
%     end
%     path_complete = k > size(path,2)-1;
%     if path_complete
%     	u_d = 0.01;
%         psi_d = heading_guidance(x, path(:,k-1), path(:,k));
%     else
%         R = 30;
%         p_k = path(:,k);
%         p_k1 = path(:,k+1);
%         p = x(1:2);
% 
%         u_d = 5;
%         psi_d = heading_guidance(x, p_k, p_k1);
%         % Switching
%         if ((p_k1(1)-p(1))^2 + (p_k1(2)-p(2))^2 <= R^2)
%             k = k+1;
%         end
%     end
% end