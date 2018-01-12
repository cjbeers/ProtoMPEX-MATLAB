function Start_Parpool(NAP)

if (NAP>1)
    %*************************
    %Assign the matlab version
    %*************************
    MATLAB=version;
    
    if (str2double(MATLAB(1))<8)
        %****************************
        %Assign the number of workers
        %****************************
        NOP=parpool('size');
        
        %************************************
        %Open the requested number of workers
        %************************************
        if (NAP~=NOP)
            if (NOP==0)
                parpool('open',NAP);
            else
                parpool('close');
                parpool('open',NAP);
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
                parpool(2);
            else
                delete(POOL);
                parpool(2);
            end
        end 
    end   
end

end