function MAT_0=B_MAT(PARA,UNIV)

%**************************************************************************
%This function calculates the matrix elements for a magnetic field that
%only has a component in the z-direction. The units of the calculated
%matrix elements are eV.
%**************************************************************************
%                               INPUTS
%**************************************************************************
%n -- principal quantum number
%
%Bo --  magnetic field strength, units must be Tesla.  The geometry of the
%       problem is set such that B lies along the z-direction.
%
%diagnositc=[x1,x2,x3] -- Array of length three. Contains the logic
%                         associated with the diagnoustics.
%
%                      x=0 diagnoustic off
%                      x=1 diagnoustic on
%                      
%                      x1 is associated with the matrix elements
%                      
%                      x2 is associated with anayltical calculations
%                      
%                      x3 is associated with checking to make sure H is
%                         Hermitian
%
%**************************************************************************
%                                OUTPUTS
%**************************************************************************
%H  -- Is a matrix of size NS x NS and contains the matrix elements in
%      units of eV
%
%**************************************************************************
%The matrix elements are those associated with the coupled basis set:
%**************************************************************************
%                               |s,l,j,mj>
%**************************************************************************
%The matrix elements are:
%**************************************************************************
%                        <s,l',j',mj'|H|s,l,j,mj>
%**************************************************************************
%The operator takes the form:
%**************************************************************************
%                          H=beta/hbar*(B(J+S))
%**************************************************************************

%************
%Assign input
%************
NS=PARA.NS;
QN=PARA.QN;

hbar=UNIV.hbar;
q=UNIV.q;
me=UNIV.me;

%********************
%Calc. Bohr magnetron
%********************
mu_o=q*hbar/(2*me);

%***************
%Allocate memory
%***************
MAT_0=cell(2,1);
for ii=1:2
    MAT_0{ii}(1:NS,1:NS)=0;
end

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||  CALC MAGNETIC FIELD MATRIX ELEMENTS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

for ii=1:2
    for jj=1:NS(ii)
        mj=QN{ii,jj}(5);    
        MAT_0{ii}(jj,jj)=mu_o/q*mj;
    end

    for jj=1:NS(ii)
        for kk=1:NS(ii)
            if QN{ii,jj}(2)==QN{ii,kk}(2)
                if QN{ii,jj}(3)==QN{ii,kk}(3)
                    if (QN{ii,jj}(4)==QN{ii,kk}(4) && QN{ii,jj}(4)~=0) || QN{ii,jj}(4)==QN{ii,kk}(4)+1 || QN{ii,jj}(4)==QN{ii,kk}(4)-1
                        if QN{ii,jj}(5)==QN{ii,kk}(5)
                            %**********************
                            %Assign quantum numbers
                            %********************** 
                            s=QN{ii,jj}(2);
                            l=QN{ii,jj}(3);
                            j_1=QN{ii,jj}(4);
                            j_2=QN{ii,kk}(4);                   
                            mj_1=QN{ii,jj}(5);
                            mj_2=QN{ii,kk}(5);
                             
                            %********************
                            %Calc. matrix element
                            %********************
                            MAT_0{ii}(jj,kk)=MAT_0{ii}(jj,kk)+mu_o/q*((2*s+1)*(s+1)*s)^0.5*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(s+l-mj_1)*THREE_J_ANA(j_1,j_2,1,-mj_1,mj_2,0)*SIX_J_ANA(l,j_1,s,1,s,j_2);
                        end
                    end
                end
            end
        end
    end
end

end