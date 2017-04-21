function PRINT_PROGRESS_SER(ii,ND,NAME)

%***********
%Define text
%***********
TEXT=[NAME ' Calculation'];

%****************************
%Calc. length of boarder text
%****************************
NT=length(TEXT);
NB=31+NT;

%*******************
%Assign boarder text
%*******************
BOARDER(1:NB)='~';
FILL(1:NT)=' ';

%******************************
%Print QSA calculation progress
%******************************
if ii==1
    fprintf('\n            %s\n',BOARDER)
    fprintf('            ~~~~~~    %s %3i of %3i    ~~~~~~\n',TEXT,ii,ND)
else
    fprintf('            ~~~~~~    %s %3i of %3i    ~~~~~~\n',FILL,ii,ND)
end
if ii==ND
    fprintf('            %s\n',BOARDER)
end

end