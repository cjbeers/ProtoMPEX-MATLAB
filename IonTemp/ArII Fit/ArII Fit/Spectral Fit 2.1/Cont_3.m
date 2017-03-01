function IS=Cont_3(EXP,PROFILE)

%*******************
%Assigning the input
%*******************
XEC=EXP.XEC;
XEW=EXP.XEW;
NE=EXP.NE;

IGT=PROFILE.IGT;
XG=PROFILE.XG;
NG=PROFILE.NG;

%***************************
%Calc. equation for indicies
%***************************
GFP(1)=(NG-1)/(XG(NG)-XG(1));
GFP(2)=1-GFP(1)*XG(1);

%*********************
%Calc. interp. indices
%********************* 
N1=GFP(1)*XEC+GFP(2);

N1=floor(N1);
N1(N1<1)=1;
N1(N1>=NG)=NG-1;
N2=N1+1;

%*******************************
%Interp. to grid cell boundaries
%*******************************
IGC=IGT(N1)+(XEC-XG(N1)).*(IGT(N2)-IGT(N1))./(XG(N2)-XG(N1));

%***********************************
%Integrate over grid cell boundaries
%***********************************
jj=1;
kk=0;
IS(1:NE)=0;
for ii=1:NG
    if (XG(ii)>XEC(jj) && XG(ii)<=XEC(jj+1))
        if (kk==0)
            kk=1;
            I=(IGT(ii)+IGC(jj))/2;
            dX=XG(ii)-XEC(jj);
        else
            I=(IGT(ii)+IGT(ii-1))/2;
            dX=XG(ii)-XG(ii-1);
        end
        IS(jj)=IS(jj)+I*dX;
    elseif (XG(ii)>XEC(jj+1))
        I=(IGC(jj+1)+IGT(ii-1))/2;
        dX=XEC(jj+1)-XG(ii-1);
        IS(jj)=IS(jj)+I*dX;
              
        if (jj==NE)
            break
        else
            jj=jj+1;
            I=(IGT(ii)+IGC(jj))/2;
            dX=XG(ii)-XEC(jj);
            IS(jj)=IS(jj)+I*dX;        
        end
    end
end
IS=IS./XEW;

end