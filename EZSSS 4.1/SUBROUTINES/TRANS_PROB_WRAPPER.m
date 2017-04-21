function SPECTRA=TRANS_PROB_WRAPPER(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT)

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>        Calc. observeration cord vector components            <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 

EPS=SET_EPS(OBS);

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>           Calc. electric dipole matrix elements              <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 

[MAT_P,MAT_0,MAT_M]=E_DIPOLE_MAT(PARA,UNIV);

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>                Calc. transition probablities                 <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> 

SPECTRA=TRANS_PROB(EVec,EVal,EPS,MAT_P,MAT_0,MAT_M,OBS,PARA,FIELD,UNIV,OPT);

end

