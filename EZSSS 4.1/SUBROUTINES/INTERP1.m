function YP=INTERP1(XP,X,Y)

%**********************************
%Linearly interpolates/extrapolates
%**********************************
YP=Y(2)+(Y(2)-Y(1))*((XP-X(2))/(X(2)-X(1)));

end


