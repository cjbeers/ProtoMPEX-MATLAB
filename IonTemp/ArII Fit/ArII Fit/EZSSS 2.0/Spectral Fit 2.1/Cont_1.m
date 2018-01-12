function DATA=Cont_1(I_DOP,I_LOR,DATA,uu)

%*******************
%Assigning the input
%*******************
IG=DATA.GRID{uu}.IG;
NG=DATA.GRID{uu}.NG;

NTG=DATA.BROAD{uu}.NTG;
NFL=DATA.BROAD{uu}.NFL;

IMAT_GAU=DATA.CONT{uu}.IMAT_GAU;
IMAT_LOR=DATA.CONT{uu}.IMAT_LOR;

%****************
%Initalize memory
%****************
IG(1:NG)=0;

%************************
%Calc. the grid intensity
%************************     
for ii=1:NTG
    if (NFL>0)
        for jj=1:NFL
            IG(1:NG)=IG(1:NG)+I_DOP(ii)*I_LOR(jj)*IMAT_LOR(1:NG,ii,jj).';
        end
    else
        IG(1:NG)=IG(1:NG)+I_DOP(ii)*IMAT_GAU(1:NG,ii).';
    end
end

%****************************
%Normalize the grid intensity
%**************************** 
IG(1:NG)=IG(1:NG)/max(IG(1:NG));

%********************
%Assigning the output
%********************
DATA.GRID{uu}.IG=IG;

end