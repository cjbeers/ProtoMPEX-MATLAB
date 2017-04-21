function PRINT_RESULTS(SPECTRA,FIELD,PARA,OPT)

%************
%Assign input
%************
SOLVER=OPT.SOLVER;
DFSS=OPT.DFSS;
SPEC=OPT.SPEC;

B=FIELD.B;
EDC=FIELD.EDC;
ERF=FIELD.ERF;

NH=ERF.NH;

%**********************
%Assign logic variables
%**********************
B_LOG=B.LOGIC;
EDC_LOG=EDC.LOGIC;
ERF_LOG=ERF.LOGIC;

QSA_LOG=SOLVER.QSA_LOGIC;
MAN_LOG=SOLVER.MAN_LOGIC;
SC_LOG=DFSS.SCALE.LOGIC;
CR_LOG=DFSS.CROSS.LOGIC;
NORM_LOG=SPEC.NORM_LOGIC;
SUM_LOG=SPEC.SUM.LOGIC;

%******************
%Assign solver mode
%******************
if ERF_LOG==1 && QSA_LOG==0 
    SOLVER_MODE='Floquet Calculation';
elseif ERF_LOG==1 && QSA_LOG==1 && MAN_LOG==0  
    SOLVER_MODE='QSA Calculation - Automatic Discretization';
elseif QSA_LOG==1 && MAN_LOG==1  
    SOLVER_MODE='QSA Calculation - Manual Discretization';
elseif ERF_LOG==0 
    SOLVER_MODE='Static Calculation';
end

%*************************
%Default length of boarder
%*************************
NBD=50;

%******************
%Assign buffer text
%******************
BUF_LEFT='~~~  ';
BUF_RIGHT='  ~~~';

NBL=length(BUF_LEFT);
NBR=length(BUF_RIGHT);

%*****************
%Initialize indice
%*****************
zz=0;

%******************
%Assign solver text
%******************
zz=zz+1;
SOLVER_TEXT=[BUF_LEFT SOLVER_MODE '%s' BUF_RIGHT]; 
NF(zz)=length(SOLVER_TEXT)-2;

%*****************
%Assign field text
%*****************
zz=zz+1;
FIELD_TEXT=[BUF_LEFT 'Magnetic and Electric Field' '%s' BUF_RIGHT]; 
NF(zz)=length(FIELD_TEXT)-2;

%*******************
%Assign B-field text
%*******************
zz=zz+1;
if B_LOG==0
    B_TEXT=[BUF_LEFT 'No Magnetic Field' '%s' BUF_RIGHT]; 
    NF(zz)=length(B_TEXT)-2;
else
    if B.MAG>=.5
        B_TEXT=[BUF_LEFT 'B_z=%4.1f T' '%s' BUF_RIGHT];
        NF(zz)=length(B_TEXT)-3;
        
        B_MAG=B.MAG;
    else
        B_TEXT=[BUF_LEFT 'B_z=%4.0f Gauss' '%s' BUF_RIGHT]; 
        NF(zz)=length(B_TEXT)-3;
        
        B_MAG=B.MAG*1e4;
    end
end

%*********************
%Assign EDC-field text
%*********************
zz=zz+1;
if EDC_LOG==0
    EDC_TEXT=[BUF_LEFT 'No DC Electric Field' '%s' BUF_RIGHT]; 
    NF(zz)=length(EDC_TEXT)-2;
else
    if sum(abs(EDC.MAG))>=.5e5
        EDC_TEXT=[BUF_LEFT 'EDC_x=%4.1f EDC_y=%4.1f EDC_z=%4.1f kV/cm' '%s' BUF_RIGHT];
        NF(zz)=length(EDC_TEXT)-5;
        
        EDC_MAG=EDC.MAG/1e5;
    else
        EDC_TEXT=[BUF_LEFT 'EDC_x=%4.0f EDC_y=%4.0f EDC_z=%4.0f V/cm' '%s' BUF_RIGHT];
        NF(zz)=length(EDC_TEXT)-5;
        
        EDC_MAG=EDC.MAG/1e2;
    end
end

