function SPECTRA=SCALE_WRAPPER(SPECTRA,OBS,PARA,UNIV,OPT)

%************
%Assign input
%************
PARALLEL=OPT.PARALLEL;
DFSS=OPT.DFSS;

%********************************
%Assign parallel processing logic
%********************************
PAR_LOG=PARALLEL.PAR_LOGIC;

if strcmpi(DFSS.SCALE.MODE,'SIM')==1  
    %********************************************
    %Calc. absorption rate from direct simulation
    %********************************************
    if PAR_LOG==0
        SPECTRA=SCALE_INTENSITY_SIM_SER(SPECTRA,OBS,PARA,UNIV,OPT); 
    else
        SPECTRA=SCALE_INTENSITY_SIM_PAR(SPECTRA,OBS,PARA,UNIV,OPT);
    end
elseif strcmpi(DFSS.SCALE.MODE,'TAB')==1
    %**********************************
    %Interp. absorption rate from table
    %**********************************
    SPECTRA=SCALE_INTENSITY_TAB(SPECTRA,OBS,PARA,OPT);
elseif strcmpi(DFSS.SCALE.MODE,'EQN')==1
    %***********************************
    %Calc. absorption rate from equation
    %***********************************
    SPECTRA=SCALE_INTENSITY_EQN(SPECTRA,OBS,PARA,OPT);
end

end