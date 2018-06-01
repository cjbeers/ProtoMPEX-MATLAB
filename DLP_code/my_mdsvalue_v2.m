function [x,t] = my_mdsvalue_v2(shot,address)
% MY_MDSVALUE_v2 performs the same function as the mdsvalue.m function
% provided in the MDSplus distribution however, our function provides both
% the signal and its time base all at once. 
% INPUTS:
% SHOT: cell with shot numbers to access with the address given in the
% ADDRESS string cell
% ADDRESS: string cell containing the complete address of the signal within
% the MPEX tree. for example \MPEX::TOP.MACHOPS1:LP_V_RAMP. It can be a
% cell of strings pointing to different signals

mdsconnect('mpexserver');

nShot = length(shot);
nAddress = length(address);

if 1%nShot~= nAddress
    if (nAddress == 1 & nShot == 1) % Only one Shot and one signal type
        % use address(n) to select the "d" element of the cell address
          [~,~]     = mdsopen('MPEX',shot);
          [x{1},~]  = mdsvalue(address);
          [t{1},~]  = mdsvalue(['DIM_OF(',cell2mat(address),')']);
          
    elseif  nAddress == 1 & nShot > 1 %  Muliple shots but one signal type
        for s = 1:nShot
              [~,~]     = mdsopen('MPEX',shot(s));
              [x{s},~]  = mdsvalue(address);
              [t{s},~]  = mdsvalue(['DIM_OF(',cell2mat(address),')']);
        end
    elseif  nAddress > 1 & nShot == 1 %  Single shot but multiple signal types
        for s = 1:nAddress
            if s == 1; [~,~] = mdsopen('MPEX',shot); end
              [x{s},~]  = mdsvalue(address{s});
              %[t{s},~]  = mdsvalue(['DIM_OF(',cell2mat(address{s}),')']);
              [t{s},~]  = mdsvalue(['DIM_OF(',cell2mat(address(s)),')']);
        end        
    elseif  nAddress > 1 & nShot > 1
        if nAddress ~= nShot
             error('Length of "shot" must be equal to length "address"')
        end
    end
end

end

