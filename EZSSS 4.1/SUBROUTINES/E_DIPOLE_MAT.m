function [MAT_P,MAT_0,MAT_M]=E_DIPOLE_MAT(PARA,UNIV)

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

%************
%Assign input
%************
NS=PARA.NS;
QN=PARA.QN;
WF=PARA.WF;

%***************
%Allocate memory
%***************
MAT_M(1:NS(1),1:NS(2))=0;
MAT_0(1:NS(1),1:NS(2))=0;
MAT_P(1:NS(1),1:NS(2))=0;

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
                        %|||||||||||||||        r(3)       ||||||||||||||||
                        %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                        
                        %********************************
                        %Calc. the reduced matrix element
                        %********************************
                        if WF==1
                            MAT_RED=REDUCED_MAT(n_1,l_1,n_2,l_2,UNIV);
                        else
                            MAT_RED=1;
                        end
                        
                        %********************
                        %Calc. matrix element
                        %********************
                        MAT_M(ii,jj)=MAT_RED*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(2*j_1+1+s+l_2-mj_1)*THREE_J_NUM(j_1,1,j_2,-mj_1,-1,mj_2)*SIX_J_NUM(l_1,j_1,s,j_2,l_2,1);
                        
                    elseif QN{1,ii}(5)==QN{2,jj}(5)
                        
                        %//////////////////////////////////////////////////
                        %|||||||||||||||     eps(2)r(2)    ||||||||||||||||
                        %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                        
                        %********************************
                        %Calc. the reduced matrix element
                        %********************************
                        if WF==1
                            MAT_RED=REDUCED_MAT(n_1,l_1,n_2,l_2,UNIV);
                        else
                            MAT_RED=1;
                        end

                        %********************
                        %Calc. matrix element
                        %********************
                        MAT_0(ii,jj)=MAT_RED*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(2*j_1+1+s+l_2-mj_1)*THREE_J_NUM(j_1,1,j_2,-mj_1,0,mj_2)*SIX_J_NUM(l_1,j_1,s,j_2,l_2,1);
                        
                    elseif QN{1,ii}(5)==QN{2,jj}(5)+1
                        
                        %//////////////////////////////////////////////////
                        %|||||||||||||||    -eps(3)r(1)    ||||||||||||||||
                        %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                        
                        %********************************
                        %Calc. the reduced matrix element
                        %********************************
                        if WF==1
                            MAT_RED=REDUCED_MAT(n_1,l_1,n_2,l_2,UNIV);
                        else
                            MAT_RED=1;
                        end
                        
                        %********************
                        %Calc. matrix element
                        %********************
                        MAT_P(ii,jj)=MAT_RED*((2*j_1+1)*(2*j_2+1))^0.5*(-1)^(2*j_1+1+s+l_2-mj_1)*THREE_J_NUM(j_1,1,j_2,-mj_1,1,mj_2)*SIX_J_NUM(l_1,j_1,s,j_2,l_2,1);

                    end
                end
            end
        end
    end
end

end

