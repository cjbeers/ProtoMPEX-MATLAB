%% Initialize Variables

cleanup

Flux=7e23;
Area=(8/1000)^2*pi;
Yield=0.005;
AvNum=6.022e23;
MassSi=40.11;
Fluence=5e25;

%% Calculate Number of shots needed

SputteredAtoms=Flux*Yield*Area;

Moles=SputteredAtoms/AvNum;
GramsSputtered=Moles*MassSi

TotalMassLoss=Fluence/Flux*GramsSputtered
NumberOfShots=Fluence/Flux