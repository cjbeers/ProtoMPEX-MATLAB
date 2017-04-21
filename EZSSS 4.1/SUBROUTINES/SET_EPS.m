function EPS=SET_EPS(OBS)

%************
%Assign input
%************
POL=OBS.POL;
VIEW=OBS.VIEW;
MODE=OBS.MODE;

if strcmpi(MODE,'NO_INT')==1

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>        Calc. observeration cord vector components            <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>   
    
    %**************************
    %Define polarization vector
    %**************************
    EPS_X_A=-cos(VIEW.POLAR)*cos(VIEW.AZIM);
    EPS_Y_A=-cos(VIEW.POLAR)*sin(VIEW.AZIM);
    EPS_Z_A=sin(VIEW.POLAR);

    EPS_X_B=-sin(VIEW.AZIM);
    EPS_Y_B=cos(VIEW.AZIM);
    EPS_Z_B=0;

    %*******************
    %Define polarization 
    %*******************
    EPS_X_A_POL=POL.T(1)*(EPS_X_A*cos(POL.ANG)+EPS_X_B*sin(POL.ANG));
    EPS_Y_A_POL=POL.T(1)*(EPS_Y_A*cos(POL.ANG)+EPS_Y_B*sin(POL.ANG));
    EPS_Z_A_POL=POL.T(1)*(EPS_Z_A*cos(POL.ANG)+EPS_Z_B*sin(POL.ANG));

    EPS_X_B_POL=POL.T(2)*(-EPS_X_A*sin(POL.ANG)+EPS_X_B*cos(POL.ANG));
    EPS_Y_B_POL=POL.T(2)*(-EPS_Y_A*sin(POL.ANG)+EPS_Y_B*cos(POL.ANG));
    EPS_Z_B_POL=POL.T(2)*(-EPS_Z_A*sin(POL.ANG)+EPS_Z_B*cos(POL.ANG));

    %********************************************
    %Calc. spherical basis of polarization vector
    %********************************************
    EPS_SB_A(1)=-1/2^0.5*(EPS_X_A_POL+1i*EPS_Y_A_POL);
    EPS_SB_A(2)=EPS_Z_A_POL;
    EPS_SB_A(3)=1/2^0.5*(EPS_X_A_POL-1i*EPS_Y_A_POL);

    EPS_SB_B(1)=-1/2^0.5*(EPS_X_B_POL+1i*EPS_Y_B_POL);
    EPS_SB_B(2)=EPS_Z_B_POL;
    EPS_SB_B(3)=1/2^0.5*(EPS_X_B_POL-1i*EPS_Y_B_POL);  
    
    %**************************************
    %Set the observable polarization vector
    %**************************************
    EPS.SB_A=EPS_SB_A;
    EPS.SB_B=EPS_SB_B;
    
elseif strcmpi(MODE,'1D_INT')==1
 
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>        Calc. observeration cord vector components            <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>   
    
    %**************************
    %Define polarization vector
    %**************************
    C_1_A=(POL.T(1)*cos(POL.ANG))^2;
    C_2_A=(POL.T(1)*sin(POL.ANG))^2;
    
    C_1_B=(-POL.T(2)*sin(POL.ANG))^2;
    C_2_B=(POL.T(2)*cos(POL.ANG))^2;
    
    %*****************************
    %Calc. the geometrical factors 
    %*****************************
    GEO_M=pi*cos(VIEW.POLAR)^2*(C_1_A+C_1_B)+pi*(C_2_A+C_2_B);
    GEO_0=2*pi*sin(VIEW.POLAR)^2*(C_1_A+C_1_B);
    GEO_P=pi*cos(VIEW.POLAR)^2*(C_1_A+C_1_B)+pi*(C_2_A+C_2_B);
    
    %*************************************************************
    %Set the geometrical factor associated with the 1D integration
    %*************************************************************
    EPS.GEO_M=GEO_M;
    EPS.GEO_0=GEO_0;
    EPS.GEO_P=GEO_P;
    
elseif strcmpi(MODE,'2D_INT')==1
    
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>        Calc. observeration cord vector components            <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>   
    
    %**************************
    %Define polarization vector
    %**************************
    C_1_A=(POL.T(1)*cos(POL.ANG))^2;
    C_2_A=(POL.T(1)*sin(POL.ANG))^2;
    
    C_1_B=(-POL.T(2)*sin(POL.ANG))^2;
    C_2_B=(POL.T(2)*cos(POL.ANG))^2;
    
    %*****************************
    %Calc. the geometrical factors 
    %*****************************
    GEO_M=2/3*pi*(C_1_A+C_1_B)+2*pi*(C_2_A+C_2_B);
    GEO_0=8/3*pi*(C_1_A+C_1_B);
    GEO_P=2/3*pi*(C_1_A+C_1_B)+2*pi*(C_2_A+C_2_B);

    %*************************************************************
    %Set the geometrical factor associated with the 2D integration
    %*************************************************************
    EPS.GEO_M=GEO_M;
    EPS.GEO_0=GEO_0;
    EPS.GEO_P=GEO_P;    
    
end

end