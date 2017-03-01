function DATA=Dipole_Trans(EVec,EVal,OBS,PARA,FIELD,UNIV,OPT)

%**************************************************************************
%This function calculates the relative intensity of all transitions induced
%by an ELECTRIC DIPOLE from intitial state with radial quantum number n(1)
%to final state with radial quantum number n(2) FOR HYDROGEN.

%**************************************************************************
%Calculating the matrix elements associated with the coupled basis set for 
%the electric dipole operator
%**************************************************************************
%                           <phi(ii)|eps*r|phi(jj)> 
%                       
%                         ii=[1:NS(1)] and jj=[1:NS(2)]
%**************************************************************************

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
%                               OUTPUT
%**************************************************************************
%
%**************************************************************************
%                               OPTIONS
%**************************************************************************
%Due to machine error transitions that should have zero for there relative
%intensity do not and instead have a very small value.  All transistions
%with relative a intensity ratio (when compared with the max relative 
%intensity) less than error are set to zero.  If the user does not want to
%drop this superfical transitions set error=0.
%
err=[1e-10 1e-8];
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
POL=OBS.POL;
VIEW=OBS.VIEW;

NS=PARA.NS;
QN=PARA.QN;
NB=PARA.NB;
WF=PARA.WF;

NU=FIELD.ERF.NU;

hbar=UNIV.hbar;
q=UNIV.q;

REF=OPT.SPEC.REF;

%*****************************
%Max. number of Floquet blocks
%*****************************
NB_MAX=max(NB);

%****************
%Energy of photon
%****************
FE=2*pi*hbar*NU/q;

%**************************
%Define polarization vector
%**************************
EPS_X_A=-cos(VIEW.POLAR)*cos(VIEW.AZIM);
EPS_Y_A=-cos(VIEW.POLAR)*sin(VIEW.AZIM);
EPS_Z_A=sin(VIEW.POLAR);

EPS_X_B=-sin(VIEW.AZIM);
EPS_Y_B=cos(VIEW.AZIM);
EPS_Z_B=0;

%*******************
%Define polarization 
%*******************
EPS_X_A_POL=POL.T(1)*(EPS_X_A*cos(POL.ANG)+EPS_X_B*sin(POL.ANG));
EPS_Y_A_POL=POL.T(1)*(EPS_Y_A*cos(POL.ANG)+EPS_Y_B*sin(POL.ANG));
EPS_Z_A_POL=POL.T(1)*(EPS_Z_A*cos(POL.ANG)+EPS_Z_B*sin(POL.ANG));

EPS_X_B_POL=POL.T(2)*(-EPS_X_A*sin(POL.ANG)+EPS_X_B*cos(POL.ANG));
EPS_Y_B_POL=POL.T(2)*(-EPS_Y_A*sin(POL.ANG)+EPS_Y_B*cos(POL.ANG));
EPS_Z_B_POL=POL.T(2)*(-EPS_Z_A*sin(POL.ANG)+EPS_Z_B*cos(POL.ANG));

%********************************************
%Calc. spherical basis of polarization vector
%********************************************
EPS_SB_A(1)=-1/2^0.5*(EPS_X_A_POL+1i*EPS_Y_A_POL);
EPS_SB_A(2)=EPS_Z_A_POL;
EPS_SB_A(3)=1/2^0.5*(EPS_X_A_POL-1i*EPS_Y_A_POL);

EPS_SB_B(1)=-1/2^0.5*(EPS_X_B_POL+1i*EPS_Y_B_POL);
EPS_SB_B(2)=EPS_Z_B_POL;
EPS_SB_B(3)=1/2^0.5*(EPS_X_B_POL-1i*EPS_Y_B_POL);

%***************
%Allocate memory
%***************
MAT_A(1:NS(1),1:NS(2))=0;
MAT_B(1:NS(1),1:NS(2))=0;

%//////////////////////////////////////////////////////////////////////////
%||||||||||||||||| CALC ELECTRIC DIPOLE MATRIX ELEMENTS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

