function NS=NUM_STATES(n,s,l)

%**************************************************************************
%This function calculates the total number of states for a given principal
%quantum number
%**************************************************************************

NS(1:2)=0;
if isempty(l)==0
    %************************************************
    %Calc. number of states having an angular QM of l
    %************************************************
    for ii=1:2
        for kk=1:(abs(l(ii)+s)-abs(l(ii)-s)+1)
            j=abs(l(ii)-s)+(kk-1);
            for ll=1:2*j+1
                NS(ii)=NS(ii)+1;
            end
        end
    end  
elseif isempty(l)==1
    %**************************************************
    %Calc. number of states having an principal QM of n
    %**************************************************
    for ii=1:2
        for jj=1:n(ii)
            l=jj-1;
            for kk=1:(abs(l+s)-abs(l-s)+1)
                j=abs(l-s)+(kk-1);
                for ll=1:2*j+1
                    NS(ii)=NS(ii)+1;
                end
            end
        end
    end
end

end