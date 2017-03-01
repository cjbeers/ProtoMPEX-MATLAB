ccc
bkg=dlmread('Z:\OceanOptics\OL 400-C Calib\bg_subtract_1s_noheader.txt','\t');
OL=dlmread('Z:\OceanOptics\OL 400-C Calib\OL400C_1s_noheader.txt','\t');
HL=dlmread('Z:\OceanOptics\OL 400-C Calib\HL2000_1s_noheader.txt','\t');

%Creates correct OL400-C counts
OLcor(:,1)=bkg(:,1);
temp=OL-bkg;
OLcor(:,2)=temp(:,2);

%Creates correct HL2000
HLcor(:,1)=bkg(:,1);
temp=HL-bkg;
HLcor(:,2)=temp(:,2);

%% Plots
%Plots counts vs. wavelength
figure(1)
plot(OLcor(:,1),OLcor(:,2))
ax.FontSize = 20;
title('OL Net Counts vs. Wavelength','FontSize',20);

figure(2)
plot(HLcor(:,1),HLcor(:,2))
ax.FontSize = 20;
title('HL Net Counts vs. Wavelength','FontSize',20);

