function trajectory = simulate(ship, x0, controller, max_time, stop_condition)
    T = 1;
    N = max_time/T;
    x_n = zeros(9,N);
    
    x_n(1:6,1) = x0.Data()';
    for i=2:N
        x = x_n(1:6,i-1);
        [controller, u] = controller.calculate(x,T);
        [~,x_next] = ode45(@(t,x) ship.f(x,u), [0 T], x);
        x_n(1:6,i) = x_next(end,:);
        x_n(7:9,i) = u;
        if (controller.complete() || (~isempty(stop_condition) && stop_condition(x)))
            x_n = x_n(:,1:i);
            N = i;
            break;
        end
    end
    trajectory = timeseries(x_n',(0:(N-1))*T+x0.Time(1));
end