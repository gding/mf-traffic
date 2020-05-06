function xdot = dynCT(x,ufunc,g)
A = zeros(numel(x));
A(:,1) = ufunc(x);
for i = 2:numel(x)-1
    gi = g(x(i));
    A(i,i) = -gi;
    A(end,i) = gi;
end
xdot = A*x;
end