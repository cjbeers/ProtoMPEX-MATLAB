function SPECTRA=TRANS_PROB(EVec,EVal,EPS,MAT_P,MAT_0,MAT_M,OBS,PARA,FIELD,UNIV,OPT)

%**************************************************************************
%Calculating the total intensity associated with a transition by using the
%coefficients of the new eigenfunctions and the matrix elements associated 
%with the coupled basis set for the electric dipole operator.
%**************************************************************************
%                <Phi(ss)|eps*r|Phi(kk)>*<Phi(kk)|eps*r|Phi(ss)>  
%                         ss=[1:NS(1)] and kk=[1:NS(2)]
%**************************************************************************

%**************************************************************************
%Dropping all transitions that have a relative intensity less than error2 with
%respect to the max intensity - this drops transitions that have a non-zero
%relative intensity due to machine error.  Also we drop the imaginary part
%of the intenisty if it is less than error1, this is also due to machine
%error.
%**************************************************************************

%**************************************************************************
%                               INPUTS
%**************************************************************************
%n=[ni,nf] - n is a vector containing two scalars. ni is the radial quantum
%number associated with the intial sate, nf is the radial quantum number
%associated with the final state
%
%H=[1:states,1:states,1:2] - H is a 3D matrix that contains the matrix
%elements associated with the operators of the Schrodinger equation in the
%COUPLED BASIS SET.  The formate of H is follows:  The elements of the H
%matrix assoicated with the following matrix coordinates
%
%                       [1:states_nf,1:states_nf,1]
%
%belong to the states associated with the final state, radial quantum
%number nf. The elements of the H matrix associated with the following
%matrix coordinates
%
%                       [1:states_ni,1:states_ni,2]
%
%belong to the states associated with the inital state, radial quantum
%number ni.  The states associated with the matrix elements must have the
%following order: 
%
%                      l is arragned from 0..n-1
%                      j is arragned from |l-s|..|l+s|
%                      mj is arragned from -j..j
%
%**************************************************************************
%The matrix elements MUST be those associated with the COUPLED BASIS set:
%**************************************************************************
%                               |n,s,l,j,mj>
%**************************************************************************
%The matrix elements MUST be input as:
%**************************************************************************
%                        <n,s,l',j',mj'|H|n,s,l,j,mj>
%**************************************************************************

%************
%Assign input
%************
MODE=OBS.MODE;

NS=PARA.NS;
NB=PARA.NB;

NU=FIELD.ERF.NU;

hbar=UNIV.hbar;
c=UNIV.c;
eo=UNIV.eo;
q=UNIV.q;

TRAN=OPT.TRAN;

%**************************
%Assign index of refraction
%**************************
REF=TRAN.REF;

%******************************************
%Assign minimum intensity - relative to max
%******************************************
MIN_RATIO=TRAN.MIN_RATIO;

%*****************************
%Max. number of Floquet blocks
%*****************************
NB_MAX=max(NB);

%*******************************
%Calc. max number of transitions
%*******************************
NT_MAX=NS(1)*NS(2)*(4*NB_MAX+1);

%***************
%Allocate memory
%***************
NP(1:NT_MAX)=0;
LL(1:NT_MAX)=0;
UL(1:NT_MAX)=0;

I(1:NT_MAX)=0;
E(1:NT_MAX)=0;

%****************************
%Initialize transition indice
%****************************
uu=0;

