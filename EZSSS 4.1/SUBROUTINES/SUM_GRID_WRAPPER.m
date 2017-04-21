function SPECTRA=SUM_GRID_WRAPPER(SPECTRA,OPT)

%************
%Assign input
%************
DISC=SPECTRA.DISC;

DFSS=OPT.DFSS;

%************
%Assign logic
%************C;
CR_LOG=DFSS.CROSS.LOGIC;
PEAK_LOG=strcmpi(DFSS.CROSS.PEAK,'0')~=1;
DIP_LOG=strcmpi(DFSS.CROSS.DIP,'0')~=1;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><>        Sum atomic transitions with the same wavelength           <><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%******************
%Assign the spectra
%******************
ATOMIC=DISC.FULL;

%**************************
%Sum degenerate transitions
%**************************
SUM=SUM_GRID(ATOMIC,OPT);

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><>            Sum crossover peaks with the same wavelength          <><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

if CR_LOG==1 && PEAK_LOG==1
    %******************
    %Assign the spectra
    %******************
    PEAK=DISC.FULL.PEAK;

    %**************************
    %Sum degenerate transitions
    %**************************
    PEAK=SUM_GRID(PEAK,OPT);
    
    %*************
    %Assign output
    %*************
    SUM.PEAK=PEAK;
end

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><>            Sum crossover dips with the same wavelength           <><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

if CR_LOG==1 && DIP_LOG==1
    %******************
    %Assign the spectra
    %******************
    DIP=DISC.FULL.DIP;

    %**************************
    %Sum degenerate transitions
    %**************************
    DIP=SUM_GRID(DIP,OPT);
    
    %*************
    %Assign output
    %*************
    SUM.DIP=DIP;
end

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%*************
%Assign output
%*************
SPECTRA.DISC.SUM=SUM;

end