function [ALPHA,POP_DEN]=ABSORPTION_COEFF(NU,I_PR,I_PU,PARA,UNIV)

warning('off','all')

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%|||||||||||||||             Assign parameters             ||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

ATOMIC=PARA.ATOMIC;
LASER=PARA.LASER;
VELOCITY=PARA.VELOCITY;
ERROR=PARA.ERROR;
MODE=PARA.MODE;
DIMENSION=PARA.DIMENSION;

              %%%%%%%%%%%%%%%%%%% ATOMIC %%%%%%%%%%%%%%%%%%%
NU_0=ATOMIC.NU_0;

A_0=ATOMIC.A_0;

GAMMA=ATOMIC.GAMMA;

V_BULK=ATOMIC.V_BULK;
KT=ATOMIC.KT;
              %%%%%%%%%%%%%%%%%%% ATOMIC %%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%%% LASER %%%%%%%%%%%%%%%%%%%%
DIR_PU=LASER.PU.DIRECTION;
DIR_PR=LASER.PR.DIRECTION;
              %%%%%%%%%%%%%%%%%%% LASER %%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%% VELOCITY %%%%%%%%%%%%%%%%%%
RANGE_SIG=VELOCITY.RANGE_SIG;
RANGE_N=VELOCITY.RANGE_N;

POP_DEN_LOG=VELOCITY.POP_DEN_LOGIC;
NVXD=VELOCITY.NVXD;
NVYD=VELOCITY.NVYD;
              %%%%%%%%%%%%%%%%%% VELOCITY %%%%%%%%%%%%%%%%%%
              
              %%%%%%%%%%%%%%%%%%%% ERROR %%%%%%%%%%%%%%%%%%%
FUN_EVAL=ERROR.EVAL;
ABS_ERR=ERROR.ABS;
REL_ERR=ERROR.REL;
              %%%%%%%%%%%%%%%%%%%% ERROR %%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%% UNIVERSAL CONSTANTS %%%%%%%%%%%%%
q=UNIV.q;
c=UNIV.c;
m=UNIV.m;
              %%%%%%%%%%%% UNIVERSAL CONSTANTS %%%%%%%%%%%%%            
              
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%***************
%Allocate memory
%***************
V_MIN_SIG_PU(1:2)=0;
V_MAX_SIG_PU(1:2)=0;

V_MIN_SIG_PR(1:2)=0;
V_MAX_SIG_PR(1:2)=0;

V_MIN_N(1:2)=0;
V_MAX_N(1:DIMENSION)=0;

V_MIN(1:2)=0;
V_MAX(1:2)=0;

%*************************
%Calc. velocity boundaries 
%*************************
for ii=1:2
    %************************************
    %Based on the cross-section magnitude 
    %************************************
    V_0_PU=c*(NU./NU_0-1)*DIR_PU(ii)-V_BULK(ii);
    V_0_PR=c*(NU./NU_0-1)*DIR_PR(ii)-V_BULK(ii);

    V_WIN=c./NU_0.*(A_0+GAMMA)*RANGE_SIG;

    V_MIN_SIG_PU(ii)=min(V_0_PU-V_WIN);
    V_MAX_SIG_PU(ii)=max(V_0_PU+V_WIN);

    V_MIN_SIG_PR(ii)=min(V_0_PR-V_WIN);
    V_MAX_SIG_PR(ii)=max(V_0_PR+V_WIN);

    %***********************************
    %Based on the density dist. function 
    %***********************************
    V_MIN_N(ii)=-sqrt(2*q*KT/m*RANGE_N)+V_BULK(ii);
    V_MAX_N(ii)=sqrt(2*q*KT/m*RANGE_N)+V_BULK(ii);
end 

if strcmpi(MODE,'PUMP')==1
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PUMP BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!%    
    
    %**************************
    %Assign velocity boundaries
    %**************************
    for ii=1:2
        V_MIN(ii)=min(V_MIN_SIG_PU(ii),V_MIN_N(ii));
        V_MAX(ii)=max(V_MAX_SIG_PU(ii),V_MAX_N(ii));
    end  
  
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PUMP BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!%  
    
elseif strcmpi(MODE,'PROBE')==1

    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!%    
   
    %**************************
    %Assign velocity boundaries
    %**************************
    for ii=1:2
        V_MIN(ii)=min(V_MIN_SIG_PR(ii),V_MIN_N(ii));
        V_MAX(ii)=max(V_MAX_SIG_PR(ii),V_MAX_N(ii));
    end 

    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!% 
    
elseif strcmpi(MODE,'BOTH')==1
    
    %!!!!!!!!!!!!!!!!!!!!!!!! PUMP AND PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!%     
    
    %**************************
    %Assign velocity boundaries
    %**************************
    for ii=1:2
        V_MIN(ii)=min([V_MIN_SIG_PU(ii),V_MIN_SIG_PR(ii),V_MIN_N(ii)]);
        V_MAX(ii)=max([V_MAX_SIG_PU(ii),V_MAX_SIG_PR(ii),V_MAX_N(ii)]);
    end     

    %!!!!!!!!!!!!!!!!!!!!!!!! PUMP AND PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!%  
    
end

if POP_DEN_LOG==1
    %*************************
    %Calc. velocity space grid
    %*************************  
    if NVXD==1
        VX_GRID=0;
    else
        VX_GRID(1:NVXD)=linspace(V_MIN(1),V_MAX(1),NVXD);
    end

    if NVYD==1
        VY_GRID=0;
    else
        VY_GRID(1:NVYD)=linspace(V_MIN(2),V_MAX(2),NVYD);
    end

    %*************************************
    %Calc. differential population density
    %*************************************
    dNG(1:NVXD,1:NVYD)=0;
    dNE(1:NVXD,1:NVYD)=0;
    T(1:NVXD,1:NVYD)=0;

    for ii=1:NVXD
        for jj=1:NVYD
            [dNG(ii,jj),dNE(ii,jj),T(ii,jj)]=DIFF_POPULATION_DENSITY(VX_GRID(ii),VY_GRID(jj),NU,I_PR,I_PU,PARA,UNIV);
        end
    end
    
    POP_DEN.NG=dNG;
    POP_DEN.NE=dNE;
    POP_DEN.T=T;
    POP_DEN.VX=VX_GRID;
    POP_DEN.VY=VY_GRID;
else
    POP_DEN=[];
end

if DIMENSION==1
    %*************************************************************
    %Assign function handle for differential absorption coefficent
    %*************************************************************
    FH=@(VX)DIFF_ABSORPTION_COEFF(VX,0,NU,I_PR,I_PU,PARA,UNIV); 

    %************************************************************
    %Integrate differential absorption coeff. over velocity space
    %************************************************************
    ALPHA=integral(FH,V_MIN(1),V_MAX(1),'AbsTol',ABS_ERR,'RelTol',REL_ERR);    
elseif DIMENSION==2
    %*************************************************************
    %Assign function handle for differential absorption coefficent
    %*************************************************************
    FH=@(VX,VY)DIFF_ABSORPTION_COEFF(VX,VY,NU,I_PR,I_PU,PARA,UNIV); 

    %************************************************************
    %Integrate differential absorption coeff. over velocity space
    %************************************************************
    ALPHA=quad2d(FH,V_MIN(1),V_MAX(1),V_MIN(2),V_MAX(2),'AbsTol',ABS_ERR,'RelTol',REL_ERR,'MaxFunEvals',FUN_EVAL);
end

end


