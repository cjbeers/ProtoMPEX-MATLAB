
hold on;
x=[-.8:0.001:max(EXP.XE)+.8];
norm=normpdf(x,max(EXP.XE),.16);
norm=(norm/max(norm))*1.1;
plot(x,norm, 'k')