if strcmpi(MODE,'NO_INT')==1

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>        Calc. observeration cord vector components            <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>   
    
    EPS_SB_A=EPS.SB_A;
    EPS_SB_B=EPS.SB_B;
    
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>      Calc. relative intesity observed along a cord           <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    
    %**********************************
    %Calc. eps*r in the spherical basis
    %**********************************
    MAT_A=-EPS_SB_A(1)*MAT_M+EPS_SB_A(2)*MAT_0-EPS_SB_A(3)*MAT_P;
    MAT_B=-EPS_SB_B(1)*MAT_M+EPS_SB_B(2)*MAT_0-EPS_SB_B(3)*MAT_P;
    
    if NB_MAX==0
        %************************************************************
        %Calc. the rel. intensity for a non-Floquet structured matrix
        %************************************************************
        for ii=1:NS(1)
            for jj=1:NS(2)
                %************************************
                %Calc. the expectation value of eps*r
                %************************************
                T1_A=EVec{1}(1:NS(1),ii)'*MAT_A*EVec{2}(1:NS(2),jj);
                T1_B=EVec{1}(1:NS(1),ii)'*MAT_B*EVec{2}(1:NS(2),jj); 

                %***********************************
                %Calc. the transition rel. intensity
                %***********************************
                I_TEMP=abs(T1_A)^2+abs(T1_B)^2;
                
                %************************************
                %Assign the transition rel. intensity
                %************************************
                if I_TEMP>0
                    %*******************
                    %Advance dummy index
                    %*******************
                    uu=uu+1;

                    %***************************
                    %Assign photon mixing number
                    %***************************
                    NP(uu)=0;

                    %***********************************
                    %Assign lower and upper level states
                    %***********************************
                    LL(uu)=ii;
                    UL(uu)=jj;

                    %******************************
                    %Assign intensities to 1D array
                    %******************************
                    I(uu)=I_TEMP;

                    %***************************
                    %Assign energies to 1D array
                    %***************************
                    E(uu)=EVal{2}(jj)-EVal{1}(ii);
                end
            end
        end 
    else
        %*******************
        %Energy of RF photon
        %*******************
        FE=2*pi*hbar*NU/q;
        
        %*******************
        %Assign loop indices
        %*******************
        N1=2*NB(1)+1;
        N2=2*NB(2)+1;
        N3=2*NB_MAX+1;
        N4=4*NB_MAX+1;

        %*************************************
        %Initialize temporary intensity arrray
        %*************************************
        I_TEMP(1:N4)=0;
        
        %********************************************************
        %Calc. the rel. intensity for a Floquet structured matrix
        %********************************************************
        for ii=1:NS(1)
            for jj=1:NS(2)
                
                %********************************
                %Reset temporary intensity arrray
                %********************************
                I_TEMP(1:N4)=0;
                
                for kk=1:N1
                    for ll=1:N2
                        %*************************************************
                        %Calc. the multi-photon expectation value of eps*r 
                        %*************************************************
                        T1_A=EVec{1}(1+NS(1)*(kk-1):NS(1)*kk,ii)'*MAT_A*EVec{2}(1+NS(2)*(ll-1):NS(2)*ll,jj);
                        T1_B=EVec{1}(1+NS(1)*(kk-1):NS(1)*kk,ii)'*MAT_B*EVec{2}(1+NS(2)*(ll-1):NS(2)*ll,jj);

                        T2_A=0;
                        T2_B=0;
                        for mm=1:N1
                            nn=ll-kk+mm;
                            if nn>=1 && nn<=N2
                                T2_A=T2_A+conj(EVec{1}(1+NS(1)*(mm-1):NS(1)*mm,ii,1)'*MAT_A*EVec{2}(1+NS(2)*(nn-1):NS(2)*nn,jj));
                                T2_B=T2_B+conj(EVec{1}(1+NS(1)*(mm-1):NS(1)*mm,ii,1)'*MAT_B*EVec{2}(1+NS(2)*(nn-1):NS(2)*nn,jj));
                            end
                        end
                        
                        %************************************************
                        %Calc. the rel. multi-photon transition intensity
                        %************************************************
                        T3=T1_A*T2_A+T1_B*T2_B;
                        
                        %*******************************************
                        %Assign the order of multi-photon transition
                        %*******************************************
                        oo=N3+(ll-(NB(2)+1))-(kk-(NB(1)+1)); 
                        
                        %*************************************************
                        %Assign the rel. multi-photon transition intensity
                        %*************************************************
                        I_TEMP(oo)=I_TEMP(oo)+T3;
                    end
                end
                
                for kk=1:N4
                    if I_TEMP(kk)>0
                        %*******************
                        %Advance dummy index
                        %*******************
                        uu=uu+1;

                        %***************************
                        %Assign photon mixing number
                        %***************************
                        NP(uu)=kk-N3;

                        %***********************************
                        %Assign lower and upper level states
                        %***********************************
                        LL(uu)=ii;
                        UL(uu)=jj;

                        %******************************
                        %Assign intensities to 1D array
                        %******************************
                        I(uu)=I_TEMP(kk);

                        %***************************
                        %Assign energies to 1D array
                        %***************************
                        E(uu)=EVal{2}(jj)-EVal{1}(ii)+(kk-N3)*FE;
                    end
                end
            end
        end
    end      
    
else
 
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><><>        Calc. observeration cord vector components            <><><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>   
    
    GEO_M=EPS.GEO_M;
    GEO_0=EPS.GEO_0;
    GEO_P=EPS.GEO_P;
     
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><>  Calc. relative intesity integrated about the azimuthal angle    <><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    
    if NB_MAX==0
        %************************************************************
        %Calc. the rel. intensity for a non-Floquet structured matrix
        %************************************************************
        for ii=1:NS(1)
            for jj=1:NS(2)
                %********************************
                %Calc. the expectation value of r
                %********************************
                T1_M=EVec{1}(1:NS(1),ii)'*MAT_M*EVec{2}(1:NS(2),jj);
                T1_0=EVec{1}(1:NS(1),ii)'*MAT_0*EVec{2}(1:NS(2),jj);
                T1_P=EVec{1}(1:NS(1),ii)'*MAT_P*EVec{2}(1:NS(2),jj);

                %***********************************
                %Calc. the transition rel. intensity
                %***********************************
                I_TEMP=GEO_M*abs(T1_M)^2+GEO_0*abs(T1_0)^2+GEO_P*abs(T1_P)^2;
                
                %************************************
                %Assign the transition rel. intensity
                %************************************
                if I_TEMP>0
                    %*******************
                    %Advance dummy index
                    %*******************
                    uu=uu+1;

                    %***************************
                    %Assign photon mixing number
                    %***************************
                    NP(uu)=0;

                    %***********************************
                    %Assign lower and upper level states
                    %***********************************
                    LL(uu)=ii;
                    UL(uu)=jj;

                    %******************************
                    %Assign intensities to 1D array
                    %******************************
                    I(uu)=I_TEMP;

                    %***************************
                    %Assign energies to 1D array
                    %***************************
                    E(uu)=EVal{2}(jj)-EVal{1}(ii);
                end
            end
        end 
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %RESERVED FOR FUTURE USE%
        %%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
end

%****************************
%Assign number of transitions
%****************************
NT=uu;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%<><>                      Drop small intensities                      <><>
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

%***************
%Allocate memory
%***************
NP_TEMP(1:NT)=0;
LL_TEMP(1:NT)=0;
UL_TEMP(1:NT)=0;

I_TEMP(1:NT)=0;
E_TEMP(1:NT)=0;

%***********************
%Calc. maximum intensity
%***********************
I_MAX=max(I);

%***********************
%Initialize dummy indice
%***********************
jj=0;

for ii=1:NT
    if I(ii)/I_MAX>MIN_RATIO
        %********************
        %Advance dummy indice
        %********************
        jj=jj+1;
        
        %***************************
        %Assign photon mixing number
        %***************************
        NP_TEMP(jj)=NP(ii);

        %***********************************
        %Assign lower and upper level states
        %***********************************
        LL_TEMP(jj)=LL(ii);
        UL_TEMP(jj)=UL(ii);

        %******************************
        %Assign intensities to 1D array
        %******************************
        I_TEMP(jj)=I(ii);

        %***************************
        %Assign energies to 1D array
        %***************************
        E_TEMP(jj)=E(ii);
    end
end
    
%****************************
%Update number of transitions
%****************************
NT=jj;

%*****************
%Update the arrays
%*****************
NP=NP_TEMP(1:NT);
LL=LL_TEMP(1:NT);
UL=UL_TEMP(1:NT);

I=I_TEMP(1:NT);
E=E_TEMP(1:NT);

%******************************
%Calc. the transtion probablity
%******************************
I=q^2*(q*E/hbar).^3/(8*pi^2*eo*hbar*c^3).*I;

%***********************************************
%Assign default quasistatic approximation number
%***********************************************
QSAN(1:NT)=1;

%**************************************
%Converting photon energy to wavelength
%**************************************
X=E_2_LAM(E);

%**********************************************
%Correct wavelength for the index of refraction
%**********************************************
X=X/REF;

%****************************
%Assign the discrete specturm
%****************************
FULL.X=X;
FULL.I=I;
FULL.NT=NT;
FULL.NT_QSA=[1 NT];

STATE.QSAN=QSAN;
STATE.NP=NP;
STATE.LL=LL;
STATE.UL=UL;

FULL.STATE=STATE;

%********************
%Assigning the output
%********************
SPECTRA.DISC.FULL=FULL;

end

