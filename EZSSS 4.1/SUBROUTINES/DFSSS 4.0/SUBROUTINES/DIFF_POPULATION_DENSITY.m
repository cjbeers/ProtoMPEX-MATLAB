function [dNG,dNE,T]=DIFF_POPULATION_DENSITY(VX,VY,NU,I_PR,I_PU,PARA,UNIV)
 
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%|||||||||||||||             Assign parameters             ||||||||||||||||
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

ATOMIC=PARA.ATOMIC;
LASER=PARA.LASER;
MODE=PARA.MODE;

              %%%%%%%%%%%%%%%%%%% ATOMIC %%%%%%%%%%%%%%%%%%%
N=ATOMIC.N;
              
NT_0=ATOMIC.NT_0;
A_0=ATOMIC.A_0;
A_0_TOT=ATOMIC.A_0_TOT;
NU_0=ATOMIC.NU_0;

G=ATOMIC.G;
GAMMA=ATOMIC.GAMMA;

V_BULK=ATOMIC.V_BULK;
KT=ATOMIC.KT;
              %%%%%%%%%%%%%%%%%%% ATOMIC %%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%%% LASER %%%%%%%%%%%%%%%%%%%%
AREA_PU=LASER.PU.AREA;
AREA_PR=LASER.PR.AREA;

DIR_PU=LASER.PU.DIRECTION;
DIR_PR=LASER.PR.DIRECTION;
              %%%%%%%%%%%%%%%%%%% LASER %%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%% UNIVERSAL CONSTANTS %%%%%%%%%%%%%
q=UNIV.q;
c=UNIV.c;
m=UNIV.m;
              %%%%%%%%%%%% UNIVERSAL CONSTANTS %%%%%%%%%%%%%

%|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| 
     
if strcmpi(MODE,'PUMP')==1
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PUMP BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!%

                 %%%%%%%%%%%% CALC. CROSS-SECTION %%%%%%%%%%%%%
    
    %******************************************
    %Project velocity vector onto line of sight
    %******************************************
    V_MAG_SIG=(VX+V_BULK(1))*DIR_PU(1)+(VY+V_BULK(2))*DIR_PU(2);
    
    %******************************************************
    %Calc. the stimulated absorption/emission cross-section
    %******************************************************
    SIG_PU=0;
    for ii=1:NT_0
        SIG_PU=SIG_PU+c^2/(NU^2*pi)*(A_0(ii)/(A_0(ii)+GAMMA))*((A_0(ii)+GAMMA)^2/4)./((NU-NU_0(ii)*(1+V_MAG_SIG/c)).^2+((A_0(ii)+GAMMA)^2/4));
    end
    
                 %%%%%%%%%%%% CALC. CROSS-SECTION %%%%%%%%%%%%%
                 
                 %%%%%%%%%% CALC. POPULATION DENSITY %%%%%%%%%%
    
    %****************
    %Calc. laser flux
    %****************
    PHI_PU=I_PU/AREA_PU;
    
    %*****************************************************
    %Calc. the excited and ground state population density
    %*****************************************************
    NE=(N*SIG_PU*PHI_PU*G)./(A_0_TOT+SIG_PU*PHI_PU*(G+1));
    NG=N-NE;
        
                 %%%%%%%%%% CALC. POPULATION DENSITY %%%%%%%%%%
              
    %**********************
    %Calc. equilibrium time
    %**********************
    T=5/(A_0_TOT+SIG_PU*PHI_PU*(G+1)); 
                 
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PUMP BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!%    