%*********************
%Assign ERF-field text
%*********************
zz=zz+1;
if ERF_LOG==0
    ERF_TEXT=[BUF_LEFT 'No RF Electric Field' '%s' BUF_RIGHT]; 
    NF(zz)=length(ERF_TEXT)-2;
else
    if ERF.NU>1e9
        ERF_TEXT=[BUF_LEFT 'ERF -> %1i Harmonics and Fundamental=%4.1f GHz' '%s' BUF_RIGHT]; 
        NF(zz)=length(ERF_TEXT)-5;
        
        NU=ERF.NU/1e9;
    else
        ERF_TEXT=[BUF_LEFT 'ERF -> %1i Harmonics and Fundamental=%4.1f MHz' '%s' BUF_RIGHT]; 
        NF(zz)=length(ERF_TEXT)-5;
        
        NU=ERF.NU/1e6;
    end
end


if ERF_LOG==1
    zz=zz+1;
    
    if sum(sum(abs(ERF.MAG)))>=.5e5
        ERF_MAG_TEXT=[BUF_LEFT 'NH=%1i - MAG_x=%4.1f MAG_y=%4.1f MAG_z=%4.1f kV/cm' '%s' BUF_RIGHT];
        NF(zz)=length(ERF_MAG_TEXT)-7;
        
        ERF_MAG=ERF.MAG/1e5;
    else
        ERF_MAG_TEXT=[BUF_LEFT 'NH=%1i - MAG_x=%4.0f MAG_y=%4.0f MAG_z=%4.0f V/cm' '%s' BUF_RIGHT];
        NF(zz)=length(ERF_MAG_TEXT)-7;
        
        ERF_MAG=ERF.MAG/1e2;
    end

    zz=zz+1;
    
    ERF_ANG_TEXT=[BUF_LEFT '       PHA_x=%4.1f PHA_y=%4.1f PHA_z=%4.1f degree' '%s' BUF_RIGHT];
    NF(zz)=length(ERF_ANG_TEXT)-5;

    ERF_ANG=ERF.ANG*180/pi;
end

%**********************
%Assign max text length
%**********************
NBD=max([NBD NF]);

%********************
%Calc. size of filler
%********************
NFF=NBD-NF;

FILL=cell(1,zz);
for ii=1:zz
    FILL{ii}(1:NFF(ii))=' ';
end

%*****************
%Assign empty text
%*****************
EMPTY_TEXT(1:NBD-NBL-NBR)=' ';
EMPTY_TEXT=[BUF_LEFT EMPTY_TEXT BUF_RIGHT];

%******************************
%Assign boarder and buffer text
%******************************
BOARDER(1:NBD)='~';

%*****************
%Print solver type
%*****************
fprintf('\n%s\n',BOARDER)
fprintf([SOLVER_TEXT '\n'],FILL{1})
fprintf('%s\n',BOARDER)

%**********************
%Print field parameters
%**********************
fprintf('\n%s\n',BOARDER)
fprintf([FIELD_TEXT '\n'],FILL{2})
fprintf('%s\n',BOARDER)
if B_LOG==0
    fprintf([B_TEXT '\n'],FILL{3})
else
    fprintf([B_TEXT '\n'],B_MAG,FILL{3})
end
fprintf([EMPTY_TEXT '\n']);
if EDC_LOG==0
    fprintf([EDC_TEXT '\n'],FILL{4})
else
    fprintf([EDC_TEXT '\n'],EDC_MAG(1),EDC_MAG(2),EDC_MAG(3),FILL{4})
end
fprintf([EMPTY_TEXT '\n']);
if ERF_LOG==0
    fprintf([ERF_TEXT '\n'],FILL{5})
else
    fprintf([ERF_TEXT '\n'],NH,NU,FILL{5})
    for ii=1:NH
        fprintf([ERF_MAG_TEXT '\n'],ii,ERF_MAG(ii,1),ERF_MAG(ii,2),ERF_MAG(ii,3),FILL{6})
        fprintf([ERF_ANG_TEXT '\n'],ERF_ANG(ii,1),ERF_ANG(ii,2),ERF_ANG(ii,3),FILL{7})
    end
end
fprintf('%s\n',BOARDER)

end