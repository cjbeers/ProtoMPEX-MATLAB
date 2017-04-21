function SIM=GEN_DF_SPEC(DATA_BOTH,DATA_PROBE,SPACE,FREQ)

%*********************
%Assign intensity data
%*********************
I_PU_PR=DATA_BOTH.I_PR;
I_PR=DATA_PROBE.I_PR;

NXP=SPACE.NXP;

NFP=FREQ.NFP;
NU=FREQ.NU;

%**********************************************************
%Calc. the resonant detuning frequncy (centered about zero)
%**********************************************************
NU_RDT=NU-(NU(1)+NU(NFP))/2;

%*************************
%Assign x-axis data in GHz
%*************************
X_DF(1:NFP)=NU_RDT/1e9;

%**************************
%Calc. Doppler-free profile
%**************************
I_DF(1:NFP)=(I_PU_PR(1:NFP,NXP)-I_PR(1:NFP,NXP));

%******************************************
%Calc. the peak DB and DF absorption signal
%******************************************
DB_ABS_PER=(1-min(DATA_BOTH.I_PR(1:NFP,NXP))/max(max(DATA_BOTH.I_PR)))*100;
DB_ABS_GAM=max(max(DATA_BOTH.I_PR))-min(DATA_BOTH.I_PR(1:NFP,NXP));

DF_ABS_PER=max(I_DF)/max(max(DATA_BOTH.I_PR))*100;
DF_ABS_GAM=max(I_DF);

%********************************
%Assign simulation data structure
%********************************
SIM.SPEC.NP=NFP;
SIM.SPEC.X=X_DF;
SIM.SPEC.I=I_DF;

SIM.ABS.DB.PERCENT=DB_ABS_PER;
SIM.ABS.DB.PHOTON=DB_ABS_GAM;
SIM.ABS.DF.PERCENT=DF_ABS_PER;
SIM.ABS.DF.PHOTON=DF_ABS_GAM;

end