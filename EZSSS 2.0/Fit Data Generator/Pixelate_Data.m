function [NE,IE,XE]=Pixelate_Data(XEC,IG,XG)

%*********************
%Number of data points
%*********************
NE=length(XEC)-1;
NG=length(IG);

%*********************
%Calc. the pixel width
%*********************
XEW(1:NE)=0;
for ii=1:NE
    XEW(ii)=XEC(ii+1)-XEC(ii);
end

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
IGC=IG(N1)+(XEC-XG(N1)).*(IG(N2)-IG(N1))./(XG(N2)-XG(N1));

%***********************************
%Integrate over grid cell boundaries
%***********************************
jj=1;
kk=0;
IE(1:NE)=0;
for ii=1:NG
    if (XG(ii)>XEC(jj) && XG(ii)<=XEC(jj+1))
        if (kk==0)
            kk=1;
            I=(IG(ii)+IGC(jj))/2;
            dX=XG(ii)-XEC(jj);
        else
            I=(IG(ii)+IG(ii-1))/2;
            dX=XG(ii)-XG(ii-1);
        end
        IE(jj)=IE(jj)+I*dX;
    elseif (XG(ii)>XEC(jj+1))
        I=(IGC(jj+1)+IG(ii-1))/2;
        dX=XEC(jj+1)-XG(ii-1);
        IE(jj)=IE(jj)+I*dX;
              
        if (jj==NE)
            break
        else
            jj=jj+1;
            I=(IG(ii)+IGC(jj))/2;
            dX=XG(ii)-XEC(jj);
            IE(jj)=IE(jj)+I*dX;        
        end
    end
end
IE=IE./XEW;

%******************************
%Calc. cell averaged wavelength
%******************************
XE(1:NE)=0;
for ii=1:NE
    XE(ii)=(XEC(ii)+XEC(ii+1))/2;
end

end