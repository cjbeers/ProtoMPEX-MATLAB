%infile=('Z:IR_Camera\2016_07_01\shot 9240');
%%
clear all
clc
%Starting and ending shot number USER inputs
prompt = 'Starting Shot Number? ';
j = input(prompt);
prompt = 'Ending Shot Number? ';
k = input(prompt);


for i=j:k

SHOT = i;
[~,~]=mdsopen('MPEX',SHOT)
[Snote, ~] = mdsvalue('\MPEX::TOP.SHOT_NOTE');
[KTE,~]=mdsvalue('\MPEX::TOP.ANALYZED.DLP:KTE');
[NE,~]=mdsvalue('\MPEX::TOP.ANALYZED.DLP:NE');
[Time,~]=mdsvalue('DIM_OF(\MPEX::TOP.ANALYZED.DLP:KTE)');

%{
Ne(i,1)=i;
Ne(1,i)=NE;

Te(i,1)=i;
Te(i,1)=KTE;
%}
end