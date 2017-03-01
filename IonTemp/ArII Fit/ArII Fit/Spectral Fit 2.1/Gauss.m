function DATA=Gauss(X_DOP,kT_DOP,DATA,uu)

%****************
%Assign the input
%****************
IT=DATA.TRAN{uu}.IT;
XT=DATA.TRAN{uu}.XT;
NT=DATA.TRAN{uu}.NT;

XG=DATA.GRID{uu}.XG;
NG=DATA.GRID{uu}.NG;

IMAT_GAU=DATA.CONT{uu}.IMAT_GAU;

UNIV=DATA.UNIV;

XC=DATA.BROAD{uu}.XC;
NTG=DATA.BROAD{uu}.NTG;

INS=DATA.INS{uu};

%****************************
%Assign instrument parameters
%****************************
NFG=INS{1};
I_GAU=INS{2};
X_GAU=INS{3};
SIG_GAU=INS{4};

%********************
%Assign radiator mass
%********************
M=UNIV.m(uu);

%*************************
%Allocate/initalize memory
%*************************
SIG(1:NFG,1:NTG)=0;
IMAT_GAU(1:NG,1:NTG)=0;

%************************
%Calc. doppler broadening
%************************
SIG_DOP=Doppler(kT_DOP,XC,M,UNIV);

%*********************************************
%Add Doppler broadening to instrument function
%*********************************************
for ii=1:NFG
    for jj=1:NTG
        SIG(ii,jj)=(SIG_GAU(ii)^2+SIG_DOP(jj)^2)^0.5;
    end
end

%*********************
%Calc. the grid matrix
%*********************
if NT<NG
    for ii=1:NT
        for jj=1:NFG
            for kk=1:NTG
                IMAT_GAU(1:NG,kk)=IMAT_GAU(1:NG,kk)+I_GAU(jj)*IT(ii)/SIG(jj,kk)*exp(-1*((XG(1:NG).'-X_DOP(kk)-X_GAU(jj)-XT(ii))/SIG(jj,kk)).^2);
            end
        end
    end
else
    for ii=1:NG
        for jj=1:NFG
            for kk=1:NTG
                IMAT_GAU(ii,kk)=IMAT_GAU(ii,kk)+sum(I_GAU(jj)*IT(1:NT)/SIG(jj,kk).*exp(-1*((XG(ii)-X_DOP(kk)-X_GAU(jj)-XT(1:NT))/SIG(jj,kk)).^2));
            end
        end
    end
end

%********************
%Assigning the output
%********************
DATA.CONT{uu}.IMAT_GAU=IMAT_GAU;

end