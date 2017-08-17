
syms x
y= -0.0003*x^5 + 0.0098*x^4 - 0.0547*x^3 - 1.8725*x^2 + 30.102*x - 32.907;

h=diff(y,2);

inflec_pt = solve(h,'MaxDegree',3);
double(inflec_pt)