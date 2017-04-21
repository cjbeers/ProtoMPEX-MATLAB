function DEG=SUM_DEG(FULL,OPT)

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
DX_RATIO=SPEC.SUM.DX_RATIO;

%***************
%Allocate memory
%***************
HIT(1:NT)=0;
N_DEG(1:NT)=0;
X_DEG(1:NT)=0;
I_DEG(1:NT)=0;
IND_DEG(1:NT,1:NT)=0;

kk=0;
for ii=1:NT
    if HIT(ii)==0
        %***************************
        %Intialize degeneracy indice
        %***************************
        ll=0;
        
        %*************************
        %Advance transition indice
        %*************************
        kk=kk+1;

        for jj=1:NT
            if HIT(jj)==0 && abs((X(ii)-X(jj))/X(ii))<DX_RATIO
                %**************************
                %Mark transition as counted
                %**************************
                HIT(jj)=1;

                %*************************
                %Advance degeneracy indice
                %*************************
                ll=ll+1;

                %*************************************
                %Assign the non-degenerate transitions
                %*************************************
                N_DEG(kk)=ll;
                X_DEG(kk)=X_DEG(kk)+X(jj)*I(jj);
                I_DEG(kk)=I_DEG(kk)+I(jj);
                
                %*******************************
                %Assign parent transition indice
                %*******************************
                IND_DEG(kk,ll)=jj;
            end
        end
        
        %*****************************
        %Normalize weighted wavelength
        %*****************************
        X_DEG(kk)=X_DEG(kk)/I_DEG(kk);
    end
end

%******************************************
%Assign number of non-degenerate transtions
%******************************************
NT_DEG=kk;

%***************
%Truncate arrays
%***************
N_DEG=N_DEG(1:NT_DEG);
X_DEG=X_DEG(1:NT_DEG);
I_DEG=I_DEG(1:NT_DEG);
IND_DEG=IND_DEG(1:NT_DEG,1:max(N_DEG));

%*************
%Assign output
%*************
DEG.X=X_DEG;
DEG.I=I_DEG;
DEG.NT=NT_DEG;
DEG.ND=N_DEG;
DEG.IND=IND_DEG;

end