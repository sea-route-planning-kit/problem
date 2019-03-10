clear

ship = prob.ship.load('ship_viknes830.json');
gnc_settings = jsondecode(fileread('viknes830.gnc.json'));

% Conditions
xx0 = [0 0 pi 0 0 0]';

psi_d = pi/2;
u_d = 5;

%% Simulate
controller = @(xx,aux) prob.gnc.control.surge_heading(xx(3,:), xx(4,:), xx(6,:), psi_d, u_d, aux, ship, gnc_settings.control);

trajectory = ship.simulate(xx0, 0, controller, 100, []); %@(x,T) controller.calculate(x,T,u_d,psi_d)

%% Plot
figure(1);
clf
plot(trajectory.t, trajectory.xx(4,:), 'b');
hold on;
plot(trajectory.t, ones(size(trajectory.t))*u_d, 'r--');

figure(2);
clf
plot(trajectory.t, trajectory.xx(3,:), 'b');
hold on;
plot(trajectory.t, ones(size(trajectory.t))*psi_d, 'r--');