for ii=1:NS(1)
    for jj=1:NS(2)
        if QN{1,ii}(2)==QN{2,jj}(2)       
            if QN{1,ii}(3)==QN{2,jj}(3)+1 || QN{1,ii}(3)==QN{2,jj}(3)-1 || (WF==0 && QN{1,ii}(3)~=0 && QN{1,ii}(3)==QN{2,jj}(3))
                if (QN{1,ii}(4)==QN{2,jj}(4) && QN{1,ii}(4)~=0) || QN{1,ii}(4)==QN{2,jj}(4)+1 || QN{1,ii}(4)==QN{2,jj}(4)-1
                    %**********************
                    %Assign quantum numbers
                    %**********************
                    n_1=QN{1,ii}(1);
                    n_2=QN{2,jj}(1);
                    s=QN{1,ii}(2);
                    l_1=QN{1,ii}(3);
                    l_2=QN{2,jj}(3);
                    j_1=QN{1,ii}(4);
                    j_2=QN{2,jj}(4);
                    mj_1=QN{1,ii}(5);
                    mj_2=QN{2,jj}(5);      
                    
                    if QN{1,ii}(5)==QN{2,jj}(5)-1
                        
                        %//////////////////////////////////////////////////
                        %|||||||||||||||    -eps(1)r(3)    ||||||||||||||||
                        %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                        
                        %********************************
                        %Calc. the reduced matrix element
                        %********************************
                        if WF==1
                            MAT_RED=Reduced_MAT(n_1,l_1,n_2,l_2,UNIV);
                        else
                            MAT_RED=1;
                        end
                        
                        %********************
                        %Calc. matrix element
                        %********************
                        MAT=MAT_RED*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(2*j_1+1+s+l_2-mj_1)*Three_J_Num(j_1,1,j_2,-mj_1,-1,mj_2)*Six_J_Num(l_1,j_1,s,j_2,l_2,1);

                        %*************************************************
                        %Calc. orthogonal observation cord matrix elements
                        %*************************************************
                        MAT_A(ii,jj)=MAT_A(ii,jj)-EPS_SB_A(1)*MAT;
                        MAT_B(ii,jj)=MAT_B(ii,jj)-EPS_SB_B(1)*MAT;
                        
                    elseif QN{1,ii}(5)==QN{2,jj}(5)
                        
                        %//////////////////////////////////////////////////
                        %|||||||||||||||     eps(2)r(2)    ||||||||||||||||
                        %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                        
                        %********************************
                        %Calc. the reduced matrix element
                        %********************************
                        if WF==1
                            MAT_RED=Reduced_MAT(n_1,l_1,n_2,l_2,UNIV);
                        else
                            MAT_RED=1;
                        end

                        %********************
                        %Calc. matrix element
                        %********************
                        MAT=MAT_RED*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(2*j_1+1+s+l_2-mj_1)*Three_J_Num(j_1,1,j_2,-mj_1,0,mj_2)*Six_J_Num(l_1,j_1,s,j_2,l_2,1);
                        
                        %*************************************************
                        %Calc. orthogonal observation cord matrix elements
                        %*************************************************
                        MAT_A(ii,jj)=MAT_A(ii,jj)+EPS_SB_A(2)*MAT;
                        MAT_B(ii,jj)=MAT_B(ii,jj)+EPS_SB_B(2)*MAT;
                        
                    elseif QN{1,ii}(5)==QN{2,jj}(5)+1
                        
                        %//////////////////////////////////////////////////
                        %|||||||||||||||    -eps(3)r(1)    ||||||||||||||||
                        %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                        
                        %********************************
                        %Calc. the reduced matrix element
                        %********************************
                        if WF==1
                            MAT_RED=Reduced_MAT(n_1,l_1,n_2,l_2,UNIV);
                        else
                            MAT_RED=1;
                        end
                        
                        %********************
                        %Calc. matrix element
                        %********************
                        MAT=MAT_RED*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(2*j_1+1+s+l_2-mj_1)*Three_J_Num(j_1,1,j_2,-mj_1,1,mj_2)*Six_J_Num(l_1,j_1,s,j_2,l_2,1);
                        
                        %*************************************************
                        %Calc. orthogonal observation cord matrix elements
                        %*************************************************
                        MAT_A(ii,jj)=MAT_A(ii,jj)-EPS_SB_A(3)*MAT;
                        MAT_B(ii,jj)=MAT_B(ii,jj)-EPS_SB_B(3)*MAT;
                    end
                end
            end
        end
    end
