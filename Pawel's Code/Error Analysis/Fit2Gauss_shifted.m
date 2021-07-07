%%%For a Instrument Function with a sigma_IF of 0.25 A Fit a Doppler
%%%Broadened spectrum of temperature give by a(1), baseline of a(2) and
%%%amplitude of a(3). Peak of the amplitude of the gaussian a(4)

function f = Fit2Gauss_shifted(a,x)
q   = 1.609e-19;
c   = 299792458;
amu = 1.67377e-27;
Mi  = 39.948*amu;
% Mi  = 4.*amu;

%%Define instrument broadening
sigma_IF = 0.25e-10/sqrt(log(2)*8);
%%Define Doppler broadening
lambda = 4806e-10;
sigma_DB = sqrt(a(1)*q/Mi/c^2)*lambda;
%%Final Gaussian broadening term
sigma2 = sqrt(sigma_DB^2+sigma_IF^2);
%%Convert to meters from nm
xnew   = x.*1e-9;
xshift = a(4)*1e-9;
f = a(3).*exp(-1/2*(xnew-xshift).^2./sigma2^2)+a(2);

end

