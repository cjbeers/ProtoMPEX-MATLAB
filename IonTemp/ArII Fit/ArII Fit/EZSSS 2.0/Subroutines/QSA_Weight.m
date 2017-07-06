function EQS=QSA_Weight(FIELD,OPT)

%**************************************************************************
%This function outputs an array of field strengths for the spectral line 
%calculation assuming that the quantum states respond instantaneously to 
%the electric field:
%
%           EDC+ERF(1)*cos(nu*t)+ERF(2)*cos(2*nu*t+PHA_ANG)
%
%The electric field waveform is discritized into NP equal time cells, thus 
%the weights associated with each time cell are equal.  Essentially the
%wieghts are in the distrubtion of field strength values in the output
%array
%
%EDC - DC electric field in V/m
%
%ERF=[ERF(1) ERF(2)] - The RF electric field magnitude in V/m.  ERF(1) is 
%                      the fundamental and ERF(2) is the first harmonic.
%
%PHA_ANG - The phase angle between the RF fundamental and first harmonic.
%          The Phase angle must be in degrees.
%
%NP - Number of cells the waveform is discritized into
%**************************************************************************

PLOT_ON=0;

%************
%Assign input
%************
EDC=FIELD.EDC.MAG;
ERF=FIELD.ERF.MAG;
PHA=FIELD.ERF.ANG;
NU=FIELD.ERF.NU;
NH=FIELD.ERF.NH;

NDT=OPT.SOLVER.NDT;

%*****************
%Discritizing time
%*****************
dT=1/(NDT*NU);
TA=dT/2:dT:(1/NU-dT/2);

%**************************************
%Discretize the electric field waveform
%**************************************
EQS(1:3,1:NDT)=0;
for ii=1:3
    EQS(ii,1:NDT)=EDC(ii);
    for jj=1:NH
        EQS(ii,1:NDT)=EQS(ii,1:NDT)+ERF(jj,ii)/(2*pi*jj*NU*dT)*(sin(2*pi*jj*NU*(TA+dT/2)+PHA(jj,ii))-sin(2*pi*jj*NU*(TA-dT/2)+PHA(jj,ii)));
    end
end

if (PLOT_ON==1)
    %********************
    %Numer of time points
    %********************
    NTP=2000;    
    
    %****
    %Time
    %****
    T=linspace(0,1/NU,NTP);    
    
    %**********************************
    %Calc. the continous electric field
    %**********************************
    E_MAX(1:3)=0;
    E_MIN(1:3)=0;
    E(1:3,1:NTP)=0;
    for ii=1:3
        for jj=1:NTP
            E(ii,jj)=EDC(ii);
            for kk=1:NH
                if (kk==1)
                    E(ii,jj)=E(ii,jj)+ERF(kk,ii)*cos(2*pi*kk*NU*T(jj));
                else
                    E(ii,jj)=E(ii,jj)+ERF(kk,ii)*cos(2*pi*kk*NU*T(jj)+PHA_ANG(kk-1,ii));
                end
            end
            
            if (jj==1)
                E_MAX(ii)=E(ii,jj);
                E_MIN(ii)=E(ii,jj);
            end
            
            if (E(ii,jj)>E_MAX(ii))
                E_MAX(ii)=E(ii,jj);
            end
            
            if (E(ii,jj)<E_MIN(ii))
                E_MIN(ii)=E(ii,jj);
            end 
        end
    end
    E_MIN=min(E_MIN);
    E_MAX=max(E_MAX);
 
    col={'k','b','r'};
    
    %****
    %Plot
    %****
    figure
    ph(1:3)=0;
    hold on
    for ii=1:3
        plot(TA(1:NDT)*1e9,EQS(ii,1:NDT)/1e5,[col{ii} 'd'],'MarkerFaceColor',col{ii},'MarkerEdgeColor',col{ii})
        ph(ii)=plot(T(1:NTP)*1e9,E(ii,1:NTP)/1e5,[col{ii} '-'],'MarkerFaceColor',col{ii},'MarkerEdgeColor',col{ii});
    end
    hold off
    ylabel('Electric Field Intensity (kV/cm)','FontSize',38,'FontWeight','Bold'); 
    xlabel('Time (ns)','FontSize',38,'FontWeight','Bold');
    title('Electric Field Intensity Waveform','FontSize',38,'Color','k','FontWeight','Bold');
    legend(ph,'x-axis projection','y-axis projection','z-axis projection')
    axis([0 1/NU*1e9 E_MIN/1e5 E_MAX/1e5])
    set(gca,'FontSize',34)
    grid on
end

end