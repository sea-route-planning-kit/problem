function scenario = parse(object)
    
    goal_position = object.goal_position;
    start_position = object.start_position;
    obstacles = prob.scenario.Obstacle.empty();
    for i=1:length(object.obstacles)
        obstacles(i) = parseObstacle(object.obstacles(i));
    end
    scenario = prob.scenario.Scenario(object.name, object.background_image, object.x_limit, object.y_limit, object.t_max, goal_position, start_position, obstacles);
    
    function obstacle = parseObstacle(object)
        obstacle = prob.scenario.Obstacle(object.x, object.y,object.a,object.b, object.alpha);
    end
end