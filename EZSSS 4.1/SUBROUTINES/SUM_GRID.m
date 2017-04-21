function GRID=SUM_GRID(FULL,OPT)

%************
%Assign input
%************
SPEC=OPT.SPEC;

%******************
%Assign the spectra
%******************
NT=FULL.NT;
I=FULL.I;
X=FULL.X;

%*******************************
%Assign the degeneracy parameter
%*******************************
DX_GRID=SPEC.SUM.DX_GRID;

%**********************************
%Calc. grid to sum transitions over
%**********************************
MIN=min(X);
MAX=max(X);

if NT>0
    NG=ceil((MAX-MIN)/DX_GRID);
    XG=linspace(MIN,MAX,NG);
else
    NG=0;
end

%***************
%Allocate memory
%***************
N_SUM(1:NG)=0;
X_SUM(1:NG)=0;
I_SUM(1:NG)=0;

jj=0;
for ii=1:NG-1
    %************
    %Assign logic
    %************
    if ii<NG-1
        LOG=X>=XG(ii)&X<XG(ii+1);
    else
        LOG=X>=XG(ii)&X<=XG(ii+1);
    end
    
    %********************************
    %Calc. number of grid transitions
    %********************************
    N1=sum(LOG);
    
    if N1>0 
        %************************
        %Advance the dummy indice
        %************************
        jj=jj+1;
        
        %*****************
        %Assign temp. data
        %*****************
        T1=X(LOG);
        T2=I(LOG);
        
        %*************************************
        %Assign the non-degenerate transitions
        %*************************************
        X_SUM(jj)=sum(T1.*T2)/sum(T2);
        I_SUM(jj)=sum(T2);
        N_SUM(jj)=N1;
    end
end

%******************************************
%Assign number of non-degenerate transtions
%******************************************
NT_SUM=jj;

%***************
%Truncate arrays
%***************
N_SUM=N_SUM(1:NT_SUM);
X_SUM=X_SUM(1:NT_SUM);
I_SUM=I_SUM(1:NT_SUM);

%*****************************************************
%Assign the non-degenerate (grouped) discrete spectrum
%*****************************************************
GRID.X=X_SUM;
GRID.I=I_SUM;
GRID.NT=NT_SUM;
GRID.ND=N_SUM;

end