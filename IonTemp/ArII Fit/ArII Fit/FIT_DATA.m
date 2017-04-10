function [B,KTN,CHI,RESULTS]=FIT_DATA(EXP,INS, BIN)

%*****************************
%Number of avaiable processors
%*****************************
NAP=4;

%***********************************
%Folder path containing fitting code
%***********************************
CODE_PATH=[pwd filesep 'IonTemp/ArII Fit/ArII Fit/Spectral Fit 2.1'];

%**********************
%Add spectral code path
%**********************
addpath(CODE_PATH)

%***********************
%Set the fitting options
%***********************
[LINE,OPT]=OPTIONS(NAP, BIN);

%************
%Fit the data
%************
[FIT,~,~]=MAIN(1,{EXP},{INS},LINE,OPT);

%*******************
%Assign the fit data
%*******************
RESULTS.NG=FIT.PROFILE{1}{1}.NG;
RESULTS.XG=FIT.PROFILE{1}{1}.XG;
RESULTS.IG=FIT.PROFILE{1}{1}.IGT;

%************************
%Assign the fit paramters
%************************
B=FIT.VAR{1}(6);
KTN=FIT.VAR{1}(10);
CHI=FIT.CHI{1};

%*************************
%Remove spectral code path
%*************************
rmpath(CODE_PATH)

end

