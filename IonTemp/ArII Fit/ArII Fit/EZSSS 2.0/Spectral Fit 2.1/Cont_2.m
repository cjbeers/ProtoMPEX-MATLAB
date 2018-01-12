function DATA=Cont_2(IGB,IB,DATA,uu)

%*******************
%Assigning the input
%*******************
IG=DATA.GRID{uu}.IG;
IGT=DATA.GRID{uu}.IGT;
NG=DATA.GRID{uu}.NG;

if IB>0
    %******************************
    %Calc. the background intensity
    %******************************    
    IGB(1:NG)=IB*IGB(1:NG);

    %**************
    %Add background
    %************** 
    IGT(1:NG)=IG(1:NG)+IGB(1:NG);

    %***********
    %Normalize
    %*********** 
    IGT(1:NG)=IGT(1:NG)/max(IGT(1:NG));
else
    IGT(1:NG)=IG(1:NG);
end

%********************
%Assigning the output
%********************
DATA.GRID{uu}.IGT=IGT;

end