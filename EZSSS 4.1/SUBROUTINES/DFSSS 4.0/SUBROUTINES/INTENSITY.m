function DATA=INTENSITY(NU,SPACE,PARA,UNIV)

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%|||||||||||||||             Assign parameters             ||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

ATOMIC=PARA.ATOMIC;
LASER=PARA.LASER;
VELOCITY=PARA.VELOCITY;
MODE=PARA.MODE;

                %%%%%%%%%%%%%%%%%% SPACE %%%%%%%%%%%%%%%%%%%
X=SPACE.X;
NXP=SPACE.NXP;
                %%%%%%%%%%%%%%%%%% SPACE %%%%%%%%%%%%%%%%%%%

                %%%%%%%%%%%%%%%%% ATOMIC %%%%%%%%%%%%%%%%%%%
N=ATOMIC.N;

G=ATOMIC.G;

V_BULK=ATOMIC.V_BULK;
KT=ATOMIC.KT;
                %%%%%%%%%%%%%%%%% ATOMIC %%%%%%%%%%%%%%%%%%%
                
                %%%%%%%%%%%%%%%% VELOCITY %%%%%%%%%%%%%%%%%%
POP_DEN_LOG=VELOCITY.POP_DEN_LOGIC;
NVXD=VELOCITY.NVXD;
NVYD=VELOCITY.NVYD;
                %%%%%%%%%%%%%%%% VELOCITY %%%%%%%%%%%%%%%%%%
                
                %%%%%%%%%%%% UNIVERSAL CONSTANTS %%%%%%%%%%%
h=UNIV.h;
q=UNIV.q;
m=UNIV.m;
                %%%%%%%%%%%% UNIVERSAL CONSTANTS %%%%%%%%%%%

%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%***************
%Allocate memory
%***************
ALPHA(1:NXP)=0;
ALPHA(1)=nan;

POP_DEN=cell(1,NXP);
SAT(1:NXP)=0;

%**********************
%Assign laser intensity
%**********************
I.PR=zeros(1,NXP);
I.PU=zeros(1,NXP);

if strcmpi(MODE,'PUMP')==1
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PUMP BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!% 
    
    %******************************
    %Assign the orginal laser power
    %******************************
    P_0_PU=LASER.PU.P_0;    

    %*************************************
    %Calculate the initial laser intensity
    %*************************************
    I.PU(1)=P_0_PU/(h*NU);    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%   Calc. the spatially dependent laser intensity     %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for ii=2:NXP
        %********************************
        %Assign iteration laser intensity
        %********************************
        I_PR=I.PR(ii-1);
        I_PU=I.PU(ii-1);
        
        %********************************
        %Calc. the absorption coefficient
        %********************************
        [ALPHA(ii),POP_DEN{ii}]=ABSORPTION_COEFF(NU,I_PR,I_PU,PARA,UNIV);
        
        %*****************************
        %Calc. the new laser intensity
        %*****************************
        I.PU(ii)=I.PU(ii-1)*exp(-abs(X(ii)-X(ii-1))*ALPHA(ii));
    end
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PUMP BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!% 
    
elseif strcmpi(MODE,'PROBE')==1
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    
    %******************************
    %Assign the orginal laser power
    %******************************
    P_0_PR=LASER.PR.P_0;    

    %*************************************
    %Calculate the initial laser intensity
    %*************************************
    I.PR(1)=P_0_PR/(h*NU);    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%   Calc. the spatially dependent laser intensity     %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for ii=2:NXP  
        %********************************
        %Assign iteration laser intensity
        %********************************
        I_PR=I.PR(ii-1);
        I_PU=I.PU(ii-1);
        
        %********************************
        %Calc. the absorption coefficient
        %********************************
        [ALPHA(ii),POP_DEN{ii}]=ABSORPTION_COEFF(NU,I_PR,I_PU,PARA,UNIV);

        %*****************************
        %Calc. the new laser intensity
        %*****************************
        I.PR(ii)=I.PR(ii-1)*exp(-abs(X(ii)-X(ii-1))*ALPHA(ii));
    end
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    
elseif strcmpi(MODE,'BOTH')==1
    
    %!!!!!!!!!!!!!!!!!!!!!!!! PUMP AND PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!%
    
    %******************************
    %Assign the orginal laser power
    %******************************
    P_0_PU=LASER.PU.P_0;
    P_0_PR=LASER.PR.P_0;    
    
    %*************************************
    %Calculate the initial laser intensity
    %*************************************
    I.PU(1)=P_0_PU/(h*NU);
    I.PR(1)=P_0_PR/(h*NU);    
    
    %********************************
    %Assign iteration laser intensity
    %********************************
    I_PR=I.PR(1);
    I_PU=I.PU(1);
    
    %********************************
    %Calc. the absorption coefficient
    %********************************
    [ALPHA_TEMP,POP_DEN_TEMP]=ABSORPTION_COEFF(NU,I_PR,I_PU,PARA,UNIV);
    
    %*****************************
    %Assign first iteration values
    %*****************************
    ALPHA(2:NXP)=ALPHA_TEMP;
    POP_DEN(2:NXP)={POP_DEN_TEMP};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%   Calc. the spatially dependent laser intensity     %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for ii=2:NXP    
        I.PU(ii)=I.PU(ii-1)*exp(-abs(X(ii)-X(ii-1))*ALPHA(ii));
        I.PR(ii)=I.PR(ii-1)*exp(-abs(X(ii)-X(ii-1))*ALPHA(ii));
    end
    
    %!!!!!!!!!!!!!!!!!!!!!!!! PUMP AND PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!%
    
end

if POP_DEN_LOG==1
    %*************************
    %Assign velocity grid data
    %*************************
    VX_GRID=POP_DEN{2}.VX;
    VY_GRID=POP_DEN{2}.VY;

    NG(1:NVXD,1:NVYD)=0;
    NE(1:NVXD,1:NVYD)=0;
    T(1:NVXD,1:NVYD)=0;
    for ii=1:NVXD
        for jj=1:NVYD
            %*******************************
            %Calc. velocity vector magnitude
            %*******************************
            V_N_SQUARED=(VX_GRID(ii)-V_BULK(1)).^2+(VY_GRID(jj)-V_BULK(2)).^2;

            %**************************
            %Calc. ground state density
            %**************************
            NG(ii,jj)=N*(m/(2*pi*q*KT))*exp(-m*V_N_SQUARED/(2*q*KT));
        end
    end

    %*************************************
    %Assign inital population density data
    %*************************************
    POP_DEN{1}.NG=NG;
    POP_DEN{1}.NE=NE;
    POP_DEN{1}.T=T;
    POP_DEN{1}.VX=VX_GRID;
    POP_DEN{1}.VY=VY_GRID;
    
    %***********************************************
    %Calc. the saturation fraction at the maximum NE
    %***********************************************
    SAT(1)=0;
    for ii=2:NXP
        %**************************
        %Find indices of maximum NE
        %**************************
        [MAX,IND_X]=max(POP_DEN{ii}.NE);
        [~,IND_Y]=max(MAX);
        IND_X=IND_X(IND_Y);
        
        %*************************
        %Calc. saturation fraction
        %*************************
        SAT(ii)=(G+1)/G*POP_DEN{ii}.NE(IND_X,IND_Y)/POP_DEN{1}.NG(IND_X,IND_Y);
    end
else
    POP_DEN=[];
    SAT=[];
end

%***********************
%Assign output structure
%***********************
DATA.I=I;
DATA.ALPHA=ALPHA;
DATA.POP_DEN=POP_DEN;
DATA.SAT=SAT;

end