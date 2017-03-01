function [JOB,NPSS,NPSP,NPSPP,NAP,BLOG]=Parallel(PARA,OPT) 

%************
%Assign input
%************
NDPS=PARA.FP.NDPS;
NDS=PARA.FP.NDS;
NDP=PARA.FP.NDP;
PSI=PARA.FP.PSI;

NAP=OPT.NAP;

%***************************************************************
%Total number of points in parameter space for serial processing
%***************************************************************
NPSS=1;
for ii=1:sum(NDS)
    jj=PSI(NDP+ii);
    NPSS=NDPS(jj)*NPSS;
end

%*********************************************************
%Number of points in parameter space for serial processing
%*********************************************************
NPSSP(1:length(NDS))=1;
for ii=1:length(NDS)
    if (NDS(ii)>0)
        for jj=1:NDS(ii)
            kk=jj+sum(NDS(1:ii-1))+NDP;
            ll=PSI(kk);
            NPSSP(ii)=NDPS(ll)*NPSSP(ii);
        end
    end
end

%***********************************************************
%Number of points in parameter space for parallel processing
%***********************************************************
NPSP=1;
for ii=1:NDP
    jj=PSI(ii);
    NPSP=NDPS(jj)*NPSP;
end

%**********************************************
%Number of points in parameter space per worker
%**********************************************
NPSPP(1:NAP)=0;
if (NAP==1)
    NPSPP=NPSP;
else
    if (NPSP>=NAP)
        NPSPP(1:NAP)=floor(NPSP/NAP);
        for ii=1:NPSP-NAP*floor(NPSP/NAP);
            NPSPP(ii)=NPSPP(ii)+1;
        end
    else
        NAP=NPSP;
        NPSPP(1:NPSP)=1;
    end
end

DIM_ST(1,1:NDP)=1;
DIM_FN(NAP,1:NDP)=NDPS(1:NDP);
for ii=1:NAP-1
    %******************************
    %Calc. stop indices for workers
    %******************************   
    T1=sum(NPSPP(1:ii));
    for jj=NDP:-1:1
        kk=PSI(jj);
        
        T2=floor(T1/NDPS(kk));
        T3=ceil(T1/NDPS(kk));

        DIM_FN(ii,jj)=T1-NDPS(kk)*T2;
        if (T2==0)
            if (jj>1)
                DIM_FN(ii,1:jj-1)=1;
            end
            break        
        elseif (T2==T3)
            DIM_FN(ii,jj)=NDPS(kk);
            T1=T2;
        else
            T1=T2+1;
        end
    end
    
    %*******************************
    %Calc. start indices for workers
    %*******************************  
    DIM_ST(ii+1,NDP)=DIM_FN(ii,NDP)+1;
    for jj=NDP:-1:1
        kk=PSI(jj);
        
        if (DIM_FN(ii,jj)+1<=NDPS(kk))
            DIM_ST(ii+1,jj)=DIM_FN(ii,jj)+1;
            if (jj>1)
                DIM_ST(ii+1,1:jj-1)=DIM_FN(ii,1:jj-1);
            end
            break
        else
            DIM_ST(ii+1,jj)=1;
        end
    end
end

%***********************************************************
%Assign parallel processing logic for background calculation
%***********************************************************
if NAP>1
    BLOG=0;
else
    BLOG=1;
end

%************************************
%Assign worker start and stop indices
%************************************
JOB=cell(1,NAP);
for ii=1:NAP
    JOB{ii}.BLOG=BLOG;
    JOB{ii}.NPSS=NPSS;
    JOB{ii}.NPSP=NPSP;
    JOB{ii}.NPSSP=NPSSP;    
    JOB{ii}.NPSPP=NPSPP(ii);
    JOB{ii}.DIM_ST=DIM_ST(ii,1:NDP);
    JOB{ii}.DIM_FN=DIM_FN(ii,1:NDP);
end

end