elseif strcmpi(MODE,'PROBE')==1
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!%

                 %%%%%%%%%%%% CALC. CROSS-SECTION %%%%%%%%%%%%%
    
    %******************************************
    %Project velocity vector onto line of sight
    %******************************************
    V_MAG_SIG=(VX+V_BULK(1))*DIR_PR(1)+(VY+V_BULK(2))*DIR_PR(2);
    
    %******************************************************
    %Calc. the stimulated absorption/emission cross-section
    %******************************************************
    SIG_PR=0;
    for ii=1:NT_0
        SIG_PR=SIG_PR+c^2/(NU^2*pi)*(A_0(ii)/(A_0(ii)+GAMMA))*((A_0(ii)+GAMMA)^2/4)./((NU-NU_0(ii)*(1+V_MAG_SIG/c)).^2+((A_0(ii)+GAMMA)^2/4));
    end

                 %%%%%%%%%%%% CALC. CROSS-SECTION %%%%%%%%%%%%%
                 
                 %%%%%%%%%% CALC. POPULATION DENSITY %%%%%%%%%%
    
    %****************
    %Calc. laser flux
    %****************
    PHI_PR=I_PR/AREA_PR;
    
    %*****************************************************
    %Calc. the excited and ground state population density
    %*****************************************************
    NE=(N*SIG_PR*PHI_PR*G)./(A_0_TOT+SIG_PR*PHI_PR*(G+1));
    NG=N-NE;
        
                 %%%%%%%%%% CALC. POPULATION DENSITY %%%%%%%%%%
              
    %**********************
    %Calc. equilibrium time
    %**********************
    T=5/(A_0_TOT+SIG_PR*PHI_PR*(G+1));  
                 
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    
elseif strcmpi(MODE,'BOTH')==1
    
    %!!!!!!!!!!!!!!!!!!!!!!!! PUMP AND PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!%

                 %%%%%%%%%%%% CALC. CROSS-SECTION %%%%%%%%%%%%%
    
    %******************************************
    %Project velocity vector onto line of sight
    %******************************************
    V_MAG_SIG_PU=(VX+V_BULK(1))*DIR_PU(1)+(VY+V_BULK(2))*DIR_PU(2);
    V_MAG_SIG_PR=(VX+V_BULK(1))*DIR_PR(1)+(VY+V_BULK(2))*DIR_PR(2);
    
    %******************************************************
    %Calc. the stimulated absorption/emission cross-section
    %******************************************************
    SIG_PU=0;
    SIG_PR=0;
    for ii=1:NT_0
        SIG_PU=SIG_PU+c^2/(NU^2*pi)*(A_0(ii)/(A_0(ii)+GAMMA))*((A_0(ii)+GAMMA)^2/4)./((NU-NU_0(ii)*(1+V_MAG_SIG_PU/c)).^2+((A_0(ii)+GAMMA)^2/4));
        SIG_PR=SIG_PR+c^2/(NU^2*pi)*(A_0(ii)/(A_0(ii)+GAMMA))*((A_0(ii)+GAMMA)^2/4)./((NU-NU_0(ii)*(1+V_MAG_SIG_PR/c)).^2+((A_0(ii)+GAMMA)^2/4));
    end

                 %%%%%%%%%%%% CALC. CROSS-SECTION %%%%%%%%%%%%%
                 
                 %%%%%%%%%% CALC. POPULATION DENSITY %%%%%%%%%%

    %****************
    %Calc. laser flux
    %****************
    PHI_PU=I_PU/AREA_PU;
    PHI_PR=I_PR/AREA_PR;
    
    %*****************************************************
    %Calc. the excited and ground state population density
    %*****************************************************
    NE=(N*(SIG_PU*PHI_PU+SIG_PR*PHI_PR)*G)./(A_0_TOT+(SIG_PU*PHI_PU+SIG_PR*PHI_PR)*(G+1));
    NG=N-NE; 
    
                 %%%%%%%%%% CALC. POPULATION DENSITY %%%%%%%%%% 

    %**********************
    %Calc. equilibrium time
    %**********************
    T=5/(A_0_TOT+(SIG_PU*PHI_PU+SIG_PR*PHI_PR)*(G+1)); 
                 
    %!!!!!!!!!!!!!!!!!!!!!!!! PUMP AND PROBE BEAM !!!!!!!!!!!!!!!!!!!!!!!!%  
    
end

                 %%%%%%%%% CALC. DIFFERENTIAL DENSITY %%%%%%%%%
              
%*******************************
%Calc. velocity vector magnitude
%*******************************
V_N_SQUARED=(VX-V_BULK(1)).^2+(VY-V_BULK(2)).^2;

%******************************************************************
%Calc. the differential excited and ground state population density
%******************************************************************
dNG=NG*(m/(2*pi*q*KT)).*exp(-m*V_N_SQUARED/(2*q*KT));
dNE=NE*(m/(2*pi*q*KT)).*exp(-m*V_N_SQUARED/(2*q*KT));
    
                 %%%%%%%%% CALC. DIFFERENTIAL DENSITY %%%%%%%%%

end

