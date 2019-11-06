Shots = [27579];
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
RA = [Stem,Branch];

%Data to save
Data{1} = [RA,'RF_FWD_PWR'];
Data{2} = [RA,'mfc_flow_d2'];
Data{3} = [RA,'mfc_flow_He'];
Data{4} = [RA, 'pg4'];
Data{5} = [Stem, 'ANALYZED:DLP:KTE'];
Data{6} = [Stem, 'ANALYZED:DLP:NE'];
Data{7} = [Stem, 'ANALYZED:DLP:time'];
Data{10} = [Stem,'SHOT_NOTE'];
Data{11} = [Stem,'T_ZERO'];

for s = 1:length(Shots)
    %Data
    Shot=Shots(s);
    [Shot]=mdsopen( 'MPEX',Shot);
    [NOTE]= mdsvalue(Data{10});
    [Hel]  = mdsvalue(Data{1})*85; %Calibrated now as of 8/29/19
    [Puffer1]  = mdsvalue(Data{2}); %V
    [Puffer2]  = mdsvalue(Data{3}); %V
    [PG4]  = mdsvalue(Data{4}); 
    [PG4]=PG4.*2; %mTorr
    [kTe]  = mdsvalue(Data{5}); %eV
    [Ne]  = mdsvalue(Data{6}); %1/m3
    [T_ZERO]=mdsvalue(Data{11});
    
    %Time points with Data (s)
    [t_Hel]  = mdsvalue(['DIM_OF(',Data{1},')']); 
    [t_Puffer1]  = mdsvalue(['DIM_OF(',Data{2},')']);
    [t_Puffer2] = mdsvalue(['DIM_OF(',Data{3},')']);
    [t_PG4] = mdsvalue(['DIM_OF(',Data{4},')']);
    [t_DLP]  = mdsvalue(Data{7}); %eV
    
    filename=strcat('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2019_08_19\',mat2str(Shots(s)),'.mat');
    save(filename);
end

mdsclose;
mdsdisconnect;

