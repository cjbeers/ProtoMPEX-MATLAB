function Print_Para_Back(PARA_BACK,BGN)

%******************
%Assiging the input
%******************
PSNM=PARA_BACK.FP.PSNM;
PSL=PARA_BACK.FP.PSL;    
PSB=PARA_BACK.FP.PSB;
NDPS=PARA_BACK.FP.NDPS;
ND=PARA_BACK.FP.ND;

NH_X=PARA_BACK.NP.NH_X;
NH_Y=PARA_BACK.NP.NH_Y;
NH_Z=PARA_BACK.NP.NH_Z;
NTG=PARA_BACK.NP.NTG;
NFL=PARA_BACK.NP.NFL;
NSPF=PARA_BACK.NP.NSPF;

%******************************
%Print fit parameters to screen
%******************************
fprintf('\n================================================================================\n')
fprintf('=============        Number of Background Fit Dimensions: %2i       =============\n',ND)
fprintf('================================================================================\n')
fprintf('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n')
fprintf('================================================================================\n')
for uu=1:NSPF
    %********************************
    %Assiging spectra specific values
    %********************************
    PSV=PARA_BACK.FP.PSV{uu};

    ll=0;

    fprintf('==========         Group %i --- Background Model - Spectra %1i of %1i        ========\n',BGN,uu,NSPF)
    fprintf('================================================================================\n')
    fprintf('\n=============                Obersvation Geometry                  =============\n\n')
    fprintf('                           THETA  -  Polar Angle\n')
    fprintf('                           PHI    -  Azimuthal Angle\n\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    if (PSL(1)==1)
        fprintf('                      THETA=%4.1f degrees\n',PSV(1)*180/pi)
    else
        ll=ll+1;
        fprintf('                      THETA=[%4.1f %4.1f] degrees --- NDPS=%2i\n',PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
    end
    if (PSL(2)==1)
        fprintf('                      PHI=%4.1f degrees\n',PSV(2)*180/pi)
    else
        ll=ll+1;
        fprintf('                      PHI=[%4.1f %4.1f] degrees --- NDPS=%2i\n',PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
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
        fprintf('                      SIGMA=[%3.1f %3.1f] degrees --- NDPS=%2i\n',PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
    end
    if (PSL(PSNM(1)+2)==1)
        fprintf('                      T1=%4.1f per cent\n',PSV(PSNM(1)+2)*100)
    else
        ll=ll+1;
        fprintf('                      T1=[%4.1f %4.1f] per cent --- NDPS=%2i\n',PSB(ll,1)*100,PSB(ll,2)*100,NDPS(ll))
    end
    if (PSL(PSNM(1)+3)==1)
        fprintf('                      T2=%4.1f per cent\n',PSV(PSNM(1)+3)*100)
    else
        ll=ll+1;
        fprintf('                      T2=[%4.1f %4.1f] per cent --- NDPS=%2i\n',PSB(ll,1)*100,PSB(ll,2)*100,NDPS(ll))
    end
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    fprintf('=============                  Magnetic Field                      =============\n\n')
    fprintf('                                   B=B_Z\n\n')
    fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    if (PSL(sum(PSNM(1:3)))==1)
        fprintf('                      B_Z=%3.1f T\n',PSV(sum(PSNM(1:3))))
    else
        ll=ll+1;
        fprintf('                      B_Z=[%3.1f %3.1f] T --- NDPS=%2i\n',PSB(ll,1),PSB(ll,2),NDPS(ll))
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
        fprintf('                      E0=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',PSB(ll,1),PSB(ll,2),NDPS(ll)) 
    end
    for ii=1:NH_X
        if (PSL(sum(PSNM(1:3))+ii+1)==1)
            fprintf('                      E%1i=%4.2f kV/cm\n',ii,PSV(sum(PSNM(1:3))+ii+1))
        else
            ll=ll+1;
            fprintf('                      E%1i=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))
        end
    end
    for ii=1:NH_X
        if (PSL(sum(PSNM(1:3))+ii+1+NH_X)==1)
            fprintf('                      c%1i=%4.2f deg\n',ii,PSV(sum(PSNM(1:3))+ii+1+NH_X)*180/pi)
        else
            ll=ll+1;
            fprintf('                      c%1i=[%4.2f %4.2f] deg --- NDPS=%2i\n',ii,PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
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
        fprintf('                      E0=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',PSB(ll,1),PSB(ll,2),NDPS(ll)) 
    end
    for ii=1:NH_Y
        if (PSL(sum(PSNM(1:4))+ii+1)==1)
            fprintf('                      E%1i=%4.2f kV/cm\n',ii,PSV(sum(PSNM(1:4))+ii+1))
        else
            ll=ll+1;
            fprintf('                      E%1i=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))
        end
    end
    for ii=1:NH_Y
        if (PSL(sum(PSNM(1:4))+ii+1+NH_Y)==1)
            fprintf('                      c%1i=%4.2f deg\n',ii,PSV(sum(PSNM(1:4))+ii+1+NH_Y)*180/pi)
        else
            ll=ll+1;
            fprintf('                      c%1i=[%4.2f %4.2f] deg --- NDPS=%2i\n',ii,PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
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
        fprintf('                      E0=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',PSB(ll,1),PSB(ll,2),NDPS(ll)) 
    end
    for ii=1:NH_Z
        if (PSL(sum(PSNM(1:5))+ii+1)==1)
            fprintf('                      E%1i=%4.2f kV/cm\n',ii,PSV(sum(PSNM(1:5))+ii+1))
        else
            ll=ll+1;
            fprintf('                      E%1i=[%4.2f %4.2f] kV/cm --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))
        end
    end
    for ii=1:NH_Z
        if (PSL(sum(PSNM(1:5))+ii+1+NH_Z)==1)
            fprintf('                      c%1i=%4.2f deg\n',ii,PSV(sum(PSNM(1:5))+ii+1+NH_Z)*180/pi)
        else
            ll=ll+1;
            fprintf('                      c%1i=[%4.2f %4.2f] deg --- NDPS=%2i\n',ii,PSB(ll,1)*180/pi,PSB(ll,2)*180/pi,NDPS(ll))
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
            fprintf('                      kT%1i=[%4.2f %4.2f] eV --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))  
        end
    end
    for ii=1:NTG
        if (PSL(sum(PSNM(1:7))+ii)==1)
            fprintf('                      X%1i=%4.2f A\n',ii,PSV(sum(PSNM(1:7))+ii))
        else
            ll=ll+1;
            fprintf('                      X%1i=[%4.2f %4.2f] A --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))  
        end            
    end
    for ii=1:NTG
        if (PSL(sum(PSNM(1:8))+ii)==1)
            fprintf('                      I%1i=%4.2f per cent\n',ii,PSV(sum(PSNM(1:8))+ii)*100)
        else
            ll=ll+1;
            fprintf('                      I%1i=[%4.2f %4.2f] per cent --- NDPS=%2i\n',ii,PSB(ll,1)*100,PSB(ll,2)*100,NDPS(ll))
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
                fprintf('                      GAM%1i=[%4.2f %4.2f] A --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))  
            end
        end
        for ii=1:NFL
            if (PSL(sum(PSNM(1:10))+ii)==1)
                fprintf('                      X%1i=%4.2f A\n',ii,PSV(sum(PSNM(1:10))+ii))
            else
                ll=ll+1;
                fprintf('                      X%1i=[%4.2f %4.2f] A --- NDPS=%2i\n',ii,PSB(ll,1),PSB(ll,2),NDPS(ll))  
            end            
        end
        for ii=1:NFL
            if (PSL(sum(PSNM(1:11))+ii)==1)
                fprintf('                      I%1i=%4.2f per cent\n',ii,PSV(sum(PSNM(1:11))+ii)*100)
            else
                ll=ll+1;
                fprintf('                      I%1i=[%4.2f %4.2f] per cent --- NDPS=%2i\n',ii,PSB(ll,1)*100,PSB(ll,2)*100,NDPS(ll))
            end            
        end
        fprintf('                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n')
    end
    fprintf('================================================================================\n')
end

end