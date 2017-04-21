function SPECTRA=CROSS_WRAPPER(SPECTRA,OBS,PARA,UNIV,OPT)

%************
%Assign input
%************
PARALLEL=OPT.PARALLEL;
DFSS=OPT.DFSS;

%********************************
%Assign parallel processing logic
%********************************
PAR_LOG=PARALLEL.PAR_LOGIC;

%****************************
%Indentify crossover peak/dip 
%****************************
SPECTRA=CROSS_IDENTIFIER(SPECTRA,PARA,OPT);

if strcmpi(DFSS.CROSS.MODE,'SIM')==1  
    %*********************************************************
    %Calc. crossover peak/dip intensity from direct simulation
    %*********************************************************
    if PAR_LOG==0
        SPECTRA=CROSS_INTENSITY_SIM_SER(SPECTRA,OBS,PARA,UNIV,OPT); 
    else
        SPECTRA=CROSS_INTENSITY_SIM_PAR(SPECTRA,OBS,PARA,UNIV,OPT);
    end
elseif strcmpi(DFSS.CROSS.MODE,'TAB')==1
    %***********************************************
    %Interp. crossover peak/dip intensity from table
    %***********************************************

elseif strcmpi(DFSS.CROSS.MODE,'EQN')==1
    %************************************************
    %Calc. crossover peak/dip intensity from equation
    %************************************************
    SPECTRA=CROSS_INTENSITY_EQN(SPECTRA,OBS,UNIV,OPT); 
end

end