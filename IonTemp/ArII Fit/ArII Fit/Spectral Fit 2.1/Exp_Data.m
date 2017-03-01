function EXP=Exp_Data(EXP_RAW,NSPF)

%***************
%Allocate memory
%***************
EXP=cell(1,NSPF);

for uu=1:NSPF
    clear IE XE IEE LG WT

    %************
    %Assign input
    %************  
    NE=EXP_RAW{uu}.NE;
    IE(1:NE)=EXP_RAW{uu}.IE(1:NE);
    XE(1:NE)=EXP_RAW{uu}.XE(1:NE);

    %********************
    %Assign default error
    %********************
    if (isfield(EXP_RAW{uu},'IEE')==0)
        IEE(1:NE)=ones(1,NE)*.05;
    else
        IEE(1:NE)=EXP_RAW{uu}.IEE(1:NE);
    end

    %********************
    %Assign default logic
    %********************
    if (isfield(EXP_RAW{uu},'LG')==0)
        LG(1:NE)=ones(1,NE);
    else
        LG(1:NE)=EXP_RAW{uu}.LG(1:NE);
    end

    %********************
    %Assign default logic
    %********************
    if (isfield(EXP_RAW{uu},'WT')==0)
        WT(1:NE)=ones(1,NE);
    else
        WT(1:NE)=EXP_RAW{uu}.WT(1:NE);
    end

    %**********************************
    %Sort wavelength in ascending order
    %**********************************
    [XE,IND]=sort(XE(1:NE),'ascend');
    IE=IE(IND);
    IEE=IEE(IND);
    LG=LG(IND);
    WT=WT(IND);

    %**************************
    %Calc. number of fit points
    %**************************
    NEF=sum(LG==1);

    %*****************
    %Calc. line center
    %*****************
    XC=sum(XE.*IE)/sum(IE);

    %*******************************
    %Calc. pixel cell edge and width
    %*******************************
    XEC=zeros(1,NE+1);
    XEW=zeros(1,NE);
    for ii=1:NE
        if (ii==1)
            XEC(ii)=XE(ii)-(XE(ii+1)-XE(ii))/2;
        else
            XEC(ii)=XE(ii-1)+(XE(ii)-XE(ii-1))/2;
            XEW(ii-1)=XEC(ii)-XEC(ii-1);
        end

        if (ii==NE)
            XEC(ii+1)=XE(ii)+(XE(ii)-XE(ii-1))/2;
            XEW(ii)=XEC(ii+1)-XEC(ii);
        end
    end

    %*****************
    %Normalize weights
    %*****************
    WT=WT*NEF/sum(WT(LG==1));

    %********************
    %Update EXP structure
    %********************  
    EXP{uu}.IE=IE(1:NE);
    EXP{uu}.IEE=IEE(1:NE);

    EXP{uu}.XE=XE(1:NE);
    EXP{uu}.XEC=XEC(1:NE+1);
    EXP{uu}.XEW=XEW(1:NE);
    EXP{uu}.XC=XC;

    EXP{uu}.LG=LG(1:NE);
    EXP{uu}.WT=WT(1:NE);

    EXP{uu}.NE=NE;
    EXP{uu}.NEF=NEF;
end

end