function START_PARPOOL(NAP)

if NAP>1
    %*************************
    %Assign the matlab version
    %*************************
    MATLAB=version;
    
    if str2double(MATLAB(1))<8
        %****************************
        %Assign the number of workers
        %****************************
        NOP=matlabpool('size');
        
        %************************************
        %Open the requested number of workers
        %************************************
        if NAP~=NOP
            if (NOP==0)
                matlabpool('open',NAP);
            else
                matlabpool('close');
                matlabpool('open',NAP);
            end
        end
    else
        %********************
        %Open current session
        %********************
        POOL=gcp('nocreate');
        
        %****************************
        %Assign the number of workers
        %****************************
        if isempty(POOL)==1
            NOP=0;
        else
            NOP=POOL.NumWorkers;
        end
        
        %************************************
        %Open the requested number of workers
        %************************************
        if (NAP~=NOP)
            if (NOP==0)
                parpool(NAP);
            else
                delete(POOL);
                parpool(NAP);
            end
        end 
    end   
end

end