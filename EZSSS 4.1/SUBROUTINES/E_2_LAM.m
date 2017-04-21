function LAM=E_2_LAM(E)

%**************************************************************************
%This function converts units of energy to units of length -- energy of
%photon to wavelength of photon associated with the tranistions.
%**************************************************************************
%**************************************************************************
%                               INPUTS
%**************************************************************************
%dE - is a vector of length NT which contains the energies associated with
%     the transistions.  The units must be eV.
%
%NT - is the total number of transistions and the length of the vector dE
%
%**************************************************************************
%                               OUTPUTS
%**************************************************************************
%lam - is a vector of length NT which contains the wavelength of the
%      photons associated with energies dE.  The units are meters.
%
%**************************************************************************
%                           Universal Constants
%**************************************************************************
hbar=1.054571628e-34;
c=2.99792458e8;
q=1.602176487e-19;
%**************************************************************************

%********************
%Calc. the wavelength
%********************
LAM=(2*pi*hbar*c)./(E*q);

end