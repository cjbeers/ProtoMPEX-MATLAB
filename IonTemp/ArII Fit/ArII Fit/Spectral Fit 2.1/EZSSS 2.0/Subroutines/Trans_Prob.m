function DATA=Trans_Prob(DATA)

%**************************************************************************
%This function claculates the transition probabilites given by equation
%2.43 of Hans Griem's Principles of Plasma Spectroscopy
%**************************************************************************

hbar=1.05457173e-34;
e=1.60217657e-19;
eo=8.85418782e-12;

%************
%Assign input
%************
DISC=DATA.DISC;

I_DEG=DISC.I;
X_DEG=DISC.X;
NT_DEG=DISC.NT;

A=0;
for ii=1:NT_DEG
    A=A+4*e^2*pi^2/(3*hbar*eo*X_DEG(ii)^3)*I_DEG(ii);
end

DATA.TRAN=A;

end