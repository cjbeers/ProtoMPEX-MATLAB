%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function takes an input z on Proto measured from the dump end down
% the machine and outputs the locations of the coils which z is between.
% This implicitly gives us the coil numbers as well. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [coil1,coil2] = Spool_Finder(z)% z is a 1x5 array of Fiber locations
End1 = 0; %Dump End
Coil1 = 0.98815; % Center of Coil 1
Coil2 = 1.2982; % Center of Coil 2
Coil3 = 1.6281; % Center of Coil 3
Coil4 = 1.8641; % Center of Coil 4
Coil5 = 2.1902; % Center of Coil 5
Coil6 = 2.3881; % Center of Coil 6
Coil7 = 2.9442; % Center of Coil 7
Coil8 = 3.1092; % Center of Coil 8
Coil9 = 3.3887; % Center of Coil 9
Coil10 = 3.5918; % Center of Coil 10
Coil11 = 3.7824; % Center of Coil 11
Coil12 =3.9729; % Center of Coil 12
Coil13=4.2903; % Center of Coil 13
End2 = 4.420; %Target End
for ii=1:5
if z(:,ii,:)==0
    coil1(:,ii,:)=0;
    coil2(:,ii,:)=0;
elseif z(:,ii,:)< End1 | z(:,ii,:)>End2
    disp('ERROR! Requested "z" outside of MPEX Parameters.');
elseif z(:,ii,:)<Coil1 & z(:,ii,:)>End1
    coil1(:,ii,:)=End1;
    coil2(:,ii,:)=Coil1;
elseif z(:,ii,:)<Coil2 & z(:,ii,:)>Coil1
    coil1(:,ii,:)=Coil1;
    coil2(:,ii,:)=Coil2;
elseif z(:,ii,:)<Coil3 & z(:,ii,:)>Coil2
    coil1(:,ii,:)=Coil2;
    coil2(:,ii,:)=Coil3;
elseif z(:,ii,:)<Coil4 & z(:,ii,:)>Coil3
    coil1(:,ii,:)=Coil3;
    coil2(:,ii,:)=Coil4;
elseif z(:,ii,:)<Coil5 & z(:,ii,:)>Coil4
    coil1(:,ii,:)=Coil4;
    coil2(:,ii,:)=Coil5;
elseif z(:,ii,:)<Coil6 & z(:,ii,:)>Coil5
    coil1(:,ii,:)=Coil5;
    coil2(:,ii,:)=Coil6;
elseif z(:,ii,:)<Coil7 & z(:,ii,:)>Coil6
    coil1(:,ii,:)=Coil6;
    coil2(:,ii,:)=Coil7;
elseif z(:,ii,:)<Coil8 & z(:,ii,:)>Coil7
    coil1(:,ii,:)=Coil7;
    coil2(:,ii,:)=Coil8;
elseif z(:,ii,:)<Coil9 & z(:,ii,:)>Coil8
    coil1(:,ii,:)=Coil8;
    coil2(:,ii,:)=Coil9;
elseif z(:,ii,:)<Coil10 & z(:,ii,:)>Coil9
    coil1(:,ii,:)=Coil9;
    coil2(:,ii,:)=Coil10;
elseif z(:,ii,:)<Coil11 & z(:,ii,:)>Coil10
    coil1(:,ii,:)=Coil10;
    coil2(:,ii,:)=Coil11;
elseif z(:,ii,:)<Coil12 & z(:,ii,:)>Coil11
    coil1(:,ii,:)=Coil11;
    coil2(:,ii,:)=Coil12;
elseif z(:,ii,:)<End2 & z(:,ii,:)>Coil12
    coil1(:,ii,:)=Coil12;
    coil2(:,ii,:)=Coil13;
elseif z(:,ii,:)<End2 & z(:,ii,:)>Coil13
    coil1(:,ii,:)=Coil13;
    coil2(:,ii,:)=End2;
else z(:,ii,:)>Coil13
    coil1=Coil13;
    coil2=Coil13;
end
end
end

    