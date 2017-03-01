function H=B_MAT(B,PARA,UNIV,DIAG,Ho)

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
H=cell(2,1);
for ii=1:2
    H{ii}(1:NS,1:NS)=0;
end

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||  CALC ELECTRIC FIELD MATRIX ELEMENTS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

for ii=1:2
    for jj=1:NS(ii)
        mj=QN{ii,jj}(5);    
        H{ii}(jj,jj)=mu_o/q*B*mj;
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
                            H{ii}(jj,kk)=H{ii}(jj,kk)+mu_o/q*B*((2*s+1)*(s+1)*s)^0.5*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(s+l-mj_1)*Three_J_Ana(j_1,j_2,1,-mj_1,mj_2,0)*Six_J_Ana(l,j_1,s,1,s,j_2);
                        end
                    end
                end
            end
        end
    end
end

%*********************
%Hermitian matrix test
%*********************
if DIAG(1)==1
    for ii=1:2
        HC=H{ii}-H{ii}';
        if sum(sum(abs(HC),2),1)>0
            fprintf('\n**************************************************************************\n')
            fprintf('   Matrix Associated with B(J+S) Operator is not Hermitian for n= %1i\n',n(ii))
            fprintf('**************************************************************************\n\n')

            for jj=1:NS(ii)
                for kk=1:NS(ii)
                    if (abs(HC(jj,kk))>0)       
                        fprintf('**************************************************************************\n')
                        fprintf('                    <%2i|%2i> = %21.16e\n',jj,kk,HC(jj,kk))
                        fprintf('**************************************************************************\n')
                        fprintf('   <%i| --- n=%1i s=%2.1f l=%1i j=%2.1f mj=%2.1f\n',jj,QN{ii,jj}(1),QN{ii,jj}(2),QN{ii,jj}(3),QN{ii,jj}(4),QN{ii,jj}(5))
                        fprintf('**************************************************************************\n')
                        fprintf('   |%i> --- n=%1i s=%2.1f l=%1i j=%2.1f mj=%2.1f\n',kk,QN{ii,kk}(1),QN{ii,kk}(2),QN{ii,kk}(3),QN{ii,kk}(4),QN{ii,kk}(5))
                        fprintf('**************************************************************************\n\n')
                    end
                end
            end
        end
    end
end

%**************************
%Matrix element diagnoustic
%**************************
if DIAG(2)==1
    H_Diag(H,PARA,Ho)
end

end