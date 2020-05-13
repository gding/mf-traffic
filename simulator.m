N = 10;
terminal_costs = zeros(1,N);

figure(1); hold on;
figure(2); hold on;
for i = 1:N
    [t,x,running_cost,terminal_cost] = simulate();
    
    figure(1)
    plot(t,x(1,:),'color','r');
    plot(t,x(2,:),'color','g');
    plot(t,x(3,:),'color','b');
    plot(t,x(4,:),'color','k');
    legend('start','path1','path2','end');
    
    figure(2); hold on;
    plot(t,running_cost,'color','b');
    terminal_costs(i) = terminal_cost;
end

function u = greedy_ufunc(x)
n = numel(x);
u = zeros(n,1);
u(1) = 1 - (x(1) > 1e-6)*rand*0.1;
u(find(x == min(x(2:end-1)),1)) = 1 - u(1);
end
