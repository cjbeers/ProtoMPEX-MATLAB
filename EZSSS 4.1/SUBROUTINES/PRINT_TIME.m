function PRINT_TIME(TIME)

%***********
%Calc. units
%***********
UNIT='sec';
if (TIME>60)
    TIME=TIME/60;
    UNIT='min';
    if (TIME>60)
        TIME=TIME/60;
        UNIT='hrs';
    end
end

%**************
%Print run time
%**************
fprintf('\n||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n')
fprintf('||||||||||||||||||||||||||     RUN TIME: %5.2f %s     |||||||||||||||||||||||||\n',TIME,UNIT)
fprintf('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n\n')

end