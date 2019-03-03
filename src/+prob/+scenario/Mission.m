classdef Mission
   properties
      x
      y
   end
   methods
      function obj = Mission(x, y)
         obj.x = x;
         obj.y = y;
      end
      function plot(obj)
          plot(obj.y(1), obj.x(1), 'b*', 'LineWidth',2, 'DisplayName','Mission start');
          plot(obj.y(2), obj.x(2), 'r*', 'LineWidth',2, 'DisplayName','Mission end');
      end
   end
end