end

%**********************************************
%Calc. relative intensity and transition energy
%**********************************************
N1=2*NB(1)+1;
N2=2*NB(2)+1;
N3=2*NB_MAX+1;

I(1:NS(1),1:NS(2),1:4*NB_MAX+1)=0; 
E(1:NS(1),1:NS(2))=0;
for ii=1:NS(1)
    for jj=1:NS(2)
        for kk=1:N1
            for ll=1:N2
                T1_A=EVec{1}(1+NS(1)*(kk-1):NS(1)*kk,ii)'*MAT_A*EVec{2}(1+NS(2)*(ll-1):NS(2)*ll,jj);
                T1_B=EVec{1}(1+NS(1)*(kk-1):NS(1)*kk,ii)'*MAT_B*EVec{2}(1+NS(2)*(ll-1):NS(2)*ll,jj);
                if NB_MAX==0
                    I(ii,jj,1)=abs(T1_A)^2+abs(T1_B)^2;
                else
                    T2_A=0;
                    T2_B=0;
                    for mm=1:N1
                        nn=ll-kk+mm;
                        if (nn>=1) && (nn<=N2)
                            T2_A=T2_A+conj(EVec{1}(1+NS(1)*(mm-1):NS(1)*mm,ii,1)'*MAT_A*EVec{2}(1+NS(2)*(nn-1):NS(2)*nn,jj));
                            T2_B=T2_B+conj(EVec{1}(1+NS(1)*(mm-1):NS(1)*mm,ii,1)'*MAT_B*EVec{2}(1+NS(2)*(nn-1):NS(2)*nn,jj));
                        end
                    end
                    
                    T3=T1_A*T2_A+T1_B*T2_B;
                    
                    oo=N3+(ll-(NB(2)+1))-(kk-(NB(1)+1)); 
                    I(ii,jj,oo)=I(ii,jj,oo)+T3;
                end
            end
        end
        
        E(ii,jj)=EVal{2}(jj)-EVal{1}(ii);
    end
end

%********************
%Dropping small terms
%********************
NT=0;
I_MAX=max(max(max(I)));
for ii=1:4*NB_MAX+1
    for jj=1:NS(1)
        for kk=1:NS(2)
            if abs(imag(I(jj,kk,ii)))/I_MAX<=err(1)
                I(jj,kk,ii)=real(I(jj,kk,ii));
            else
                fprintf('****************************WARNING*****************************\n')
                fprintf('     The relative intensity of a transition is imaginary\n')
                fprintf('****************************WARNING*****************************\n')
            end
            
            if I(jj,kk,ii)/I_MAX<=err(2)
                I(jj,kk,ii)=0;
            else
                NT=NT+1;
            end
        end
    end
end

%***************
%Allocate memory
%***************
I_D(1:NT)=0;
E_D(1:NT)=0;

ll=0;
N1=2*NB_MAX+1;
for ii=1:4*NB_MAX+1
    for jj=1:NS(1)
        for kk=1:NS(2)
            if I(jj,kk,ii)>0
                %***********
                %Dummy index
                %***********
                ll=ll+1;
                
                %******************************
                %Assign intensities to 1D array
                %******************************
                I_D(ll)=I(jj,kk,ii);
                
                %***************************
                %Assign energies to 1D array
                %***************************
                if NB_MAX==0
                    E_D(ll)=E(jj,kk);
                else
                    E_D(ll)=E(jj,kk)+(ii-N1)*FE;
                end
            end
        end
    end
end

%**************************************
%Converting photon energy to wavelength
%**************************************
X_D=dE_2_lam(E_D);

%**********************************************
%Correct wavelength for the index of refraction
%**********************************************
X_D=X_D/REF;

%********************
%Assigning the output
%********************
DATA.DISC.I=I_D;
DATA.DISC.X=X_D;
DATA.DISC.NT=NT;

end

