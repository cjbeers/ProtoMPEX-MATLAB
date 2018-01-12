function DATA=Grid(PARA,DATA)

%*******************
%Assigning the input
%*******************
NSPF=PARA.NP.NSPF;

PSB_INS=PARA.IP.PSB;

for uu=1:NSPF
    %********************************
    %Assigning spectra specific input
    %********************************
    NG=DATA.GRID{uu}.NG;
    XG=DATA.GRID{uu}.XG;

    XEC=DATA.EXP{uu}.XEC;

    %*********************
    %Calc. grid boundaries
    %*********************
    XG(1)=min(XEC)+PSB_INS(2,1);
    XG(NG)=max(XEC)+PSB_INS(2,2);

    %**************
    %Calc. the grid
    %**************
    dXG=(XG(NG)-XG(1))/(NG-1);
    for ii=2:NG-1
        XG(ii)=XG(ii-1)+dXG;
    end

    %***************************
    %Calc. equation for indicies
    %***************************
    GFP(1)=(NG-1)/(XG(NG)-XG(1));
    GFP(2)=1-GFP(1)*XG(1);

    %*****************
    %Assign the output
    %*****************
    DATA.GRID{uu}.XG=XG;
    DATA.GRID{uu}.GFP=GFP;
end

end