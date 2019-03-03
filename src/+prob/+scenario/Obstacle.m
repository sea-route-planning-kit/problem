classdef Obstacle
    properties
        x
        y
        a
        b
        alpha
    end
    methods
        function this = Obstacle(x, y, a, b, alpha)
            this.x = x;
            this.y = y;
            this.a = a;
            this.b = b;
            this.alpha = alpha;
        end
        function h = plot(this, linespec, interval)
            if nargin < 2
                linespec = ':k';
            end
%             h = [];
            if nargout
                h = gobjects(numel(this),1);
            end
            
            hold on
            for i = 1:numel(this)
                this_ = this(i);
                interval_ = [];
                if nargin < 3
                    largest_axis = max(this_.a, this_.b);
                    interval_ = [this_.y-largest_axis, this_.y+largest_axis, this_.x-largest_axis, this_.x+largest_axis];
                else
                    interval_ = interval(i,:);
                end
                
                f = @(y,x) this_.violation(x,y);
                if nargout
                    h(i) = fimplicit(f, interval_, linespec);
                else
                    fimplicit(f, interval_, linespec)
                end
            end
        end
        
        function f = violation(this, x, y)
            % > 0 for x and y inside obstacle bounds. <0 when clear off
            % bounds
            eps = 0.01;
            
            co = cos([this.alpha]');
            si = sin([this.alpha]');
            
            xc = [this.x]';
            yc = [this.y]';
            
            dx = x - xc;
            dy = y - yc;
            
            x_bar = co .* dx + si .* dy;
            y_bar = -si .*dx + co .* dy;
            
            f = ...
                -log((x_bar./[this.a]').^2 + (y_bar./[this.b]').^2 + eps) ...
                +log(1+eps);
        end
        
        function col = is_collision(this, x, y)
            col = this.violation(x, y) > 0;
        end
    end
    methods(Static)
        function f = violation_static_single( x, y, x_0, y_0, a, b, angle )
            eps = 10;
            co = cos(angle);
            si = sin(angle);
            dx = x - x_0;
            dy = y - y_0;

            x_bar = co .* dx + si .* dy;
            y_bar = -si .* dx + co .* dy;

            f = ...
                -log((x_bar/a).^2 + (y_bar/b).^2 + eps) ...
                +log(1+eps);
        end
    end
end