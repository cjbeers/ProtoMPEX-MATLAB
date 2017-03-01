clear all
close all
clc

NS=24;
ERF_LIM=[0,2e5];

NP_G=200;

AXIS=[.0 2 4861.6 4863.8];

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||| DEFINE DOPPLER BROADENING OPTIONS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.DOP.NTG=1;                       
SPEC.DOP.I=1;                     
SPEC.DOP.X=0*1e-10;               
SPEC.DOP.kT=.85;
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||| DEFINE GAUSSIAN BROADENING OPTIONS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.GAU.NF=1;                        
SPEC.GAU.I=1;                
SPEC.GAU.X=0*1e-10;               
SPEC.GAU.SIG=0.15*1e-10;         
SPEC.GAU.NX_SIG=30;                    
SPEC.GAU.NSIG=5; 
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||| DEFINE LORENTZIAN BROADENING OPTIONS ||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.LOR.NF=0;
SPEC.LOR.I=1;                          
SPEC.LOR.X=0;                          
SPEC.LOR.GAM=.014*1e-10;                  
SPEC.LOR.NX_GAM=30;                    
SPEC.LOR.NGAM=15; 
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||| DEFINE SPECTRUM and PLOT OPTIONS ||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SPEC.NORM=1;

PLOT.SPEC.LOGIC=0;
PLOT.GEO.LOGIC=0;

PRINT.TIME=0;                       
PRINT.TRAN=0;                          
PRINT.QSA=0;
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||||| DEFINE SOLVER OPTIONS |||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
SOLVER.QSA=1;                      
SOLVER.NDT=30;
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||||||| DEFINE FIELD AND ATOM OPTIONS ||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
VAR.VIEW=[pi/3.3 0];
VAR.LINE={2  'H'  .5  [2 4]};
VAR.B_MAG=3.5;
VAR.EDC_MAG=[0 0 0]*1e5;
VAR.NU=1;
VAR.ERF_ANG=[0 0 0];

POL{1}=[0 0];
POL{2}=[0 pi/2];

ERF=linspace(ERF_LIM(1),ERF_LIM(2),NS);

ERF_MAG=cell(1,NS);
for ii=1:NS
    ERF_MAG{1,ii}=[ERF(ii) 0 0];
    ERF_MAG{2,ii}=[0 ERF(ii) 0];
    ERF_MAG{3,ii}=[0 0 ERF(ii)];
end
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


%****************************
%Generate path name for EZSSS
%****************************
PATH=pwd;
for ii=length(PATH):-1:1
    if strcmpi(PATH(ii),filesep)==1
        PATH=PATH(1:ii-1);
        break
    end
end

%********
%Add path
%********
addpath(PATH)

%******************
%Assign the options
%******************
OPT.SOLVER=SOLVER;
OPT.SPEC=SPEC;
OPT.PLOT=PLOT;
OPT.PRINT=PRINT;

%*********************
%Calculate the spectra
%*********************
VAR_PAR=cell(2,3,NS);
for ii=1:2  
    for jj=1:3
        for kk=1:NS
            VAR.POL=POL{ii};
            VAR.ERF_MAG=ERF_MAG{jj,kk};
            
            VAR_PAR{ii,jj,kk}=VAR;
        end
    end
end

DATA=cell(2,3,NS);
for ii=1:2
    for jj=1:3
        fprintf('%2i of %2i - %2i of %2i\n',ii,2,jj,3)
        
        parfor kk=1:NS
            [DATA{ii,jj,kk},~]=EZSSS(VAR_PAR{ii,jj,kk},OPT);
        end
    end
end

%************************
%Assign the spectral data
%************************
I=cell(2,3,NS);
X=cell(2,3,NS);
for ii=1:2
    for jj=1:3
        for kk=1:NS
            I{ii,jj,kk}=DATA{ii,jj,kk}.CONT.I;
            X{ii,jj,kk}=DATA{ii,jj,kk}.CONT.X;
        end
    end
end

%*****************************
%Gen. X grid for interpolation
%*****************************
XMIN(1:2,1:3,1:NS)=0;
XMAX(1:2,1:3,1:NS)=0;
for ii=1:2
    for jj=1:3
        for kk=1:NS
            XMIN(ii,jj,kk)=min(X{ii,jj,kk});
            XMAX(ii,jj,kk)=max(X{ii,jj,kk});
        end
    end
end
XMIN=max(max(max(XMIN)));
XMAX=min(min(min(XMAX)));

X_G=linspace(XMIN,XMAX,NP_G);

%*******************************
%Interp. the spectra to the grid
%*******************************
I_G=cell(2,3,NS);
for ii=1:2
    for jj=1:3
        for kk=1:NS
            I_G{ii,jj,kk}=interp1(X{ii,jj,kk},I{ii,jj,kk},X_G);
        end
    end
end

%***********************************
%Calc. the difference in the spectra
%***********************************
I_EXEY(1:NS,1:NP_G)=0;
I_EXEZ(1:NS,1:NP_G)=0;
I_EYEZ(1:NS,1:NP_G)=0;
for kk=1:NS
    if POL{1}(1)==1
        I_EXEY(kk,1:NP_G)=abs(I_G{1,1,kk}-I_G{1,2,kk})+abs(I_G{2,1,kk}-I_G{2,2,kk});
        I_EXEZ(kk,1:NP_G)=abs(I_G{1,1,kk}-I_G{1,3,kk})+abs(I_G{2,1,kk}-I_G{2,3,kk});
        I_EYEZ(kk,1:NP_G)=abs(I_G{1,2,kk}-I_G{1,3,kk})+abs(I_G{2,2,kk}-I_G{2,3,kk});
    else
        I_EXEY(kk,1:NP_G)=abs(I_G{1,1,kk}-I_G{1,2,kk});
        I_EXEZ(kk,1:NP_G)=abs(I_G{1,1,kk}-I_G{1,3,kk});
        I_EYEZ(kk,1:NP_G)=abs(I_G{1,2,kk}-I_G{1,3,kk});
    end
