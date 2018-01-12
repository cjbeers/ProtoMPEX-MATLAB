function Print_Para(PARA,OPT)

%******************
%Assiging the input
%******************
PSNM=PARA.FP.PSNM;
PSL=PARA.FP.PSL;
PSB=PARA.FP.PSB;
NDPS=PARA.FP.NDPS;
ND=PARA.FP.ND;
NS=PARA.FP.NS;
NI=PARA.FP.NI;

PSB_INS=PARA.IP.PSB;
NDPS_INS=PARA.IP.NDPS;
NI_INS=PARA.IP.NI;

NH_X=PARA.NP.NH_X;
NH_Y=PARA.NP.NH_Y;
NH_Z=PARA.NP.NH_Z;
NTG=PARA.NP.NTG;
NFL=PARA.NP.NFL;
NBG=PARA.NP.NBG;
NSPF=PARA.NP.NSPF;

NAP=OPT.NAP;
ALGO=OPT.SOLVER.ALGO;

%******************************
%Print fit parameters to screen
%******************************
fprintf('\n================================================================================\n')
fprintf('=============             Number of Spectra: %1i                     =============\n',NSPF)
fprintf('=============             Number of Fit Dimensions: %2i             =============\n',ND)
fprintf('=============             Number of Processors: %3i                =============\n',NAP)
fprintf('=============             Number of Minima Tracked: %2i             =============\n',NS)
if ALGO(1)==1
    fprintf('=============             Number of Main Iterations: %2i            =============\n',NI)
    if (ALGO(2)==1)
        fprintf('=============             Number of Instrument Iterations: %2i      =============\n',NI_INS)
    end
elseif ALGO(2)==1
    fprintf('=============             Number of Instrument Iterations: %2i      =============\n',NI_INS)
end
fprintf('================================================================================\n')
fprintf('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n')
fprintf('================================================================================\n')

