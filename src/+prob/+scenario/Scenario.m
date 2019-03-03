classdef Scenario
    properties
        name
        x_limit
        y_limit
        t_max
        goal_position
        start_position
        obstacles
    end
    methods
        function this = Scenario(name, x_limit, y_limit, t_max, goal_position, start_position, obstacles)
            this.name = name;
            this.x_limit = x_limit;
            this.y_limit = y_limit;
            this.t_max = t_max;
            this.goal_position = goal_position;
            this.start_position = start_position;
            this.obstacles = obstacles;
        end
        
        function col = is_collision(this, x, y)
            col = any(this.obstacles.is_collision(x, y), 1) | ...
                x < this.x_limit(1) | x > this.x_limit(2) | ...
                y < this.y_limit(1) | y > this.y_limit(2);
        end
        
        function free = is_area_free(this, X_lim, Y_lim)
            free = true;
            for x=X_lim
                for y=Y_lim
                    for o = this.obstacles
                        if o.is_collision(x,y)
                            free = false;
                            return;
                        end
                    end
                end
            end
        end
        
        function plot(this)
            plot(this.obstacles);
            hold on
            plot(this.start_position(2), this.start_position(1), 'b*', 'linewidth', 2)
            plot(this.goal_position(2), this.goal_position(1), 'r*', 'linewidth', 2)
            
            plot(this.y_limit([1,2,2,1,1]), this.x_limit([1,1,2,2,1]), '-k')
        end
    end
end