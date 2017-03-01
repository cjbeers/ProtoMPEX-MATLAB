function SIGMA=Doppler(kT,X,UNIV)

%**************************************************************************
%The Compile_Options.m function serves to determine the sigma parameter
%associated with the gaussian function based on the transition of interest
%and the temperature.
%
%   SIGMA=FWHM/(2*ln(2)^.5)
%
%**************************************************************************
%*******************              INPUTS             **********************
%**************************************************************************
%kT - Scalar. Temperature of emitting atom in eV.
%
%DOP - Array of lenth two. Contains the mass of the emitting atom in kg and
%      the center wavelength of the transition in angstrom respectively.
%**************************************************************************
%*******************             OUTPUTS             **********************
%**************************************************************************
%SIGMA - Scalar. Sigma parameter associated with the gaussian function in
%        angstrom.
%**************************************************************************

%************
%Assign input
%************
c=UNIV.c;                   
q=UNIV.q;  
m=UNIV.m;

%******************************
%Calc. the broadening parameter
%******************************
SIGMA=X*(2*q*kT/(m*c^2)).^.5;

end