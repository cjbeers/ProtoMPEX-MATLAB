function DATA=Deg_Trans(DATA,OPT)

%**************************************************************************
%This function groups transitions with degenerate transition energies
%together based on the criteria: eps_deg
%
%If transitions have a relative difference less then eps_deg they are
%considered degenerate.  If the sum of degenerate and total intensities
%does not match to within a relative error of eps_err an error message is
%written to the screen
%**************************************************************************
NT_LIM=1000;
EPS=1e-8;

%************
%Assign input
%************
DISC=DATA.DISC;

I=DISC.I;
X=DISC.X;
NT=DISC.NT;

SPEC=OPT.SPEC;
PRINT=OPT.PRINT;

%***************
%Allocate memory
%***************
HIT(1:NT)=0;
I_DEG(1:NT)=0;
X_DEG(1:NT)=0;
DEG(1:NT)=0;

%**************************
%Sum degenerate transitions
%**************************
kk=0;
for ii=1:NT
    if HIT(ii)==0
        kk=kk+1;
        if NT<NT_LIM
            %************
            %Serial calc.
            %************
            for jj=1:NT
                if (abs((X(ii)-X(jj))/X(ii))<EPS)
                    if (HIT(jj)==0)
                        HIT(jj)=1;
                        I_DEG(kk)=I_DEG(kk)+I(jj);
                        X_DEG(kk)=X_DEG(kk)+X(jj)*I(jj);
                        DEG(kk)=DEG(kk)+1;
                    end
                end
            end
            X_DEG(kk)=X_DEG(kk)/I_DEG(kk);
        else
            %**************
            %Parallel calc.
            %**************
            LOGIC=abs((X(ii)-X)/X(ii))<EPS&HIT==0;
            HIT(LOGIC)=1;
            I_DEG(kk)=sum(I(LOGIC));
            X_DEG(kk)=sum(X(LOGIC).*I(LOGIC))/I_DEG(kk);
            DEG(kk)=DEG(kk)+sum(LOGIC);
        end
    end
end
NT_DEG=kk;

%***************
%Truncate arrays
%***************
if NT_DEG<NT
    I_DEG(NT_DEG+1:NT)=[];
    X_DEG(NT_DEG+1:NT)=[];
    DEG(NT_DEG+1:NT)=[];
end

%*********
%Normalize
%*********
if SPEC.NORM==1
    I_DEG=I_DEG/max(I_DEG);
end

%*********************
%Assign TRAN sturcture
%*********************
DISC.I=I_DEG;
DISC.X=X_DEG;
DISC.NT=NT_DEG;
DISC.DEG=DEG;

DATA.DISC=DISC;

%*****
%Print
%*****
if PRINT.TRAN==1
    fprintf('\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n')
    fprintf('||||||            Number of dipole allowed transitions: %5i             ||||||\n',NT)
    fprintf('||||||      Number of nondegenerate dipole allowed transitions: %5i     ||||||\n',NT_DEG)
    fprintf('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n')
end

end