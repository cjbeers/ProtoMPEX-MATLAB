function WIDTH=BEAM_GEOMETRY(LASER)

%************
%Assign input
%************
AREA_PU=LASER.PU.AREA;
AREA_PR=LASER.PR.AREA;

DIR_PU=LASER.PU.DIRECTION;
DIR_PR=LASER.PR.DIRECTION;

%***********************
%Calc. the beam diameter
%***********************
D_PU=(AREA_PU/pi)^.5;
D_PR=(AREA_PR/pi)^.5;

%*************************
%Calculate the beam angles
%*************************
if DIR_PU(2)~=0
    SIGN_PU=DIR_PU(2)/abs(DIR_PU(2));
else
    SIGN_PU=1;
end

if DIR_PR(2)~=0
    SIGN_PR=DIR_PR(2)/abs(DIR_PR(2));
else
    SIGN_PR=1;
end

ANGLE_PU=acos(DIR_PU(1))*SIGN_PU;
ANGLE_PR=acos(DIR_PR(1))*SIGN_PR;

%********************************
%Rotate by -pi/2 for large angles 
%********************************
if min(abs(ANGLE_PU),abs(ANGLE_PR))>pi/4    
    ANGLE_PU=ANGLE_PU-pi/2;
    ANGLE_PR=ANGLE_PR-pi/2;
end

%*******************************
%Calc. pump beam line parameters
%*******************************
A_PU=tan(ANGLE_PU);
B_PU=D_PU/cos(ANGLE_PU);

%********************************
%Calc. probe beam line parameters
%********************************
A_PR=tan(ANGLE_PR);
B_PR=D_PR/cos(ANGLE_PR);

%**************************************************
%Calc. the pump and probe beams intersection points
%**************************************************
X(1)=(-B_PR-B_PU)/(A_PU-A_PR);
Y(1)=-B_PR+X(1)*A_PR;

X(2)=(-B_PR+B_PU)/(A_PU-A_PR);
Y(2)=-B_PR+X(2)*A_PR;

X(3)=(B_PR+B_PU)/(A_PU-A_PR);
Y(3)=B_PR+X(3)*A_PR;

X(4)=(B_PR-B_PU)/(A_PU-A_PR);
Y(4)=B_PR+X(4)*A_PR;

%*********************************
%Calc. width of interaction region
%*********************************
WIDTH=max([max(X)-min(X),max(Y)-min(Y)]);

end

