close all
clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% See Further Documentation in DC.m
filename = 'example, 4 peaks.txt'; % File name
range = 'all'; % 'all - Deconvolutes the full range, or [minx maxx]
np = 4; % Number of peaks
bg = 'bg1'; % Type of background ('bg1' - constant background, 'bg2','bg3' - sloped, 's' - shirley)
mode = 1; % Type of peak (1 - Voigt, 2 - Lognormal)

IG = 'auto'; % Type of initial guess, 'auto' - peak location suggestion and automatic
             % initial guess generation and bounds.
             %                        'full' - same as 'auto', but you can
             %                        change initial guess and bounds
             %                        during fitting.

% Uncomment next two lines for manual initial guess and automatic lower and
% upper bounds (IG = 'auto' is then ignored):
% parvec0 =   [5,10,22,0,13,15,27,1,15,20,60,0,33,10,80,1,10];
% lb =        [4,09,20,0,12,14,26,0,14,19,59,0,32,09,79,0,09]; 
% ub =        [6,11,25,1,14,16,28,1,16,21,61,1,34,11,81,1,11]; 
% IG = [parvec0 ; lb ; ub];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deconvolution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ parameters,lb,ub,conf,graphdata,resnorm,residual,r2 ] = DC( filename , 'range' , range , 'np' , np , bg , 'IG' , IG , 'mode' , mode );