end

I_EX0EX(1:NS,1:NP_G)=0;
I_EY0EY(1:NS,1:NP_G)=0;
I_EZ0EZ(1:NS,1:NP_G)=0;
for kk=1:NS
    if POL{1}(1)==1
        I_EX0EX(kk,1:NP_G)=abs(I_G{1,1,1}-I_G{1,1,kk})+abs(I_G{2,1,1}-I_G{2,1,kk});
        I_EY0EY(kk,1:NP_G)=abs(I_G{1,2,1}-I_G{1,2,kk})+abs(I_G{2,2,1}-I_G{2,2,kk});
        I_EZ0EZ(kk,1:NP_G)=abs(I_G{1,3,1}-I_G{1,3,kk})+abs(I_G{2,3,1}-I_G{2,3,kk});
    else
        I_EX0EX(kk,1:NP_G)=abs(I_G{1,1,1}-I_G{1,1,kk});
        I_EY0EY(kk,1:NP_G)=abs(I_G{1,2,1}-I_G{1,2,kk});
        I_EZ0EZ(kk,1:NP_G)=abs(I_G{1,3,1}-I_G{1,3,kk});
    end
end

figure
contourf(ERF/1e5,X_G*1e10,I_EXEY.'*100,'LineStyle','none')
xlabel('|E| (kV/cm)','FontSize',38)
ylabel(['Wavelength (' char(197) ')'],'FontSize',38)
if POL{1}(1)==1 
    title('|i(E_x)-i(E_y)|_{\pi} + |i(E_x)-i(E_y)|_{\sigma}','FontSize',38)
else
    title('|i(E_x)-i(E_y)|_{unpolarized}','FontSize',38)
end
set(gca,'FontSize',38)  
axis(AXIS)
colorbar 

figure
contourf(ERF/1e5,X_G*1e10,I_EXEZ.'*100,'LineStyle','none')
xlabel('|E| (kV/cm)','FontSize',38)
ylabel(['Wavelength (' char(197) ')'],'FontSize',38)
if POL{1}(1)==1     
    title('|i(E_x)-i(E_z)|_{\pi} + |i(E_x)-i(E_z)|_{\sigma}','FontSize',38)
else
    title('|i(E_x)-i(E_z)|_{unpolarized}','FontSize',38)
end
set(gca,'FontSize',38) 
axis(AXIS)
colorbar 

figure
contourf(ERF/1e5,X_G*1e10,I_EYEZ.'*100,'LineStyle','none')
xlabel('|E| (kV/cm)','FontSize',38)
ylabel(['Wavelength (' char(197) ')'],'FontSize',38)
if POL{1}(1)==1  
    title('|i(E_y)-i(E_z)|_{\pi} + |i(E_y)-i(E_z)|_{\sigma}','FontSize',38)
else
    title('|i(E_y)-i(E_z)|_{unpolarized}','FontSize',38)
end
set(gca,'FontSize',38) 
axis(AXIS)
colorbar 

figure
contourf(ERF/1e5,X_G*1e10,I_EX0EX.'*100,'LineStyle','none')
xlabel('|E| (kV/cm)','FontSize',38)
ylabel(['Wavelength (' char(197) ')'],'FontSize',38)
if POL{1}(1)==1    
    title('|i(E_x=0)-i(E_x)|_{\pi} + |i(E_x=0)-i(E_x)|_{\sigma}','FontSize',38)
else
    title('|i(E_x=0)-i(E_x)|_{unpolarized}','FontSize',38)
end
set(gca,'FontSize',38)  
axis(AXIS)
colorbar 

figure
contourf(ERF/1e5,X_G*1e10,I_EY0EY.'*100,'LineStyle','none')
xlabel('|E| (kV/cm)','FontSize',38)
ylabel(['Wavelength (' char(197) ')'],'FontSize',38)
if POL{1}(1)==1
    title('|i(E_y=0)-i(E_y)|_{\pi} + |i(E_y=0)-i(E_y)|_{\sigma}','FontSize',38)
else
    title('|i(E_y=0)-i(E_y)|_{unpolarized}','FontSize',38)
end
set(gca,'FontSize',38) 
axis(AXIS)
colorbar

figure
contourf(ERF/1e5,X_G*1e10,I_EZ0EZ.'*100,'LineStyle','none')
xlabel('|E| (kV/cm)','FontSize',38)
ylabel(['Wavelength (' char(197) ')'],'FontSize',38)
if POL{1}(1)==1
    title('|i(E_z=0)-i(E_z)|_{\pi} + |i(E_z=0)-i(E_z)|_{\sigma}','FontSize',38)
else
    title('|i(E_z=0)-i(E_z)|_{unpolarized}','FontSize',38)
end 
set(gca,'FontSize',38) 
axis(AXIS)
colorbar 

%***********
%Remove path
%***********
rmpath(PATH)