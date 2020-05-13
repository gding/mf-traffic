function [t,x,running_cost,terminal_cost] = simulate(varargin)
% SIMULATE  Simulate a network of parallel edges.
% 
% This function simulates a network of parallel edges. More complex (graph)
% connectivity to be added, pending time.
%
% Notation is as follows: edge 1 is the departure edge, edge n is the
% destination edge, and thus there are n-2 parallel paths between them.
% 
% varargin{1} = controller. f: x [[0,1]^n] --> u [[0,1]^n]
%   u(i) represents the proportion of flow from edge 1 to edge i, and must
%   sum to 1, By default, a uniformly random proportion between 0.9 and 1
%   remain on the start edge and the remainder are uniformly randomly
%   distributed across the transition edges. If the density on edge 1 is
%   less than 1e-6, all flow will leave the edge.
%
% varargin{2} = running cost. f: x [[0,1]^n] --> L [R]
%   L represents the running cost of some state x. By default, the sum of
%   x(2) through x(n-1), i.e. any flow that is not at the start or final
%   edge.
%
% varargin{3} = terminal cost. f: x [[0,1]^n] --> phi [R]
%   phi represents the terminal cost of a state. By default, the sum of
%   x(1) through x(n-1), i.e. any flow that is not at the final edge.
% 
% varargin{4} = step time. [R+]
%   The step time. By default, 1.
%
% varargin(5) = simulation time. [R+]
%   The simulation time. By default 100.
% 
% varargin{6} = transition proportion. f: rho [[0,1]] --> p [[0,1]]
%   p represents the proportion that transitions out of an edge given some
%   vehicle density. By default, breaks down as the following:
%   If rho <= 1e-6, p = 1 [all vehicles leave]
%   Else, if rho <= (Dcr = 0.2) [below critical density], p = (Qmax = 0.1)
%   [maximum flow rate]
%   Else, p = Qmax*(1-rho)/(1-Dcr) [linearly decreasing from Qmax at rho = 
%   Dcr to 0 at rho = 1]
% 
% varargin{7} = number of parallel flows. [Z+]
%   The number of parallel flows. By default, 2.

% Argument handling
if nargin < 1
    ufunc = @default_ufunc;
else
    ufunc = varargin{1};
end

if nargin < 2
    Lfunc = @(x) 1 - x(1) - x(end);
else
    Lfunc = varargin{2};
end

if nargin < 3
    phifunc = @(x) 1 - x(end);
else
    phifunc = varargin{3};
end

if nargin < 4
    dt = 1;
else
    dt = varargin{4};
end

if nargin < 5
    Tf = 100;
else
    Tf = varargin{5};
end

if nargin < 6
    Dcr = 0.2; % critical density - max flow below, linearly decreases above
    Qmax = 0.1; % max flow rate
    g = @(x) Qmax.*((x <= Dcr) + (x > Dcr).*(1-x)/(1-Dcr));
%     g = @(x) (x <= 1e-6) + (x > 1e-6).*Qmax.*((x <= Dcr) + (x > Dcr).*(1-x)/(1-Dcr));
else
    g = varargin{6};
end

if nargin < 7
    n = 2;
else
    n = varargin{7};
end


% Discrete time
% t = 0:dt:Tf;
% x = zeros(n+2,numel(t));
% x(1,1) = 1;
% running_cost = zeros(1,numel(t));
% for i = 2:numel(t)
%     x(:,i) = dynDT(x(:,i-1),ufunc,g,dt);
%     running_cost(i) = running_cost(i-1) + Lfunc(x(:,i));
% end

% Continuous time
[t,x] = ode45(@(t,x) dynCT(x,@(x) ufunc(x) - [1;0;0;0],g),[0 Tf],[1;0;0;0]);
t = t'; x = x';
running_cost = zeros(1,numel(t));
for i = 2:numel(t)
    running_cost(i) = running_cost(i-1) + Lfunc(x(:,i)')*(t(i)-t(i-1));
end

terminal_cost = phifunc(x(:,end));
end

function u = default_ufunc(x)
n = numel(x);
u = zeros(n,1);
u(1) = 1 - (x(1) > 1e-6)*rand*0.1;
tmp = rand(n-2,1);
u(2:end-1) = tmp/sum(tmp)*(1-u(1));
end
