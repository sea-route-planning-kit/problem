clear all

scenario = prob.scenario.load('scenario.json');
ship = prob.ship.load('ship_viknes830.json');

% Conditions
x0 = timeseries([0 0 pi 0 0 0],0);

u_d = 5;
psi_d = 0;
controller = prob.gnc.control.Controller(u_d,psi_d);

% Simulate
trajectory = prob.ship.simulate(ship, x0, controller, 100, []); %@(x,T) controller.calculate(x,T,u_d,psi_d)

% Plot
figure(1);
clf
plot(trajectory.Time, trajectory.Data(:,4), 'b');
hold on;
plot(trajectory.Time, ones(size(trajectory.Time))*u_d, 'r--');

figure(2);
clf
plot(trajectory.Time, trajectory.Data(:,3), 'b');
hold on;
plot(trajectory.Time, ones(size(trajectory.Time))*psi_d, 'r--');

