function OPT=READ_SIM_DATA(OPT)

%************
%Assign input
%************
DFSS=OPT.DFSS;

%***********************
%Assign scale parameters
%***********************
SC_LOG=DFSS.SCALE.LOGIC;
SC_MODE=DFSS.SCALE.MODE;
SC_DATA=DFSS.SCALE.DATA;

%***********************
%Assign scale parameters
%***********************
CR_LOG=DFSS.CROSS.LOGIC;
CR_MODE=DFSS.CROSS.MODE;
CR_DATA=DFSS.CROSS.DATA;

if SC_LOG==1 && strcmpi(SC_MODE,'TAB')==1 && isempty(SC_DATA)==1
    %***************
    %Read scale data
    %***************
    SC_DATA=load('SCALE_DATA.mat');
    
    %*****************
    %Assign scale data
    %*****************
    DFSS.SCALE.DATA=SC_DATA;
end

if CR_LOG==1 && strcmpi(CR_MODE,'TAB')==1 && isempty(CR_DATA)==1
    %*******************
    %Read crossover data
    %*******************
    CR_DATA=load('CROSS_DATA.mat');
    
    %*********************
    %Assign crossover data
    %*********************
    DFSS.CROSS.DATA=CR_DATA;
end

%*************
%Assign output
%*************
OPT.DFSS=DFSS;

end