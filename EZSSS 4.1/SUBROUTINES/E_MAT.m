function [MAT_P,MAT_0,MAT_M]=E_MAT(PARA,UNIV)

%**************************************************************************
%This function calculates the matrix elements for an Electric field that
%has x, y, and z components.  We do not consider mixing of states with
%different n values.  The units of the calculated matrix elements is eV.
%**************************************************************************
%                               INPUTS
%**************************************************************************
%n -- principal quantum number
%
%EDC=[Ex,Ey,Ez] --  Array of length three.  Contains the electric field
%                   strength associated with the cartesian components in 
%                   units of V/m
%
%                      Ex - x-component
%                      
%                      Ey - y-component
%                      
%                      Ez - z-component
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
%                               |n,s,l,j,mj>
%**************************************************************************
%The matrix elements are:
%**************************************************************************
%                        <n,s,l',j',mj'|H|n,s,l,j,mj>
%**************************************************************************
%The operator takes the form (in the spheical basis):
%**************************************************************************
%                      H=-e*E(3)r(1)+e*E(2)r(2)-e*E(1)r(3)
%**************************************************************************

%*******************
%Assigning the input
%*******************
NS=PARA.NS;
QN=PARA.QN;

%***************
%Allocate memory
%***************
MAT_P=cell(2,1);
MAT_0=cell(2,1);
MAT_M=cell(2,1);
for ii=1:2
    MAT_P{ii}(1:NS(ii),1:NS(ii))=0;
    MAT_0{ii}(1:NS(ii),1:NS(ii))=0;
    MAT_M{ii}(1:NS(ii),1:NS(ii))=0;
end

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||  CALC ELECTRIC FIELD MATRIX ELEMENTS |||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

for ii=1:2
    for jj=1:NS(ii)
        for kk=1:NS(ii)
            if QN{ii,jj}(2)==QN{ii,kk}(2)     
                if QN{ii,jj}(3)==QN{ii,kk}(3)+1 || QN{ii,jj}(3)==QN{ii,kk}(3)-1
                    if (QN{ii,jj}(4)==QN{ii,kk}(4) && QN{ii,jj}(4)~=0) || QN{ii,jj}(4)==QN{ii,kk}(4)+1 || QN{ii,jj}(4)==QN{ii,kk}(4)-1
                        %**********************
                        %Assign quantum numbers
                        %**********************  
                        n=QN{ii,jj}(1);
                        s=QN{ii,jj}(2);
                        l_1=QN{ii,jj}(3);
                        l_2=QN{ii,kk}(3);                  
                        j_1=QN{ii,jj}(4);
                        j_2=QN{ii,kk}(4);
                        mj_1=QN{ii,jj}(5);
                        mj_2=QN{ii,kk}(5);
                        
                        if QN{ii,jj}(5)==QN{ii,kk}(5)-1
                            
                            %//////////////////////////////////////////////
                            %|||||||||||||||      e*r(3)   ||||||||||||||||
                            %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

                            %********************************
                            %Calc. the reduced matrix element
                            %********************************
                            MAT_RED=REDUCED_MAT(n,l_1,n,l_2,UNIV);
                            
                            %********************
                            %Calc. matrix element
                            %********************
                            MAT_M{ii}(jj,kk)=MAT_RED*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(2*j_1-mj_1+s+l_2+1)*THREE_J_ANA(j_1,j_2,1,mj_1,-mj_2,1)*SIX_J_ANA(s,l_1,j_1,1,j_2,l_2);
                        
                        elseif QN{ii,jj}(5)==QN{ii,kk}(5)
                            
                            %//////////////////////////////////////////////
                            %|||||||||||||||     e*r(2)    ||||||||||||||||
                            %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

                            %********************************
                            %Calc. the reduced matrix element
                            %********************************
                            MAT_RED=REDUCED_MAT(n,l_1,n,l_2,UNIV);
                            
                            %********************
                            %Calc. matrix element
                            %********************
                            MAT_0{ii}(jj,kk)=MAT_RED*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(2*j_1-mj_1+s+l_2+1)*THREE_J_ANA(j_2,j_1,1,mj_2,-mj_1,0)*SIX_J_ANA(s,l_1,j_1,1,j_2,l_2);
                       
                        elseif QN{ii,jj}(5)==QN{ii,kk}(5)+1
                            
                            %//////////////////////////////////////////////
                            %|||||||||||||||      e*r(1)   ||||||||||||||||
                            %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

                            %********************************
                            %Calc. the reduced matrix element
                            %********************************
                            MAT_RED=REDUCED_MAT(n,l_1,n,l_2,UNIV);  
                            
                            %********************
                            %Calc. matrix element
                            %********************
                            MAT_P{ii}(jj,kk)=MAT_RED*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(2*j_1-mj_1+s+l_2+1)*THREE_J_ANA(j_2,j_1,1,mj_2,-mj_1,1)*SIX_J_ANA(s,l_1,j_1,1,j_2,l_2);
                        
                        end
                    end
                end
            end
        end
    end
end

end