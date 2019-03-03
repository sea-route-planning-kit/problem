classdef Path
   properties
      points
   end
   methods
      function obj = Path(points)
         obj.points = points;
      end
      function plot(obj)
          plot(obj.points(1,:), obj.points(2,:), 'g--', 'LineWidth',2);
      end
   end
end