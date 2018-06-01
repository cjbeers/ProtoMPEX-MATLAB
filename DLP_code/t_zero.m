function [t] = t_zero(Shot)
% T_ZERO provides the "t_zero" information stored in the MDS+ tree of
% ProtoMPEX from a given shot
% t{s}(10:14) returns the time in Hour:Min when the shot was stored.

% Created Aug 30th 2016 by Juan F Caneses

t = my_mdsvalue_v3(Shot,['\MPEX::TOP:T_ZERO']);

end

