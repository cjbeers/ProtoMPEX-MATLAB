function Print_Prog(IND,NP)

%**************************************************************************
%The Full_Print.m function prints the progress bar to the screen for the
%full space fitting algorithm.
%**************************************************************************
%*******************              INPUTS             **********************
%**************************************************************************
%IND - Scalar. Indice associated with progess - [1..NP].
%
%NP - Scalar. Character length of progress bar.
%**************************************************************************

if (IND==1)
    fprintf('\n')
    for ii=1:NP
        fprintf('*')
    end
    fprintf('\n')
else
    for ii=1:NP+2
        fprintf('\b')
    end
end
    
fprintf('-')

fprintf('\n')
    
for ii=1:NP
    fprintf('*')
end

fprintf('\n')

end