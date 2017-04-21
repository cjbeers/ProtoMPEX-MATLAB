function STATE=QS_ASSIGN(EVec,EVal,PARA,OPT)

%************
%Assign input
%************
QN=PARA.QN;
NS=PARA.NS;
NB=PARA.NB;
NBS=PARA.NBS;
ND=PARA.ND;

QUANTUM=OPT.QUANTUM;

%*******************
%Assign save options
%*******************
EL_LOG=QUANTUM.EL;
WF_LOG=QUANTUM.WF;

%***************************************
%Assign the number of magnetic substates
%***************************************
LL.NS=NS(1);
UL.NS=NS(2);

%***********************************
%Assign the number of Floquet blocks
%***********************************
LL.NB=NB(1);
UL.NB=NB(2);

%*********************************************
%Assign the energies of the magnetic substates
%*********************************************
if EL_LOG==1
    for ii=1:ND
        LL.EL(1:NS(1),ii)=EVal{1,ii}(1:NS(1));
        UL.EL(1:NS(2),ii)=EVal{2,ii}(1:NS(2));
    end
end

%***************************************************
%Assign the wave functions of the magnetic substates
%***************************************************
if WF_LOG==1
    LL.WF=cell(NS(1),ND);
    UL.WF=cell(NS(2),ND);
    for jj=1:ND
        for ii=1:NS(1)
            LL.WF{ii,jj}(1:NBS(1))=EVec{1,jj}(1:NBS(1),ii);
        end
        for ii=1:NS(2)
            UL.WF{ii,jj}(1:NBS(2))=EVec{2,jj}(1:NBS(2),ii);
        end
    end
end

%****************************************************
%Assign the quantum numbers of the magnetic substates
%****************************************************
if EL_LOG==1 || WF_LOG==1
    LL.QN=cell(NS(1),1);
    UL.QN=cell(NS(2),1);
    for ii=1:NS(1)
        LL.QN{ii}(1:5)=QN{1,ii}(1:5);
    end
    for ii=1:NS(2)
        UL.QN{ii}(1:5)=QN{2,ii}(1:5);
    end
end

%**************************
%Assign the STATE structure
%**************************
STATE.ND=ND;
STATE.LL=LL;
STATE.UL=UL;

end