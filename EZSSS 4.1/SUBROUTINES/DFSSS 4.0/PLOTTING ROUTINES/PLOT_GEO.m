function FH=PLOT_GEO(PARA)

%************
%Assign input
%************
LASER=PARA.LASER;
MODE=PARA.MODE;

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
ROT_HIT=0;
if min(abs(ANGLE_PU),abs(ANGLE_PR))>pi/4
    ROT_HIT=1;
    
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
L=3*max([max(X)-min(X),max(Y)-min(Y)]);

%**************************
%Calc. the pump beam points
%**************************
X_PU(1)=L/2;
Y_PU(1)=-B_PU+X_PU(1)*A_PU;

X_PU(2)=L/2;
Y_PU(2)=B_PU+X_PU(2)*A_PU;

X_PU(3)=-L/2;
Y_PU(3)=B_PU+X_PU(3)*A_PU;

X_PU(4)=-L/2;
Y_PU(4)=-B_PU+X_PU(4)*A_PU;

%***************************
%Calc. the probe beam points
%***************************
X_PR(1)=L/2;
Y_PR(1)=-B_PR+X_PR(1)*A_PR;

X_PR(2)=L/2;
Y_PR(2)=B_PR+X_PR(2)*A_PR;

X_PR(3)=-L/2;
Y_PR(3)=B_PR+X_PR(3)*A_PR;

X_PR(4)=-L/2;
Y_PR(4)=-B_PR+X_PR(4)*A_PR;

%*******************************
%Rotate by pi/2 for large angles 
%*******************************
if ROT_HIT==0
    X_PU_PLOT=X_PU;
    Y_PU_PLOT=Y_PU;
    
    X_PR_PLOT=X_PR;
    Y_PR_PLOT=Y_PR;
    
    X_PLOT=X;
    Y_PLOT=Y;
else
    X_PU_PLOT=Y_PU;
    Y_PU_PLOT=X_PU;
    
    X_PR_PLOT=Y_PR;
    Y_PR_PLOT=X_PR;
    
    X_PLOT=Y;
    Y_PLOT=X;    
end

%*****************************
%Calc. scale factor for x-axis
%*****************************
if max([X_PU_PLOT X_PR_PLOT])<0.1
    X_SCALE=1000;
    X_NAME='mm';
elseif max([X_PU_PLOT X_PR_PLOT])<1
    X_SCALE=100;
    X_NAME='cm'; 
else
    X_SCALE=1;
    X_NAME='m'; 
end

%*****************************
%Calc. scale factor for y-axis
%*****************************
if max([Y_PU_PLOT Y_PR_PLOT])<0.1
    Y_SCALE=1000;
    Y_NAME='mm';
elseif max([Y_PU_PLOT Y_PR_PLOT])<1
    Y_SCALE=100;
    Y_NAME='cm'; 
else
    Y_SCALE=1;
    Y_NAME='m'; 
end

%*********************************
%Plot the pump/probe beam geometry
%*********************************
FH=figure;
if strcmpi(MODE,'BOTH')==1
    if ROT_HIT==0 
        subplot(2,1,1)
    else
        subplot(1,2,1)
    end
end
hold on
if strcmpi(MODE,'PUMP')==1 || strcmpi(MODE,'BOTH')==1
    hold on
    PH_PU=fill(X_PU_PLOT*X_SCALE,Y_PU_PLOT*Y_SCALE,'r','LineStyle','none');
end

if strcmpi(MODE,'PROBE')==1 || strcmpi(MODE,'BOTH')==1
    hold on
    PH_PR=fill(X_PR_PLOT*X_SCALE,Y_PR_PLOT*Y_SCALE,'b','LineStyle','none');
end

if strcmpi(MODE,'BOTH')==1
    hold on
   PH_BOTH=fill(X_PLOT*X_SCALE,Y_PLOT*Y_SCALE,'k','LineStyle','none');
end
hold off
grid on
xlabel(['x-axis (' X_NAME ')'],'FontSize',38)
ylabel(['y-axis (' Y_NAME ')'],'FontSize',38)
if strcmpi(MODE,'PUMP')==1 
    legend(PH_PU,['Pump Beam - Angle: ' num2str(ANGLE_PU*180/pi,'%4.1f') '\circ'])
elseif strcmpi(MODE,'PROBE')==1 
    legend(PH_PR,['Probe Beam - Angle: ' num2str(ANGLE_PR*180/pi,'%4.1f') '\circ'])  
else
    legend([PH_PU,PH_PR,PH_BOTH],'Pump Beam','Probe Beam','Overlap')
    title(['Pump/Probe Beam Angle: ' num2str(abs(ANGLE_PU-ANGLE_PR)*180/pi,'%4.1f') '\circ'],'FontSize',38)
end
set(gca,'FontSize',38)

if strcmpi(MODE,'BOTH')==1
    if ROT_HIT==0
        subplot(2,1,2)
    else
        subplot(1,2,2)
    end

    fill(X_PLOT*1000,Y_PLOT*1000,'k','LineStyle','none')
    grid on
    xlabel('x-axis (mm)','FontSize',38)
    ylabel('y-axis (mm)','FontSize',38)
    set(gca,'FontSize',38)   
end

end

