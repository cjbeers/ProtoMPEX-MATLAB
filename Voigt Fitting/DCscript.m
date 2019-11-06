close all
clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% See Further Documentation in DC.m
filename = 'Fiber3.txt'; % File name
range = 'all'; % 'all - Deconvolutes the full range, or [minx maxx]
np = 1; % Number of peaks
bg = 'bg1'; % Type of background ('bg1' - constant background, 'bg2','bg3' - sloped, 's' - shirley)
mode = 1; % Type of peak (1 - Voigt, 2 - Lognormal)

IG = 'full'; % Type of initial guess, 'auto' - peak location suggestion and automatic
             % initial guess generation and bounds.
             %                        'full' - same as 'auto', but you can
             %                        change initial guess and bounds
             %                        during fitting.
% Uncomment next four lines for manual initial guess and lower
% and upper bounds:
             %1                             2                               3                               4                               5                               6                               7                               
% parvec0 =   [802    ,284.1  ,0.5    ,1.12   ,10000   ,284.7  ,0.5    ,1.5    ,2240   ,285.5  ,0.5    ,0.7    ,500    ,286    ,0.5    ,1.4    ,353    ,287.5 ,0.5    ,1.31  ,133     ,289    ,0.5    ,2      ,399    ,290.5  ,0.5    ,1];
% lb =        [500    ,284    ,0      ,0      ,0       ,284.5  ,0      ,0.5    ,0      ,285.3  ,0      ,0      ,0      ,286    ,0      ,0      ,0      ,287.3	,0      ,0      ,0      ,288.6	,0      ,0      ,0      ,290    ,0      ,0]; 
% ub =        [20000  ,284.5  ,1      ,4.75   ,20000   ,284.9  ,1      ,4.75   ,20000  ,285.6  ,1      ,4.75   ,20000  ,286.70 ,1      ,4.75   ,20000  ,287.9	,1      ,4.75   ,20000  ,289.4	,1      ,4.75   ,20000  ,295	,1      ,3]; 
% IG = [parvec0 ; lb ; ub];
% Uncomment next two lines for manual initial guess and automatic lower and
% upper bounds:
% parvec0 = [5,10,22,0,13,15,27,1,15,20,60,0,33,10,80,1,10];
% IG = parvec0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deconvolution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ parameters,lb,ub,conf,graphdata,resnorm,residual,r2 ] = DC( filename , 'range' , range , 'np' , np , bg , 'IG' , IG , 'mode' , mode );