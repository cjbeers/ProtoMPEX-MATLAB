function [LINE,OPT]=OPTIONS(NAP, BIN)

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%***********
%Print logic
%***********
OPT.PRINT.PARA=0;
OPT.PRINT.PARA_BACK=0;
OPT.PRINT.FIT=0;

%**********
%Plot logic
%**********
OPT.PLOT.LOGIC.FIT=0;

OPT.PLOT.LOGIC.MSE=0;
OPT.PLOT.LOGIC.PIXEL=0;
OPT.PLOT.LOGIC.COMPONENTS=0;
OPT.PLOT.LOGIC.RESID=0;

OPT.PLOT.ERROR='FILL';
OPT.PLOT.TYPE='SINGLE';

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%*****************************************************************
%Magentic field and temperature fit logic (0 - fit / 1 - setpoint) 
%*****************************************************************
LOG_B=1;
LOG_KTN=0;

%*********************************************
%Magentic field and temperature fit boundaries 
%*********************************************
BD_B=[0 1];
BD_KTN=[0 20];

%***************************************************
%Magentic field and temperature number of fit points 
%***************************************************
NFP_B=18;
NFP_KTN=20;

%****************************************
%Magentic field and temperature setpoints 
%****************************************
B=BIN;
KTN=15;

%*************************
%Polar and azimuthal angle
%*************************
THETA=pi/2;
PHI=0;

%********************
%Number of iterations
%********************
NI=3;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%***************************
%Define the line of interest
%***************************
LINE{1}.ATOM='ArII';
LINE{1}.WAVE='4806A';

%***************************
%Assign number of processors
%***************************
OPT.NAP=NAP;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%*******************
%Assign main options
%*******************
OPT.PARA.NH_X=0;
OPT.PARA.NH_Y=0;
OPT.PARA.NH_Z=0;
OPT.PARA.NTG=1;
OPT.PARA.NFL=0;
OPT.PARA.NI=NI;
OPT.PARA.NS=1;

OPT.PARA.PSL(1:14)=1;
OPT.PARA.PSL(6)=LOG_B;
OPT.PARA.PSL(10)=LOG_KTN;

OPT.PARA.PSV{1}(1:14)=0;
OPT.PARA.PSV{1}(1)=THETA; %Theata
OPT.PARA.PSV{1}(2)=PHI; %Phi 
OPT.PARA.PSV{1}(3)=0; %Sigma
OPT.PARA.PSV{1}(4)=1; %T1
OPT.PARA.PSV{1}(5)=0; %T2
OPT.PARA.PSV{1}(6)=B; %B
OPT.PARA.PSV{1}(7)=0; %EDC_X
OPT.PARA.PSV{1}(8)=0; %EDC_Y
OPT.PARA.PSV{1}(9)=0; %EDC_Z
OPT.PARA.PSV{1}(10)=KTN; %KTN
OPT.PARA.PSV{1}(11)=0; %X
OPT.PARA.PSV{1}(12)=1; %I
OPT.PARA.PSV{1}(13)=0; %IB CONSTANT
OPT.PARA.PSV{1}(14)=0; %IB FIT

xx=0;
if LOG_B==0
    xx=xx+1;
    OPT.PARA.PSB(xx,1:2)=BD_B;
    OPT.PARA.NDPS(xx)=NFP_B;
end

if LOG_KTN==0
    xx=xx+1;
    OPT.PARA.PSB(xx,1:2)=BD_KTN; 
    OPT.PARA.NDPS(xx)=NFP_KTN;
end

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%****************************
%Assign instrument parameters
%****************************
OPT.PARA.PSB_INS(1,1:2)=[.92,1.08];
OPT.PARA.PSB_INS(2,1:2)=[-0.08,0.08];

OPT.PARA.NDPS_INS=[12,12];

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

end