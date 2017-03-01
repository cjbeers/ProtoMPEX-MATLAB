function DC_Stark=SSE_Ana(E,line,pol)

%**************************************************************************
%This function calculates the electric dipole allowed transitions for
%Hydrogen in the presence of a static electric field.  Relative intensities
%where taken from Nils Ryde: Atoms and Molecules in Electric Fields
%**************************************************************************
%**************************************************************************
%                               INPUTS
%**************************************************************************
%EDC=EDC_z - The static electric field with only a z-component.  The units
%            must be V/m.
%                   
%                       EDC_z -- z-component
%
%line - Logic determining the transition of interest. 
%
%                       line=1 -- H_alpha
%
%                       line=2 -- H_beta
%
%                       line=3 -- H_gamma
%
%pol - Logic determining the polarization of interest. 
%
%                       pol=1 -- pi polarization
%
%                       pol=2 -- sigam polarization
%
%                       pol=3 -- unobserved polarization
%
%**************************************************************************
%                               OUTPUT
%**************************************************************************
%DC_Stark=[I dE NT] -  is a cell array containing the calculated intensities
%                      and energies associated with the nondegenerate  
%                      dipole allowed transitions. The intensities are  
%                      in arbitary units and the energies are in eV.     
%                      
%                       I - array of length NT containing the intensites
%                           of the dipole allowed transitions.              
%
%                       dE - array of length NT containing the energies of  
%                            the dipole allowed transitions.  The units are       
%                            eV     
%
%                       NT - number of transitions
%
%**************************************************************************
%                           Universal Constants
%**************************************************************************
h=2*pi*1.054571628e-34;
q=1.602176487e-19;
c=2.99792458e8;

%**************************************************************************
%Defining the line center
%**************************************************************************
if (line==1)
    lam_o=656.463215e-9;
elseif (line==2)
    lam_o=486.2690742e-9;
elseif (line==3)
    lam_o=434.1691277e-9;
end
nu_o=c/lam_o;

%**************************************************************************
%Relative intenties and QN parameter
%**************************************************************************
if (line==1)
    if (pol==1)
        I=[1 1681 2304 729 1 1681 2304 729];
        X=[8 4 3 2 -8 -4 -3 -2];
    elseif (pol==2)
        I=[18 16 1936 18 16 1936 4608+882];
        X=[6 5 1 -6 -5 -1 0];
    elseif (pol==3)
        I=[1 1681 2304 729 1 1681 2304 729 18 16 1936 18 16 1936 4608+882];
        X=[8 4 3 2 -8 -4 -3 -2 6 5 1 -6 -5 -1 0];      
    end
end 
    
if (line==2)
    if (pol==1)
        I=[1 361 384 81 9 1 361 384 81 9];
        X=[14 10 8 6 2 -14 -10 -8 -6 -2];
    elseif (pol==2)
        I=[8 6 294 72 384 72 8 6 294 72 384 72];
        X=[12 10 6 4 4 2 -12 -10 -6 -4 -4 -2];
    elseif (pol==3)
        I=[1 361 384 81 9 1 361 384 81 9 8 6 294 72 384 72 8 6 294 72 384 72];
        X=[14 10 8 6 2 -14 -10 -8 -6 -2 12 10 6 4 4 2 -12 -10 -6 -4 -4 -2];      
    end
end 
    
if (line==3)
    if (pol==1)
        I=[729 131769 115200 16641 1521 19200 15625 729 131769 115200 16641 1521 19200 15625];
        X=[22 18 15 12 8 5 2 -22 -18 -15 -12 -8 -5 -2];
    elseif (pol==2)
        I=[4050 2592 83232 76800 11250 5808 46128 4050 2592 83232 76800 11250 5808 46128 115200+26450];
        X=[20 17 13 10 10 7 3 -20 -17 -13 -10 -10 -7 -3 0];
    elseif (pol==3)
        I=[729 131769 115200 16641 1521 19200 15625 729 131769 115200 16641 1521 19200 15625 4050 2592 83232 76800 11250 5808 46128 4050 2592 83232 76800 11250 5808 46128 115200+26450];
        X=[22 18 15 12 8 5 2 -22 -18 -15 -12 -8 -5 -2 20 17 13 10 10 7 3 -20 -17 -13 -10 -10 -7 -3 0];    
    end
end

%**************************************************************************
%Number of transitions associated with the line
%**************************************************************************
NT=length(I);

%**************************************************************************
%First order DC Stark effect in units of frequency
%**************************************************************************
nu_DC=1.9179893e4*E;

%**************************************************************************
%Calculating the first order correct energy associated with the transitions
%**************************************************************************
dE(1:NT)=0;
for ii=1:NT
    dE(ii)=h*(nu_DC*X(ii)+nu_o)/q;
end

%**************************************************************************
%Output data
%**************************************************************************
DC_Stark{1}=I;
DC_Stark{2}=dE;
DC_Stark{3}=NT;

end