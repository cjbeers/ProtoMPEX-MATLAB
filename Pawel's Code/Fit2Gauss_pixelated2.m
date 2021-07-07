%%%For a Instrument Function with a sigma_IF of 0.25 A Fit a Doppler
%%%Broadened spectrum of temperature give by a(1), shift of peak given by 
%%%a(2) and amplitude of a(3). a(4) is the baseline. This function now pixelates the data by dpix

function f = Fit2Gauss_pixelated2(a,x,IF)

%%%Define physical constants here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q   = 1.6021766208e-19;
c   = 299792458;
amu = 1.66054e-27;
Mi  = 39.948*amu;
lambda0 = 4806.03e-10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%Create high resolution vector here for pixelation%%%%%%%%%%%%%%%%%%%%%%
dpix = abs(max(diff(x)));
lambda_HR = linspace(x(1),x(end),length(x)*1000);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%Convert to SI units from "fitting units"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ti     = a(1)*1e1;
xnew   = lambda_HR.*1e-9;
% xnew   = x.*1e-9;
xshift = a(2)*1e-9;
alpha  = a(3)*1e-2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%Define Broadening Here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Define IF sigma
sigma_IF = IF/sqrt(log(2)*8.0);
%%%Define Doppler Broadening sigma
sigma_DB = sqrt(Ti*q/Mi/c^2)*lambda0;
%%%Define Total Broadening
sigma2 = sqrt(sigma_DB^2+sigma_IF^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%Define High Resolution Gaussian Here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_HR = exp(-1/2*(xnew-xshift).^2./sigma2^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%Pixelate the data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Initialize vector
f = zeros(1,length(x));
%%%Pixelate
for ii = 1:length(x)
    int_lim = lambda_HR>(x(ii)-(dpix-alpha)) & lambda_HR<(x(ii)+(alpha));
    f(ii) = trapz(lambda_HR(int_lim),f_HR(int_lim))./(-dpix); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = f./max(f);

end

