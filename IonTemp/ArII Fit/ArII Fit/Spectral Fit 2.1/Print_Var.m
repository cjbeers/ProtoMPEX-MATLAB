function Print_Var(PARA,PARA_BACK_CON,PARA_BACK_VAR,FIT)

%*******************
%Assigning the input
%*******************
PSNM=PARA.FP.PSNM;
NS=PARA.FP.NS;

NSPF=PARA.NP.NSPF;

NH_X=PARA.NP.NH_X;
NH_Y=PARA.NP.NH_Y;
NH_Z=PARA.NP.NH_Z;

for uu=1:NSPF
    %*********************************
    %Assign spectra specific variables
    %*********************************
    CHI=FIT.CHI{uu}(1:NS);
    VAR=FIT.VAR{uu};

    %******************************
    %Write fit parameters to screen
    %******************************
    for ii=1:NS
        if CHI(ii)>=100
            SP='';
        elseif CHI(ii)>=10
            SP=' ';
        elseif CHI(ii)>=0
            SP=' ';
        elseif isnan(CHI(ii))==1
            SP='  ';
        end

        fprintf('\n||||||||||||||||||||||||||||||||||||||||||||||\n')
        fprintf('|||||||||||    Spectra %1i of %1i    |||||||||||||\n',uu,NSPF)
        fprintf('||||||||||||||||||||||||||||||||||||||||||||||\n')
        fprintf('||||  CHI = %6.3f %s--- Track Point = %1i   ||||\n',CHI(ii),SP,ii)
        fprintf('||||||||||||||||||||||||||||||||||||||||||||||\n')
        for jj=1:sum(PSNM)+2;
            if (jj==1)
                fprintf('THETA = %4.1f degrees\n',VAR(ii,jj)*180/pi)
            elseif (jj==2)
                fprintf('PHI = %4.1f degrees\n',VAR(ii,jj)*180/pi)
            elseif (jj==PSNM(1)+1)
                fprintf('SIGMA = %3.1f degrees\n',VAR(ii,jj)*180/pi)
            elseif (jj==PSNM(1)+2)
                fprintf('T1 = %4.1f per cent\n',VAR(ii,jj)*100)
            elseif (jj==PSNM(1)+3)
                fprintf('T2 = %4.1f per cent\n',VAR(ii,jj)*100)
            elseif (jj==sum(PSNM(1:3)))
                fprintf('B_Z = %3.1f T\n',VAR(ii,jj))
            elseif (jj==sum(PSNM(1:3))+1)
                fprintf('E0_X = %4.2f kV/cm\n',VAR(ii,jj))
            elseif (jj<=sum(PSNM(1:3))+NH_X+1)
                if (jj==sum(PSNM(1:3))+2)
                    kk=0;
                end
                kk=kk+1;
                fprintf('E%1i_X = %4.2f kV/cm\n',kk,VAR(ii,jj))
            elseif (jj<=sum(PSNM(1:4)))
                if (jj==sum(PSNM(1:3))+NH_X+2)
                    kk=0;
                end            
                kk=kk+1;
                fprintf('C%1i_X = %4.2f deg\n',kk,VAR(ii,jj)*180/pi)
            elseif (jj==sum(PSNM(1:4))+1)
                fprintf('E0_Y = %4.2f kV/cm\n',VAR(ii,jj))
            elseif (jj<=sum(PSNM(1:4))+NH_Y+1)
                if (jj==sum(PSNM(1:4))+2)
                    kk=0;
                end
                kk=kk+1;
                fprintf('E%1i_Y = %4.2f kV/cm\n',kk,VAR(ii,jj))
            elseif (jj<=sum(PSNM(1:5)))
                if (jj==sum(PSNM(1:4))+NH_Y+2)
                    kk=0;
                end            
                kk=kk+1;
                fprintf('C%1i_Y = %4.2f deg\n',kk,VAR(ii,jj)*180/pi)   
            elseif (jj==sum(PSNM(1:5))+1)
                fprintf('E0_Z = %4.2f kV/cm\n',VAR(ii,jj))
            elseif (jj<=sum(PSNM(1:5))+NH_Z+1)
                if (jj==sum(PSNM(1:5))+2)
                    kk=0;
                end
                kk=kk+1;
                fprintf('E%1i_Z = %4.2f kV/cm\n',kk,VAR(ii,jj))
            elseif (jj<=sum(PSNM(1:6)))
                if (jj==sum(PSNM(1:5))+NH_Z+2)
                    kk=0;
                end
                kk=kk+1;
                fprintf('C%1i_Z = %4.2f deg\n',kk,VAR(ii,jj)*180/pi)       
            elseif (jj<=sum(PSNM(1:7)))
                if (jj==sum(PSNM(1:6))+1)
                    kk=0;
                end
                kk=kk+1;
                fprintf('Group %1i -- kT= %4.2f eV\n',kk,VAR(ii,jj))
            elseif (jj<=sum(PSNM(1:8)))
                if (jj==sum(PSNM(1:7))+1)
                    kk=0;
                end
                kk=kk+1;
                fprintf('Group %1i -- X= %4.2f A\n',kk,VAR(ii,jj))
            elseif (jj<=sum(PSNM(1:9)))
                if (jj==sum(PSNM(1:8))+1)
                    kk=0;
                end
                kk=kk+1;
                fprintf('Group %1i -- I= %4.2f per cent\n',kk,VAR(ii,jj)*100)
            elseif (PSNM(10)>0 && jj<=sum(PSNM(1:10)))
                if (jj==sum(PSNM(1:9))+1)
                    kk=0;
                end
                kk=kk+1;
                fprintf('Function %1i -- GAM= %4.2f A\n',kk,VAR(ii,jj))
            elseif (PSNM(11)>0 && jj<=sum(PSNM(1:11)))
                if (jj==sum(PSNM(1:10))+1)
                    kk=0;
                end
                kk=kk+1;
                fprintf('Function %1i -- X= %4.2f A\n',kk,VAR(ii,jj))
            elseif (PSNM(12)>0 && jj<=sum(PSNM(1:12)))
                if (jj==sum(PSNM(1:11))+1)
                    kk=0;
                end
                kk=kk+1;
                fprintf('Function %1i -- I= %4.2f per cent\n',kk,VAR(ii,jj)*100)            
            elseif (jj==sum(PSNM(1:13)))
                fprintf('Io = %4.2f per cent\n',VAR(ii,jj)*100)
            elseif (jj==sum(PSNM(1:13))+1)
                fprintf('VS = %4.2f per cent\n',VAR(ii,jj)*100)
            else
                fprintf('HS = %4.2f A\n',VAR(ii,jj))
            end
        end
        if isempty(PARA_BACK_CON)==0
            PSNM_B=PARA_BACK_CON.FP.PSNM;
            NH_X_B=PARA_BACK_CON.NP.NH_X;
            NH_Y_B=PARA_BACK_CON.NP.NH_Y;
            NH_Z_B=PARA_BACK_CON.NP.NH_Z;
            
            VAR_BACK=FIT.VAR_BACK_CON{uu};
            
            fprintf('||||||||||||||||||||||||||||||||||||||||||||||\n')
            fprintf('|||||||||   CONSTANT BACKGROUND    |||||||||||\n')
            fprintf('||||||||||||||||||||||||||||||||||||||||||||||\n')
            for jj=1:sum(PSNM_B)+2;
                if (jj==1)
                    fprintf('THETA = %4.1f degrees\n',VAR_BACK(ii,jj)*180/pi)
                elseif (jj==2)
                    fprintf('PHI = %4.1f degrees\n',VAR_BACK(ii,jj)*180/pi)
                elseif (jj==PSNM_B(1)+1)
                    fprintf('SIGMA = %3.1f degrees\n',VAR_BACK(ii,jj)*180/pi)
                elseif (jj==PSNM_B(1)+2)
                    fprintf('T1 = %4.1f per cent\n',VAR_BACK(ii,jj)*100)
                elseif (jj==PSNM_B(1)+3)
                    fprintf('T2 = %4.1f per cent\n',VAR_BACK(ii,jj)*100)
                elseif (jj==sum(PSNM_B(1:3)))
                    fprintf('B_Z = %3.1f T\n',VAR_BACK(ii,jj))
                elseif (jj==sum(PSNM_B(1:3))+1)
                    fprintf('E0_X = %4.2f kV/cm\n',VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:3))+NH_X_B+1)
                    if (jj==sum(PSNM_B(1:3))+2)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('E%1i_X = %4.2f kV/cm\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:4)))
                    if (jj==sum(PSNM_B(1:3))+NH_X_B+2)
                        kk=0;
                    end            
                    kk=kk+1;
                    fprintf('C%1i_X = %4.2f deg\n',kk,VAR_BACK(ii,jj)*180/pi)
                elseif (jj==sum(PSNM_B(1:4))+1)
                    fprintf('E0_Y = %4.2f kV/cm\n',VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:4))+NH_Y_B+1)
                    if (jj==sum(PSNM_B(1:4))+2)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('E%1i_Y = %4.2f kV/cm\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:5)))
                    if (jj==sum(PSNM_B(1:4))+NH_Y_B+2)
                        kk=0;
                    end            
                    kk=kk+1;
                    fprintf('C%1i_Y = %4.2f deg\n',kk,VAR_BACK(ii,jj)*180/pi)   
                elseif (jj==sum(PSNM_B(1:5))+1)
                    fprintf('E0_Z = %4.2f kV/cm\n',VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:5))+NH_Z_B+1)
                    if (jj==sum(PSNM_B(1:5))+2)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('E%1i_Z = %4.2f kV/cm\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:6)))
                    if (jj==sum(PSNM_B(1:5))+NH_Z_B+2)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('C%1i_Z = %4.2f deg\n',kk,VAR_BACK(ii,jj)*180/pi)       
                elseif (jj<=sum(PSNM_B(1:7)))
                    if (jj==sum(PSNM_B(1:6))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Group %1i -- kT= %4.2f eV\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:8)))
                    if (jj==sum(PSNM_B(1:7))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Group %1i -- X= %4.2f A\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:9)))
                    if (jj==sum(PSNM_B(1:8))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Group %1i -- I= %4.2f per cent\n',kk,VAR_BACK(ii,jj)*100)
                elseif (PSNM_B(10)>0 && jj<=sum(PSNM_B(1:10)))
                    if (jj==sum(PSNM_B(1:9))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Function %1i -- GAM= %4.2f A\n',kk,VAR_BACK(ii,jj))
                elseif (PSNM_B(11)>0 && jj<=sum(PSNM_B(1:11)))
                    if (jj==sum(PSNM_B(1:10))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Function %1i -- X= %4.2f A\n',kk,VAR_BACK(ii,jj))
                elseif (PSNM_B(12)>0 && jj<=sum(PSNM_B(1:12)))
                    if (jj==sum(PSNM_B(1:11))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Function %1i -- I= %4.2f per cent\n',kk,VAR_BACK(ii,jj)*100)            
                end
            end
        end
        if isempty(PARA_BACK_VAR)==0
            PSNM_B=PARA_BACK_VAR.FP.PSNM;
            NH_X_B=PARA_BACK_VAR.NP.NH_X;
            NH_Y_B=PARA_BACK_VAR.NP.NH_Y;
            NH_Z_B=PARA_BACK_VAR.NP.NH_Z;
            
            VAR_BACK=FIT.VAR_BACK_VAR{uu};
            
            fprintf('||||||||||||||||||||||||||||||||||||||||||||||\n')
            fprintf('|||||||||||    FIT BACKGROUND    |||||||||||||\n')
            fprintf('||||||||||||||||||||||||||||||||||||||||||||||\n')
            for jj=1:sum(PSNM_B)+2;
                if (jj==1)
                    fprintf('THETA = %4.1f degrees\n',VAR_BACK(ii,jj)*180/pi)
                elseif (jj==2)
                    fprintf('PHI = %4.1f degrees\n',VAR_BACK(ii,jj)*180/pi)
                elseif (jj==PSNM_B(1)+1)
                    fprintf('SIGMA = %3.1f degrees\n',VAR_BACK(ii,jj)*180/pi)
                elseif (jj==PSNM_B(1)+2)
                    fprintf('T1 = %4.1f per cent\n',VAR_BACK(ii,jj)*100)
                elseif (jj==PSNM_B(1)+3)
                    fprintf('T2 = %4.1f per cent\n',VAR_BACK(ii,jj)*100)
                elseif (jj==sum(PSNM_B(1:3)))
                    fprintf('B_Z = %3.1f T\n',VAR_BACK(ii,jj))
                elseif (jj==sum(PSNM_B(1:3))+1)
                    fprintf('E0_X = %4.2f kV/cm\n',VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:3))+NH_X_B+1)
                    if (jj==sum(PSNM_B(1:3))+2)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('E%1i_X = %4.2f kV/cm\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:4)))
                    if (jj==sum(PSNM_B(1:3))+NH_X_B+2)
                        kk=0;
                    end            
                    kk=kk+1;
                    fprintf('C%1i_X = %4.2f deg\n',kk,VAR_BACK(ii,jj)*180/pi)
                elseif (jj==sum(PSNM_B(1:4))+1)
                    fprintf('E0_Y = %4.2f kV/cm\n',VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:4))+NH_Y_B+1)
                    if (jj==sum(PSNM_B(1:4))+2)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('E%1i_Y = %4.2f kV/cm\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:5)))
                    if (jj==sum(PSNM_B(1:4))+NH_Y_B+2)
                        kk=0;
                    end            
                    kk=kk+1;
                    fprintf('C%1i_Y = %4.2f deg\n',kk,VAR_BACK(ii,jj)*180/pi)   
                elseif (jj==sum(PSNM_B(1:5))+1)
                    fprintf('E0_Z = %4.2f kV/cm\n',VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:5))+NH_Z_B+1)
                    if (jj==sum(PSNM_B(1:5))+2)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('E%1i_Z = %4.2f kV/cm\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:6)))
                    if (jj==sum(PSNM_B(1:5))+NH_Z_B+2)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('C%1i_Z = %4.2f deg\n',kk,VAR_BACK(ii,jj)*180/pi)       
                elseif (jj<=sum(PSNM_B(1:7)))
                    if (jj==sum(PSNM_B(1:6))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Group %1i -- kT= %4.2f eV\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:8)))
                    if (jj==sum(PSNM_B(1:7))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Group %1i -- X= %4.2f A\n',kk,VAR_BACK(ii,jj))
                elseif (jj<=sum(PSNM_B(1:9)))
                    if (jj==sum(PSNM_B(1:8))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Group %1i -- I= %4.2f per cent\n',kk,VAR_BACK(ii,jj)*100)
                elseif (PSNM_B(10)>0 && jj<=sum(PSNM_B(1:10)))
                    if (jj==sum(PSNM_B(1:9))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Function %1i -- GAM= %4.2f A\n',kk,VAR_BACK(ii,jj))
                elseif (PSNM_B(11)>0 && jj<=sum(PSNM_B(1:11)))
                    if (jj==sum(PSNM_B(1:10))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Function %1i -- X= %4.2f A\n',kk,VAR_BACK(ii,jj))
                elseif (PSNM_B(12)>0 && jj<=sum(PSNM_B(1:12)))
                    if (jj==sum(PSNM_B(1:11))+1)
                        kk=0;
                    end
                    kk=kk+1;
                    fprintf('Function %1i -- I= %4.2f per cent\n',kk,VAR_BACK(ii,jj)*100)            
                end
            end
        end
        fprintf('||||||||||||||||||||||||||||||||||||||||||||||\n')
    end
end

end
