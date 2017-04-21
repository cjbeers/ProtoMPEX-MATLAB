%% Measured Ion Temperature Plot
%With and without ICH

ICH10=[4.8054
NOICH10=[
ICH9Bot=[
NOICH9Bot=[
ICH9Center=[
NOICH9Center=[
ICH9Top=[0.76979 1.6072 0.8456 0.89226 1.1789 10.022 11.873 
NOICH9top=[
ICH6=[7.3422 9.7332 7.5871 6.307 8.768];
NOICH6=[
R9=
Te9=[
ne9=[

figure;
hold on
errorbar(ICH6,ICHNe6,err, 'blacks', 'MarkerSize', 3)

ax = gca;
title('Proto-MPEX Measured T_i','FontSize',13);
xlabel('Distance from Dump Plate [m]','FontSize',13);
ylabel('T_i [eV]','FontSize',13);
xlim([0 3.5]);
ylim([0,10]);
hold off;    
Plot() 