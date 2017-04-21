function DFSSS_OPT=SET_DFSSS_OPT(PARA,OPT)

%************
%Assign input
%************
RAD=PARA.RAD;

DFSS=OPT.DFSS;

%****************
%Assign atom name
%****************
ATOM=RAD.ATOM;

%***********************
%Assign DFSSS parameters
%***********************
N=DFSS.N;
KT=DFSS.KT;

PU_P_0=DFSS.PU.P_0;
PR_P_0=DFSS.PR.P_0;

PU_AREA=DFSS.PU.AREA;
PR_AREA=DFSS.PR.AREA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%  SET THE DFSS OPTIONS  %%%%%%%%%%%%%%%%%%%%%%%%%

DFSSS_OPT.PARALLEL.PAR_LOGIC=0;                           
DFSSS_OPT.PARALLEL.NAP=24;                                

DFSSS_OPT.GENERAL.INTER=0;                                
DFSSS_OPT.GENERAL.DIMENSION=1;                            

DFSSS_OPT.ATOMIC.ATOM=ATOM;                               

DFSSS_OPT.ATOMIC.G=1;                                    
DFSSS_OPT.ATOMIC.GAMMA=0;                                 

DFSSS_OPT.ATOMIC.N=N;                                     
DFSSS_OPT.ATOMIC.KT=KT;                                   
DFSSS_OPT.ATOMIC.V_BULK=[0 0];                           

DFSSS_OPT.SIGHTLINE.NXD=1;                               
DFSSS_OPT.SIGHTLINE.WIDTH=0.10;                           
DFSSS_OPT.SIGHTLINE.WIDTH_LOGIC=0;                       

DFSSS_OPT.LASER.NU_WIN=[];                               

DFSSS_OPT.LASER.PU.P_0=PU_P_0;                            
DFSSS_OPT.LASER.PR.P_0=PR_P_0;                            

DFSSS_OPT.LASER.PU.AREA=PU_AREA;                          
DFSSS_OPT.LASER.PR.AREA=PR_AREA;                                

DFSSS_OPT.LASER.PU.DIRECTION=[1 0];                      
DFSSS_OPT.LASER.PR.DIRECTION=[-1 0];                      

DFSSS_OPT.VELOCITY.RANGE_SIG=200;             
DFSSS_OPT.VELOCITY.RANGE_N=200;                 
                                           
DFSSS_OPT.VELOCITY.POP_DEN_LOGIC=0;             
DFSSS_OPT.VELOCITY.NVXD=1;                   
DFSSS_OPT.VELOCITY.NVYD=1;                    

DFSSS_OPT.ERROR.EVAL=100000;
DFSSS_OPT.ERROR.ABS=1e-14;
DFSSS_OPT.ERROR.REL=1e-23;

DFSSS_OPT.PLOT.GEO=0;
DFSSS_OPT.PLOT.INT=0;
DFSSS_OPT.PLOT.SAT=0;
DFSSS_OPT.PLOT.POP_DEN=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end