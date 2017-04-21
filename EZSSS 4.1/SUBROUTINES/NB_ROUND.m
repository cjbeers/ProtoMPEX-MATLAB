function [NB,NB_FL,NB_CL]=NB_ROUND(MODE,NB)

%**************************************************************************
%This function rounds the input number of Floquet blocks, NB, based on the
%logic variable MODE.  This is done because a smaller number of Floquet
%blocks can be used to accurately calculate the eigenvalues when compared 
%to the amount of Floquet blocks required for accurate eigenvectors.
%**************************************************************************

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%                                CONTROLS
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%The values for the following variables are set below for the mode of
%interest.
%
%NB_FLOOR - Minimum number of Floquet blocks
%
%NB_CEIL - Maximum number of Floquet blocks
%
%NB_MULT - Array of length two. Multiplier for unrounded number of Floquet
%          blocks
%
%   NB_MULT(1) - Multiplier if the unrounded number of Floquet blocks is 
%                less then unity.
%   
%   NB_MULT(2) - Multiplier if the unrounded number of Floquet blocks is 
%                greater then unity.
%
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%**************************************************************************
%*******************************MODE=1*************************************
NB_MULT(1:2,1)=[2 2];
NB_FLOOR(1)=4;
NB_CEIL(1)=120;
%*******************************MODE=1*************************************
%**************************************************************************

%**************************************************************************
%*******************************MODE=2*************************************
NB_MULT(1:2,2)=[1 1];
NB_FLOOR(2)=4;
NB_CEIL(2)=100;
%*******************************MODE=2*************************************
%**************************************************************************

if NB<=1
    NB=ceil(NB_MULT(1,MODE)*NB);
else
    NB=ceil(NB_MULT(2,MODE)*NB);
end

if NB<NB_FLOOR(MODE)
    NB=NB_FLOOR(MODE);
end

if NB>NB_CEIL(MODE)
    NB=NB_CEIL(MODE);
end

NB_FL=NB_FLOOR(MODE);
NB_CL=NB_CEIL(MODE);

end