for uu=1:NSPF
    %********************************
    %Assiging spectra specific values
    %********************************
    PSV=PARA.FP.PSV{uu};

    ll=0;


    fprintf('=============               Main Model - Spectra %1i of %1i            =============\n',uu,NSPF)
    fprintf('================================================================================\n')
    fprintf('\n=============                Obersvation Geometry                  =============\n\n')
    fprintf('                           THETA  -  Polar Angle\n')
    fprintf('                           PHI    -  Azimuthal Angle\n\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    if (PSL(1)==1)
        fprintf('                      THETA=%4.1f degrees\n',PSV(1)*180/pi)
    else
        ll=ll+1;
        if ALGO(1)==1
            fprintf('                      THETA=[%4.1f %4.1f] degrees --- NDPS=%2i\n',PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
        else
            fprintf('                      THETA=[%4.1f %4.1f] degrees\n',PSB(ll,1)*180/pi,PSB(ll,2)*180/pi)
        end
    end
    if (PSL(2)==1)
        fprintf('                      PHI=%4.1f degrees\n',PSV(2)*180/pi)
    else
        ll=ll+1;
        if ALGO(1)==1
            fprintf('                      PHI=[%4.1f %4.1f] degrees --- NDPS=%2i\n',PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
        else
            fprintf('                      PHI=[%4.1f %4.1f] degrees\n',PSB(ll,1)*180/pi,PSB(ll,2)*180/pi)
        end
    end
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    fprintf('=============                    Polarization                      =============\n\n')
    fprintf('                 SIGMA  -  Polarizer Angle\n')
    fprintf('                 T1     -  Transmission Percentage Parallel\n')
    fprintf('                 T2     -  Transmission Percentage Perpendicular\n\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    if (PSL(PSNM(1)+1)==1)
        fprintf('                      SIGMA=%3.1f degrees\n',PSV(PSNM(1)+1)*180/pi)
    else
        ll=ll+1;
        if ALGO(1)==1
            fprintf('                      SIGMA=[%3.1f %3.1f] degrees --- NDPS=%2i\n',PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
        else
            fprintf('                      SIGMA=[%3.1f %3.1f] degrees\n',PSB(ll,1)*180/pi,PSB(ll,2)*180/pi)
        end
    end
    if (PSL(PSNM(1)+2)==1)
        fprintf('                      T1=%4.1f per cent\n',PSV(PSNM(1)+2)*100)
    else
        ll=ll+1;
        if ALGO(1)==1
            fprintf('                      T1=[%4.1f %4.1f] per cent --- NDPS=%2i\n',PSB(ll,1)*100,PSB(ll,2)*100,NDPS(ll))
        else
            fprintf('                      T1=[%4.1f %4.1f] per cent\n',PSB(ll,1)*100,PSB(ll,2)*100)
        end
    end
    if (PSL(PSNM(1)+3)==1)
        fprintf('                      T2=%4.1f per cent\n',PSV(PSNM(1)+3)*100)
    else
        ll=ll+1;
        if ALGO(1)==1
            fprintf('                      T2=[%4.1f %4.1f] per cent --- NDPS=%2i\n',PSB(ll,1)*100,PSB(ll,2)*100,NDPS(ll))
        else
            fprintf('                      T2=[%4.1f %4.1f] per cent\n',PSB(ll,1)*100,PSB(ll,2)*100)
        end
    end
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    fprintf('=============                  Magnetic Field                      =============\n\n')
    fprintf('                                   B=B_Z\n\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    if (PSL(sum(PSNM(1:3)))==1)
        fprintf('                      B_Z=%3.1f T\n',PSV(sum(PSNM(1:3))))
    else
        ll=ll+1;
        if ALGO(1)==1
            fprintf('                      B_Z=[%3.1f %3.1f] T --- NDPS=%2i\n',PSB(ll,1),PSB(ll,2),NDPS(ll))
        else
            fprintf('                      B_Z=[%3.1f %3.1f] T\n',PSB(ll,1),PSB(ll,2))
        end
    end
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    fprintf('=============                   Electric Field                     =============\n\n')  
    fprintf('                      E_X(t)=E0')
    for ii=1:NH_X     
        if (ii==1)
            fprintf('+E%1i*cos(wt+c%1i)',ii,ii)
        else
            fprintf('+E%1i*cos(%1iwt+c%1i)',ii,ii,ii)
        end
    end
    fprintf('\n\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    if (PSL(sum(PSNM(1:3))+1)==1)
        fprintf('                      E0=%4.2f kV/cm\n',PSV(sum(PSNM(1:3))+1))
    else
        ll=ll+1;
        if ALGO(1)==1
            fprintf('                      E0=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',PSB(ll,1),PSB(ll,2),NDPS(ll)) 
        else
            fprintf('                      E0=[%4.2f %4.2f] kV/cm\n',PSB(ll,1),PSB(ll,2)) 
        end
    end
    for ii=1:NH_X
        if (PSL(sum(PSNM(1:3))+ii+1)==1)
            fprintf('                      E%1i=%4.2f kV/cm\n',ii,PSV(sum(PSNM(1:3))+ii+1))
        else
            ll=ll+1;
            if ALGO(1)==1
                fprintf('                      E%1i=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))
            else
                fprintf('                      E%1i=[%4.2f %4.2f] kV/cm\n',ii,PSB(ll,1),PSB(ll,2))
            end
        end
    end
    for ii=1:NH_X
        if (PSL(sum(PSNM(1:3))+ii+1+NH_X)==1)
            fprintf('                      c%1i=%4.2f deg\n',ii,PSV(sum(PSNM(1:3))+ii+1+NH_X)*180/pi)
        else
            ll=ll+1;
            if ALGO(1)==1
                fprintf('                      c%1i=[%4.2f %4.2f] deg --- NDPS=%2i\n',ii,PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
            else
                fprintf('                      c%1i=[%4.2f %4.2f] deg\n',ii,PSB(ll,1)*180/pi,PSB(ll,2)*180/pi)
            end
        end            
    end
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    fprintf('                      E_Y(t)=E0')
    for ii=1:NH_Y
        if (ii==1)
            fprintf('+E%1i*cos(wt+c%1i)',ii,ii)
        else
            fprintf('+E%1i*cos(%1iwt+c%1i)',ii,ii,ii)
        end
    end
    fprintf('\n\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    if (PSL(sum(PSNM(1:4))+1)==1)
        fprintf('                      E0=%4.2f kV/cm\n',PSV(sum(PSNM(1:4))+1))
    else
        ll=ll+1;
        if ALGO(1)==1
            fprintf('                      E0=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',PSB(ll,1),PSB(ll,2),NDPS(ll)) 
        else
            fprintf('                      E0=[%4.2f %4.2f] kV/cm\n',PSB(ll,1),PSB(ll,2)) 
        end
    end
    for ii=1:NH_Y
        if (PSL(sum(PSNM(1:4))+ii+1)==1)
            fprintf('                      E%1i=%4.2f kV/cm\n',ii,PSV(sum(PSNM(1:4))+ii+1))
        else
            ll=ll+1;
            if ALGO(1)==1
                fprintf('                      E%1i=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))
            else
                fprintf('                      E%1i=[%4.2f %4.2f] kV/cm\n',ii,PSB(ll,1),PSB(ll,2))
            end
        end
    end
    for ii=1:NH_Y
        if (PSL(sum(PSNM(1:4))+ii+1+NH_Y)==1)
            fprintf('                      c%1i=%4.2f deg\n',ii,PSV(sum(PSNM(1:4))+ii+1+NH_Y)*180/pi)
        else
            ll=ll+1;
            if ALGO(1)==1
                fprintf('                      c%1i=[%4.2f %4.2f] deg --- NDPS=%2i\n',ii,PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
            else
                fprintf('                      c%1i=[%4.2f %4.2f] deg\n',ii,PSB(ll,1)*180/pi,PSB(ll,2)*180/pi)
            end
        end            
    end
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    fprintf('                      E_Z(t)=E0')
    for ii=1:NH_Z        
        if (ii==1)
            fprintf('+E%1i*cos(wt+c%1i)',ii,ii)
        else
            fprintf('+E%1i*cos(%1iwt+c%1i)',ii,ii,ii)
        end
    end
    fprintf('\n\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    if (PSL(sum(PSNM(1:5))+1)==1)
        fprintf('                      E0=%4.2f kV/cm\n',PSV(sum(PSNM(1:5))+1))
    else
        ll=ll+1;
        if ALGO(1)==1
            fprintf('                      E0=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',PSB(ll,1),PSB(ll,2),NDPS(ll)) 
        else
            fprintf('                      E0=[%4.2f %4.2f] kV/cm\n',PSB(ll,1),PSB(ll,2)) 
        end
    end
    for ii=1:NH_Z
        if (PSL(sum(PSNM(1:5))+ii+1)==1)
            fprintf('                      E%1i=%4.2f kV/cm\n',ii,PSV(sum(PSNM(1:5))+ii+1))
        else
            ll=ll+1;
            if ALGO(1)==1
                fprintf('                      E%1i=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))
            else
                fprintf('                      E%1i=[%4.2f %4.2f] kV/cm\n',ii,PSB(ll,1),PSB(ll,2))
            end
        end
    end
    for ii=1:NH_Z
        if (PSL(sum(PSNM(1:5))+ii+1+NH_Z)==1)
            fprintf('                      c%1i=%4.2f deg\n',ii,PSV(sum(PSNM(1:5))+ii+1+NH_Z)*180/pi)
        else
            ll=ll+1;
            if ALGO(1)==1
                fprintf('                      c%1i=[%4.2f %4.2f] deg --- NDPS=%2i\n',ii,PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
            else
                fprintf('                      c%1i=[%4.2f %4.2f] deg\n',ii,PSB(ll,1)*180/pi,PSB(ll,2)*180/pi)
            end
        end            
    end
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    fprintf('=============           %1i-Temperature Group of Emitters            =============\n\n',NTG)
    for ii=1:NTG
        fprintf('                         Group %1i   ---   kT%1i   X%1i   I%1i\n',ii,ii,ii,ii) 
    end
    fprintf('\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    for ii=1:NTG
        if (PSL(sum(PSNM(1:6))+ii)==1)
            fprintf('                      kT%1i=%4.2f eV\n',ii,PSV(sum(PSNM(1:6))+ii))
        else
            ll=ll+1;
            if ALGO(1)==1
                fprintf('                      kT%1i=[%4.2f %4.2f] eV --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))  
            else
                fprintf('                      kT%1i=[%4.2f %4.2f] eV\n',ii,PSB(ll,1),PSB(ll,2))  
            end
        end
    end
    for ii=1:NTG
        if (PSL(sum(PSNM(1:7))+ii)==1)
            fprintf('                      X%1i=%4.2f A\n',ii,PSV(sum(PSNM(1:7))+ii))
        else
            ll=ll+1;
            if ALGO(1)==1
                fprintf('                      X%1i=[%4.2f %4.2f] A --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))  
            else
                fprintf('                      X%1i=[%4.2f %4.2f] A\n',ii,PSB(ll,1),PSB(ll,2))
            end
        end            
    end
    for ii=1:NTG
        if (PSL(sum(PSNM(1:8))+ii)==1)
            fprintf('                      I%1i=%4.2f per cent\n',ii,PSV(sum(PSNM(1:8))+ii)*100)
        else
            ll=ll+1;
            if ALGO(1)==1
                fprintf('                      I%1i=[%4.2f %4.2f] per cent --- NDPS=%2i\n',ii,PSB(ll,1)*100,PSB(ll,2)*100,NDPS(ll))
            else
                fprintf('                      I%1i=[%4.2f %4.2f] per cent\n',ii,PSB(ll,1)*100,PSB(ll,2)*100)
            end
        end            
    end
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    if (NFL>0)
        fprintf('=============              %1i-Lorentzian Functions               =============\n\n',NFL)
        for ii=1:NFL
            fprintf('                         Function %1i   ---   GAM%1i   X%1i   I%1i\n',ii,ii,ii,ii) 
        end
        fprintf('\n')
        fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
        for ii=1:NFL
            if (PSL(sum(PSNM(1:9))+ii)==1)
                fprintf('                      GAM%1i=%4.2f A\n',ii,PSV(sum(PSNM(1:9))+ii))
            else
                ll=ll+1;
                if ALGO(1)==1
                    fprintf('                      GAM%1i=[%4.2f %4.2f] A --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))  
                else
                    fprintf('                      GAM%1i=[%4.2f %4.2f] A\n',ii,PSB(ll,1),PSB(ll,2))  
                end
            end
        end
        for ii=1:NFL
            if (PSL(sum(PSNM(1:10))+ii)==1)
                fprintf('                      X%1i=%4.2f A\n',ii,PSV(sum(PSNM(1:10))+ii))
            else
                ll=ll+1;
                if ALGO(1)==1
                    fprintf('                      X%1i=[%4.2f %4.2f] A --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))  
                else
                    fprintf('                      X%1i=[%4.2f %4.2f] A\n',ii,PSB(ll,1),PSB(ll,2))
                end
            end            
        end
        for ii=1:NFL
            if (PSL(sum(PSNM(1:11))+ii)==1)
                fprintf('                      I%1i=%4.2f per cent\n',ii,PSV(sum(PSNM(1:11))+ii)*100)
            else
                ll=ll+1;
                if ALGO(1)==1
                    fprintf('                      I%1i=[%4.2f %4.2f] per cent --- NDPS=%2i\n',ii,PSB(ll,1)*100,PSB(ll,2)*100,NDPS(ll))
                else
                    fprintf('                      I%1i=[%4.2f %4.2f] per cent\n',ii,PSB(ll,1)*100,PSB(ll,2)*100)
                end
            end            
        end
        fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    end
    if NBG>0
        fprintf('=============           %1i-Groups of Background Emission            =============\n\n',NBG)
        for ii=1:NBG
            fprintf('                         Group %1i   ---   Io%1i\n',ii,ii) 
        end
        fprintf('\n')
        fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
        for ii=1:NBG
            if (PSL(sum(PSNM(1:12))+ii)==1)
                fprintf('                      Io%1i=%4.2f per cent\n',ii,PSV(sum(PSNM(1:12))+ii)*100)
            else
                ll=ll+1;
                if ALGO(1)==1
                    fprintf('                      Io%1i=[%4.2f %4.2f] per cent --- NDPS=%2i\n',ii,PSB(ll,1)*100,PSB(ll,2)*100,NDPS(ll))
                else
                    fprintf('                      Io%1i=[%4.2f %4.2f] per cent\n',ii,PSB(ll,1)*100,PSB(ll,2)*100)
                end
            end            
        end
        fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    end
    fprintf('=============              Instrument Fit Boundaries               =============\n\n')
    fprintf('                             VS - Vertical Scaling\n')
    fprintf('                             HS - Horizontal Shift\n\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    if ALGO(2)==1
        fprintf('                      VS=[%4.2f %4.2f] per cent --- NDPS=%2i\n',PSB_INS(1,1)*100,PSB_INS(1,2)*100,NDPS_INS(1)) 
    else
        fprintf('                      VS=[%4.2f %4.2f] per cent\n',PSB_INS(1,1)*100,PSB_INS(1,2)*100) 
    end
    if ALGO(2)==1
        fprintf('                      HS=[%4.2f %4.2f] A --- NDPS=%2i\n',PSB_INS(2,1),PSB_INS(2,2),NDPS_INS(2)) 
    else
        fprintf('                      HS=[%4.2f %4.2f] A\n',PSB_INS(2,1),PSB_INS(2,2)) 
    end
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    fprintf('================================================================================\n')
end

end