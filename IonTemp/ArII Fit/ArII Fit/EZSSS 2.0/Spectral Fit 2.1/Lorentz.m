function DATA=Lorentz(X_LOR,GAM_LOR,DATA,uu)

%****************
%Assign the input
%****************
XG=DATA.GRID{uu}.XG;
NG=DATA.GRID{uu}.NG;

IMAT_GAU=DATA.CONT{uu}.IMAT_GAU;
IMAT_LOR=DATA.CONT{uu}.IMAT_LOR;

NTG=DATA.BROAD{uu}.NTG;
NFL=DATA.BROAD{uu}.NFL;

%*************************
%Allocate/initalize memory
%*************************
IMAT_LOR(1:NG,1:NTG,1:NFL)=0;

%*********************
%Calc. the grid matrix
%*********************
for ii=1:NG
    for jj=1:NTG
        for kk=1:NFL
            IMAT_LOR(ii,jj,kk)=sum(IMAT_GAU(1:NG,jj).'/GAM_LOR(kk)./(1+((XG(1:NG)+X_LOR(kk)-XG(ii))/GAM_LOR(kk)).^2));
        end
    end
end

%********************
%Assigning the output
%********************
DATA.CONT{uu}.IMAT_LOR=IMAT_LOR;

end