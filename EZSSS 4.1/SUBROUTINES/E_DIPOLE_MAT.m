function [MAT_P,MAT_0,MAT_M]=E_DIPOLE_MAT(PARA,UNIV)

%**************************************************************************
%This function calculates the relative intensity of all transitions induced
%by an ELECTRIC DIPOLE from intitial state with radial quantum number n(1)
%to final state with radial quantum number n(2) FOR HYDROGEN.

%**************************************************************************
%Calculating the matrix elements associated with the coupled basis set for 
%the electric dipole operator
%**************************************************************************
%                           <phi(ii)|eps*r|phi(jj)> 
%                       
%                         ii=[1:NS(1)] and jj=[1:NS(2)]
%**************************************************************************

%************
%Assign input
%************
NS=PARA.NS;
QN=PARA.QN;
WF=PARA.WF;

%***************
%Allocate memory
%***************
MAT_M(1:NS(1),1:NS(2))=0;
MAT_0(1:NS(1),1:NS(2))=0;
MAT_P(1:NS(1),1:NS(2))=0;

%//////////////////////////////////////////////////////////////////////////
%