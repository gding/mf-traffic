function [xs,arrival_cost,travel_cost] = random_simulation(plots)
T = 100;
dt = 1;
Dcr = 0.2; % critical density - max flow below, linearly decreases above
Qmax = 0.1; % max flow rate
g = @(x) (x <= 1e-6) + (x > 1e-6).*Qmax.*((x <= Dcr) + (x > Dcr).*(1-x)/(1-Dcr));
ts = 0:dt:T;

x = [1;0;0;0];
arrival_cost = zeros(1,numel(ts));
travel_cost = zeros(1,numel(ts));
xs = zeros(4,numel(ts));
xs(:,1) = x;
for i = 2:numel(ts)
    u0 = rand; % leave edge 0
    u1 = rand; % transition to edge 1
    x = [1-u0       0            0            0;
         u0*u1      1-g(x(2))*dt 0            0;
         u0*(1-u1) 1-u0-u1 0            1-g(x(3))*dt 0;
         0         g(x(2))*dt   g(x(3))*dt   1]*x;
    xs(:,i) = x;
    arrival_cost(i) = arrival_cost(i-1) + (1-x(4));
    travel_cost(i) = travel_cost(i-1) + (1-x(1)-x(4));
end
if plots
    figure(1); hold on;
    plot(xs(1,:),'color','r');
    plot(xs(2,:),'color','g');
    plot(xs(3,:),'color','b');
    plot(xs(4,:),'color','k');
    legend('start','path1','path2','end');
    figure(2); hold on;
    plot(travel_cost,'color','b');
    plot(arrival_cost,'color','r');
    legend('travel cost','arrival cost');
end
end