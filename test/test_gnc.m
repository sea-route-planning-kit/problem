clear all

ship = prob.ship.load('viknes830.ship.json');
gnc_settings = jsondecode(fileread('viknes830.gnc.json'));

% Conditions
path = [0 250 600 800 500 100 450;
        0 250 0   500 600 250 200];
u_d = 5;
    
xx0 = [0 0 0 0 0 0]';
aux0 = [1;0];



gnc = @(xx,aux) prob.gnc.complete(xx, aux, path, u_d, ship, gnc_settings);


% Simulate
trajectory = ship.simulate(xx0, aux0, gnc, 800, @(xx,aux) aux(1) >= size(path,2));

% Plot
figure(1);
clf
plot(trajectory.xx(2,:), trajectory.xx(1,:), 'b', 'LineWidth', 2.0);
hold on;
plot(path(2,:), path(1,:), 'r--', 'LineWidth', 2.0);
grid on;
title('Path following with GNC system');
xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');
legend('Trajectory', 'Path');
