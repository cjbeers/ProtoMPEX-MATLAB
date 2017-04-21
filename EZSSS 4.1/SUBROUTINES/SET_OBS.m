function OBS=SET_OBS(VAR)

%************
%Assign input
%************
OBS=VAR.OBS;

%*********************************
%Assign logic for view integration
%*********************************
if isfield(OBS,'MODE')==0 
    OBS.MODE='NO_INT';
end

%*****************************
%Assign unpolarized parameters
%*****************************
if OBS.POL.LOGIC==0

    OBS.POL.ANG=0;    
    OBS.POL.T=[1 1]; 
end

end