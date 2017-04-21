function PRINT_PROGRESS_PAR(NAME)
   
%***********
%Define text
%***********
TEXT=['Parallel ' NAME ' Calculation'];

%****************************
%Calc. length of boarder text
%****************************
NT=length(TEXT);
NB=21+NT;

%*******************
%Assign boarder text
%*******************
BOARDER(1:NB)='~';

%******************************
%Print QSA calculation progress
%******************************
fprintf('\n            %s\n',BOARDER)
fprintf('            ~~~~~~    %s     ~~~~~~\n',TEXT)
fprintf('            %s\n\n',BOARDER)

end