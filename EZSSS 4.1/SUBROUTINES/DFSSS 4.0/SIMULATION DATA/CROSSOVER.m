function SCALE=CROSSOVER(A_0,NU_0)

%*******************
%Universal constants
%*******************
c=2.9979e8;

%**************************
%Assign the laser frequency
%**************************
NU=[NU_0(1) (NU_0(1)+NU_0(2))/2];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%  SET THE DFSS OPTIONS  %%%%%%%%%%%%

OPT.PARALLEL.PAR_LOGIC=0;                                 %Number of workers
OPT.PARALLEL.NAP=24;                                      %Number of workers

OPT.GENERAL.INTER=0;                                      %Interactive mode logic
OPT.GENERAL.DIMENSION=1;                                  %Dimensionality of integration

OPT.ATOMIC.ATOM='H';                                      %Atom of interest

OPT.ATOMIC.NT_0=2;                                        %Number of transitions
OPT.ATOMIC.A_0=A_0;                                         %Transition probabilites
OPT.ATOMIC.NU_0=c/6563.79e-10+NU_0;                            %Frequency of transitions

OPT.ATOMIC.G=1;                                           %Ratio of upper to lower statistical weights

OPT.ATOMIC.N=5e15;                                        %Ground state density
OPT.ATOMIC.KT=.06;                                         %Temperature of absorbers

OPT.SIGHTLINE.NXD=1;                                      %Number of spatial discretizations
OPT.SIGHTLINE.WIDTH=0.05;                                 %Active laser path length
OPT.SIGHTLINE.WIDTH_LOGIC=0;                              %Logic for self consistent width calculation

OPT.LASER.NFP=2;                                         %Number of frequency discretizations
OPT.LASER.NU_MODE='MANUAL';                              %Frequency discretization mode (AUTO or MANUAL)
OPT.LASER.NU_MAN=c/6563.79e-10+NU;                          %Manual frequency points - MANUAL

OPT.LASER.PU.P_0=0.007;                                   %Laser pump beam power
OPT.LASER.PR.P_0=0.001;                                   %Laser probe beam power

OPT.LASER.PU.AREA=pi*.0005^2;                             %Laser pump beam area
OPT.LASER.PR.AREA=pi*.0005^2;                             %Laser probe beam area

OPT.LASER.PU.DIRECTION=[1 0];                            %Laser pump beam direction
OPT.LASER.PR.DIRECTION=[-1 0];                            %Laser probe beam direction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%*********************************************
%Turning off the plotting (user control below)
%*********************************************
OPT.PLOT.GEO=0;                          
OPT.PLOT.INT=0;
OPT.PLOT.SAT=0;
OPT.PLOT.POP_DEN=0;                        

%**************************
%Calc. Doppler free spectra
%**************************
OPT.GENERAL.MODE='BOTH';                            
[DATA_BOTH,~,~,~]=DFSSS(OPT);

%*******************************
%Calc. Doppler broadened spectra
%*******************************
OPT.GENERAL.MODE='PROBE';                            
[DATA_PROBE,~,~,~]=DFSSS(OPT);

%*********************
%Assign intensity data
%*********************
I_PU_PR=DATA_BOTH.I_PR;
I_PR=DATA_PROBE.I_PR;

%*********************************
%Assign the Doppler-free intensity
%*********************************
I_DF=(I_PU_PR(1,2)-I_PR(1,2))/I_PR(1,1);

%******************************
%Assign the crossover intensity
%******************************
I_CR=(I_PU_PR(2,2)-I_PR(2,2))/I_PR(2,1);

%******************
%Calc. scale factor
%******************
SCALE=I_CR/I_DF;

end