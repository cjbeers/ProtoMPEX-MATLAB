function yp=Lin_Extrap(xp,x,y)
  
yp=y(2)+(y(2)-y(1))*((xp-x(2))/(x(2)-x(1)));

end