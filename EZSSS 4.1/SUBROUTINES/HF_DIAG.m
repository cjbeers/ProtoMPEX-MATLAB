function HF_DIAG(HAM,PARA)

%**************************************************************************
%This function serves as a diagnostic for calculations of the matrix
%elements associated with an operator H.
%**************************************************************************

%**********************
%Machine error estimate
%**********************
EPS_IMAG=1e-8;
EPS_REAL=1e-8;

%*******************************
%Name for lower and upper levels
%*******************************
LEVEL={'lower level','upper level'};

%*******************
%Assigning the input
%*******************
HF=HAM.FLOQ;

NBS=PARA.NBS;
QN=PARA.QN;

%***************************
%Calc. the eig. vectors of H
%***************************
EVec=cell(2,1);
for ii=1:2
    [EVec{ii},~]=eig(HF{ii});
end

%***************
%Allocate memory
%***************
L2=cell(2,1);
for ii=1:2
    L2{ii}(1:NBS(ii),1:NBS(ii))=0;
end

%*****************
%Calc. the L2 norm
%*****************
for ii=1:2
    for jj=1:NBS(ii)
        for kk=1:NBS(ii)
            L2{ii}(jj,kk)=EVec{ii}(1:NBS(ii),jj)'*EVec{ii}(1:NBS(ii),kk);
        end
    end
end

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||     ORTHONORMALITY TEST   ||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
for ii=1:2
    for jj=1:NBS(ii)
        for kk=1:NBS(ii) 
            %*********************************
            %Removing imaginary roundoff error
            %*********************************
            if abs(imag(L2{ii}(kk,jj)))<EPS_IMAG  
                L2{ii}(kk,jj)=real(L2{ii}(kk,jj));
            end

            %****************************
            %Removing real roundoff error
            %****************************
            if abs(L2{ii}(kk,jj))<EPS_REAL
                L2{ii}(kk,jj)=0;
            end
            
            %***************************
            %Checking the orthonormality
            %***************************
            if abs(L2{ii}(kk,jj))>0
                if abs(kk-jj)>0
                    fprintf('\n**************************************WARNING*************************************\n')
                    fprintf('** The Floquet eigenfunctions %2i and %2i are not orthoganal for the %12s **\n',kk,jj,LEVEL{ii})
                    fprintf('**************************************WARNING*************************************\n\n')
                else
                    if abs(abs(L2{ii}(kk,jj))-1)>EPS_REAL
                        fprintf('\n**************************************WARNING*************************************\n')
                        fprintf('** The Floquet eigenfunctions %2i and %2i are not normalized for the %12s **\n',kk,jj,LEVEL{ii})
                        fprintf('**************************************WARNING*************************************\n\n')
                    end
                end
            end
        end
    end
end

%//////////////////////////////////////////////////////////////////////////
%|||||||||||||||||||||||    HERMITIAN MATRIX TEST  ||||||||||||||||||||||||
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\  

for ii=1:2
    %****************************
    %Calc. hamiltonian difference
    %****************************
    DIFF=HF{ii}-HF{ii}';
    
    %********************
    %Normalize difference
    %********************
    MAX=max(max(abs(HF{ii})));
    if MAX>0
        DIFF=DIFF/MAX;
    end
    
    if sum(sum(abs(DIFF),2),1)>EPS_REAL
        fprintf('\n**********************************************************************************\n')
        fprintf('**     The Floquet Hamiltonian matrix is not Hermitian for the %12s     **\n',LEVEL{ii})
        fprintf('**********************************************************************************\n\n')

        for jj=1:NBS(ii)
            for kk=1:NBS(ii)
                if abs(DIFF(jj,kk))>EPS_REAL     
                    fprintf('**************************************************************************\n')
                    fprintf('**                        <%2i|%2i> = %8.6e                        **\n',jj,kk,DIFF(jj,kk))
                    fprintf('**************************************************************************\n')
                    fprintf('**               <%2i| ---> n=%1i s=%2.1f l=%1i j=%2.1f mj=%2.1f                  **\n',jj,QN{ii,jj}(1),QN{ii,jj}(2),QN{ii,jj}(3),QN{ii,jj}(4),QN{ii,jj}(5))
                    fprintf('**************************************************************************\n')
                    fprintf('**               |%2i> ---> n=%1i s=%2.1f l=%1i j=%2.1f mj=%2.1f                   **\n',kk,QN{ii,kk}(1),QN{ii,kk}(2),QN{ii,kk}(3),QN{ii,kk}(4),QN{ii,kk}(5))
                    fprintf('**************************************************************************\n\n')
                end
            end
        end
    end
end

end