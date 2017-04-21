function E=LAM_2_E(LAM)

%**************************************************************************
%This function converts units of energy to units of length -- energy of
%photon to wavelength of photon associated with the tranistions.
%**************************************************************************
%**************************************************************************
%                               INPUTS
%**************************************************************************
%lam - is a vector of length NT which contains the wavelengths associated
%      with the transistions.  The units must be m.
%
%NT - is the total number of transistions and the length of the vector dE
%
%**************************************************************************
%                               OUTPUTS
%**************************************************************************
%dE - is a vector of length NT which contains the energies of the
%      photons associated with wavelength lam.  The units are eV.
%
%**************************************************************************
%                           Universal Constants
%**************************************************************************
hbar=1.054571628e-34;
c=2.99792458e8;
q=1.602176487e-19;
%**************************************************************************

%****************
%Calc. the energy
%****************
E=(2*pi*hbar*c)./(LAM*q);

end