function [PSF,CHI]=Full_Ins(PARA,DATA,uu)

%****************
%Assign the input
%****************
PS=PARA.IP.PS;
NDPS=PARA.IP.NDPS;
NI=PARA.IP.NI;

%**************************
%Allocate/initialize memory
%**************************
PSF(1:2)=0;
CHI_M(1:NDPS(1),1:NDPS(2))=Inf;

%**************************************************************************
%****************************  Start Search  ******************************
%**************************************************************************

for ii=1:NI
    %*****************
    %Calc. reduced chi
    %*****************    
    for jj=1:NDPS(1)
        for kk=1:NDPS(2)
            CHI_M(jj,kk)=Red_Chi(DATA,[PS(1,jj),PS(2,kk)],uu);
        end
    end

    %********************
    %Find min reduced chi
    %********************
    [CHI,N1]=min(CHI_M(1:NDPS(1),1:NDPS(2)),[],1);
    [CHI,N2]=min(CHI(1:NDPS(2)));
    N1=N1(N2);

    %*************************************
    %Exit if min reduced chi is a boundary
    %*************************************    
    if ((N1==1) || (N1==NDPS(1))) && ((N2==1) || (N2==NDPS(2)))
        break
    end

    %**********************
    %Update parameter space
    %**********************    
    if (N1==1) || (N1==NDPS(1))
        NDPS(1)=1;
        PS(1,1)=PS(1,N1);
    else
        dPS=(PS(1,N1+1)-PS(1,N1-1))/(NDPS(1)-1);
        PS(1,1:NDPS(1))=PS(1,N1-1):dPS:PS(1,N1+1);
    end

    if (N2==1) || (N2==NDPS(2))
        NDPS(2)=1;
        PS(2,1)=PS(2,N2);
    else
        dPS=(PS(2,N2+1)-PS(2,N2-1))/(NDPS(2)-1);
        PS(2,1:NDPS(2))=PS(2,N2-1):dPS:PS(2,N2+1);
    end   
end

%********************
%Assigning the output
%********************
PSF(1:2)=[PS(1,N1),PS(2,N2)];

end