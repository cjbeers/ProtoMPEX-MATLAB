cleanup

T_e_eV=5; %ion temperature in eV
T_i_eV=T_e_eV; %electron temperature in eV
amu_N=14.0097; %amu of N
amu_Kr=83.8; %amu of Kr
amu_W=183.84; %amu of W
amu_Ar=39.948; %amu of Ar

Z=1;
eV_impact=2*T_i_eV+3*Z*T_e_eV; %Ion impact energy [eV
gamma=(4*amu_W*amu_Kr)/((amu_W+amu_Kr)^2); %Was eq. 1.14 for maximum energy transfered 
Transfered_Kr2W=gamma*eV_impact;

Z=4; % charge state of ion
eV_impact=2*T_i_eV+3*Z*T_e_eV; %Ion impact energy [eV
gamma=(4*amu_W*amu_N)/((amu_W+amu_N)^2); %Was eq. 1.14 for maximum energy transfered 
Transfered_N2W=gamma*eV_impact;

Z=2;
eV_impact=2*T_i_eV+3*Z*T_e_eV; %Ion impact energy [eV
gamma=(4*amu_W*amu_Ar)/((amu_W+amu_Ar)^2); %Was eq. 1.14 for maximum energy transfered 
Transfered_Ar2W=gamma*eV_impact;


