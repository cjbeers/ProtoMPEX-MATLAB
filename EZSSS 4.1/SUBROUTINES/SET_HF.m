function HF=SET_HF(H,PARA,FIELD,UNIV)

%**************************************************************************
%**************************************************************************
%This function calculates the Floquet matrix given the pertrubed
%Hamiltonian, H, and the number of Floquet blocks, NB.  The unperturbed
%Hamiltonian is not induced in the Flqouet matrix.
%**************************************************************************\

%************
%Assign input
%************
NS=PARA.NS;
NB=PARA.NB;
NBS=PARA.NBS;

NH=FIELD.ERF.NH;
NU=FIELD.ERF.NU;

hbar=UNIV.hbar;
q=UNIV.q;

%***************
%Allocate memory
%***************
HF=cell(2,1);
for ii=1:2
    HF{ii}(1:NBS(ii),1:NBS(ii))=0;
end

%*******************
%Energy of RF photon
%*******************
PE=2*pi*hbar*NU/q;

%**************************
%Assign the identity matrix
%**************************
EYE=cell(1,2);
for ii=1:2
    EYE{ii}=eye(NS(ii));
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%||||||||||||||||||||||| Assign Floquet Hamiltonian |||||||||||||||||||||||
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
for ii=1:2
    for jj=1:1+2*NB(ii)
        for kk=1:1+2*NH     
            %***************************
            %Assign Floquet block indice
            %***************************
            if kk==1
                ll=0;
            elseif kk>1 && kk<=1+NH
                ll=kk-1;
            elseif kk>1+NH && kk<=1+2*NH
                ll=(1+NH)-kk;
            end
            
            %******************************
            %Assign the multi-photon number
            %******************************
            PN=NB(ii)-(jj-1);

            %**************************************
            %Assign the Floquet Hamiltonian indices
            %**************************************
            IND1=1+(jj-1)*NS(ii);
            IND2=jj*NS(ii);
            IND3=1+(ll+(jj-1))*NS(ii);
            IND4=(ll+jj)*NS(ii);
            
            %******************************
            %Assign the Floquet Hamiltonian
            %******************************
            if IND3>0 && IND4<=NBS(ii)
                if kk==1 
                    HF{ii}(IND1:IND2,IND3:IND4)=H{ii,kk}+PN*PE*EYE{ii};
                else
                    HF{ii}(IND1:IND2,IND3:IND4)=H{ii,kk};
                end
            end
        end
    end
end
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

end