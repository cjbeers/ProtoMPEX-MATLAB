
Shots=11865;
mdsconnect('mpexserver');
Stem = '\MPEX::TOP.';
Stem = '\MPEX::TOP.';
Branch = 'MACHOPS1:';
RA = [Stem,Branch];
Data{4} = [Stem,'SHOT_NOTE'];
s=1;
[SHOT(s),~]=mdsopen( 'MPEX',Shots(s) ); % see 8636s
[NOTE{s},~]= mdsvalue(Data{4});
NOTE{1,1,1} %Gives notes for the shot
mdsclose;
mdsdisconnect;