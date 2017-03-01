function DATA=QS_Assign(EVec,EVal,DATA,PARA)

%************
%Assign input
%************
NS=PARA.NS;
QN=PARA.QN;

%***************************************
%Assign the number of magnetic substates
%***************************************
STATE.NS=NS;

%*********************************************
%Assign the energies of the magnetic substates
%*********************************************
STATE.EL=EVal;

%****************
%Asign the output
%****************
DATA.STATE=STATE;

end