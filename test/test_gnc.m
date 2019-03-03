clear all

scenario = prob.scenario.load('scenario.json');
ship = prob.ship.load('ship_viknes830.json');

% Conditions
path = [0 250 600 800 500 100 150;
        0 250 0   500 600 250 400]';
x0 = timeseries([0 0 0 5 0 0],0);

gnc = prob.gnc.GNC(path);

% Simulate
trajectory = prob.ship.simulateShip(ship, x0, gnc, 500, []);

% Plot
figure(1);
clf
plot(trajectory.Data(:,1), trajectory.Data(:,2), 'b', 'LineWidth', 2.0);
hold on;
plot(path(:,1), path(:,2), 'r--', 'LineWidth', 2.0);
grid on;
title('Path following with GNC system');
xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');
legend('Trajectory', 'Path');
