function xk1 = dynDT(xk,ufunc,g,dt)
A = zeros(numel(xk));
A(:,1) = ufunc(xk);
for i = 2:numel(xk)-1
    gi = g(xk(i));
    A(i,i) = 1-gi;
    A(end,i) = gi;
end
A(end,end) = 1;
xk1 = A*xk;

