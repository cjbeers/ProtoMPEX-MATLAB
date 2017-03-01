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

% HL 2000 lamp wav and rad are the values from the calibrated light source!!!
lamp_wav = [300.,310.,320.,330.,340.,350.,360.,370.,380.,390.,400.,...
    420.,440.,460.,480.,500.,525.,550.,575.,600.,650.,700.,750.,800.,...
    850.,900.,950.,1000.,1050.]';
%spectral radiance in (mW/cm2-micron)  Note:  NOT (mW/cm2-sr-micron)
lamp_rad=[1.133E-3,2.9943E-3,1.5788E-3,2.2974E-3,3.3536E-3,3.3032E-3,...
    3.6701E-3,4.7932E-3,5.9676E-3,8.4063E-3,1.0012E-2,1.6006E-2,...
    2.4115E-2,3.4534E-2,4.828E-2,6.5426E-2,9.2719E-2,1.2801E-1,...
    1.7096E-1,2.2219E-1,3.4197E-1,4.8906E-1,7.09E-1,9.4987E-1,1.2389E0,...
    1.5841E0,1.975E0,2.5359E0,3.0529E0]';

% OL400-C int. sphere calibration curve
lamp_wav2=[350:10:1100];

%spectral radiance in (mW/(sr*cm2*nm))
lamp_red2= [0.0008679	0.001147	0.001443	0.001887	0.002376	0.002987	0.003691	0.004453	0.005254	0.006125	0.007071	0.008132	0.009196	0.01029	0.01143	0.01261	0.01381	0.01503	0.01628	0.01755	0.01886	0.02011	0.02135	0.02258	0.02388	0.02498	0.02627	0.02755	0.02871	0.02989	0.03103	0.03211	0.03313	0.03414	0.03512	0.03603	0.03687	0.03722	0.03842	0.03907	0.03995	0.04012	0.04061	0.04115	0.04162	0.04208	0.04246	0.0428	0.04304	0.04337	0.04369	0.04401	0.0443	0.04461	0.04487	0.04521	0.04551	0.04569	0.04577	0.04583	0.04605	0.0462	0.04631	0.04637	0.04643	0.04648	0.04649	0.04643	0.04621	0.04594	0.04579	0.04553	0.04521	0.04489	0.04468	0.04425];


%% Creates fitting for HL
calib_size = size(lamp_rad2);
S = spline(lamp_wav,lamp_rad2);
xx = 300:1:1050;
HLcoefs = S.coefs;

figure();
hold on;
plot(lamp_wav,lamp_rad,'o',xx,ppval(S,xx),'-');
%}

%Creates easy to read table of the calibration lamp values
lamptable=zeros(2,calib_size(1,1));
lamptable(1,:)=lamp_wav2;
lamptable(2,:)=lamp_rad2;


%% Calculation Loop
for i=1:3648

if HLcor(i,1) <= S.breaks(1,1)
    %disp('Error, HLcor(i,1) too low, try again.');
    c1=0; c2=0; c3=0; c4=0; xo=0;
elseif HLcor(i,1) <= S.breaks(1,2)
c1= S.coefs(1,4); c2=S.coefs(1,3); c3=S.coefs(1,2); c4=S.coefs(1,1); xo=S.breaks(1,1);
elseif HLcor(i,1) <= S.breaks(1,3)
c1= S.coefs(2,4); c2=S.coefs(2,3); c3=S.coefs(2,2); c4=S.coefs(2,1); xo=S.breaks(1,2);
elseif HLcor(i,1) <= S.breaks(1,4)
c1= S.coefs(3,4); c2=S.coefs(3,3); c3=S.coefs(3,2); c4=S.coefs(3,1); xo=S.breaks(1,3);
elseif HLcor(i,1) <= S.breaks(1,5)
c1= S.coefs(4,4); c2=S.coefs(4,3); c3=S.coefs(4,2); c4=S.coefs(4,1); xo=S.breaks(1,4);
elseif HLcor(i,1) <= S.breaks(1,6)
c1= S.coefs(5,4); c2=S.coefs(5,3); c3=S.coefs(5,2); c4=S.coefs(5,1); xo=S.breaks(1,5);
elseif HLcor(i,1) <= S.breaks(1,7)
c1= S.coefs(6,4); c2=S.coefs(6,3); c3=S.coefs(6,2); c4=S.coefs(6,1); xo=S.breaks(1,6);
elseif HLcor(i,1) <= S.breaks(1,8)
c1= S.coefs(7,4); c2=S.coefs(7,3); c3=S.coefs(7,2); c4=S.coefs(7,1); xo=S.breaks(1,7);
elseif HLcor(i,1) <= S.breaks(1,9)
c1= S.coefs(8,4); c2=S.coefs(8,3); c3=S.coefs(8,2); c4=S.coefs(8,1); xo=S.breaks(1,8);
elseif HLcor(i,1) <= S.breaks(1,10)
c1= S.coefs(9,4); c2=S.coefs(9,3); c3=S.coefs(9,2); c4=S.coefs(9,1); xo=S.breaks(1,9);
elseif HLcor(i,1) <= S.breaks(1,11)
c1= S.coefs(10,4); c2=S.coefs(10,3); c3=S.coefs(10,2); c4=S.coefs(10,1); xo=S.breaks(1,10);
elseif HLcor(i,1) <= S.breaks(1,12)
c1= S.coefs(11,4); c2=S.coefs(11,3); c3=S.coefs(11,2); c4=S.coefs(11,1); xo=S.breaks(1,11);
elseif HLcor(i,1) <= S.breaks(1,13)
c1= S.coefs(12,4); c2=S.coefs(12,3); c3=S.coefs(12,2); c4=S.coefs(12,1); xo=S.breaks(1,12);
elseif HLcor(i,1) <= S.breaks(1,14)
c1= S.coefs(13,4); c2=S.coefs(13,3); c3=S.coefs(13,2); c4=S.coefs(13,1); xo=S.breaks(1,13);
elseif HLcor(i,1) <= S.breaks(1,15)
c1= S.coefs(14,4); c2=S.coefs(14,3); c3=S.coefs(14,2); c4=S.coefs(14,1); xo=S.breaks(1,14);
elseif HLcor(i,1) <= S.breaks(1,16)
c1= S.coefs(15,4); c2=S.coefs(15,3); c3=S.coefs(15,2); c4=S.coefs(15,1); xo=S.breaks(1,15);
elseif HLcor(i,1) <= S.breaks(1,17)
c1= S.coefs(16,4); c2=S.coefs(16,3); c3=S.coefs(16,2); c4=S.coefs(16,1); xo=S.breaks(1,16);
elseif HLcor(i,1) <= S.breaks(1,18)
c1= S.coefs(17,4); c2=S.coefs(17,3); c3=S.coefs(17,2); c4=S.coefs(17,1); xo=S.breaks(1,17);
elseif HLcor(i,1) <= S.breaks(1,19)
c1= S.coefs(18,4); c2=S.coefs(18,3); c3=S.coefs(18,2); c4=S.coefs(18,1); xo=S.breaks(1,18);
elseif HLcor(i,1) <= S.breaks(1,20)
c1= S.coefs(19,4); c2=S.coefs(19,3); c3=S.coefs(19,2); c4=S.coefs(19,1); xo=S.breaks(1,19);
elseif HLcor(i,1) <= S.breaks(1,21)
c1= S.coefs(20,4); c2=S.coefs(20,3); c3=S.coefs(20,2); c4=S.coefs(20,1); xo=S.breaks(1,20);
elseif HLcor(i,1) <= S.breaks(1,22)
c1= S.coefs(21,4); c2=S.coefs(21,3); c3=S.coefs(21,2); c4=S.coefs(21,1); xo=S.breaks(1,21);
elseif HLcor(i,1) <= S.breaks(1,23)
c1= S.coefs(22,4); c2=S.coefs(22,3); c3=S.coefs(22,2); c4=S.coefs(22,1); xo=S.breaks(1,22);
elseif HLcor(i,1) <= S.breaks(1,24)
c1= S.coefs(23,4); c2=S.coefs(23,3); c3=S.coefs(23,2); c4=S.coefs(23,1); xo=S.breaks(1,23);
elseif HLcor(i,1) <= S.breaks(1,25)
c1= S.coefs(24,4); c2=S.coefs(24,3); c3=S.coefs(24,2); c4=S.coefs(24,1); xo=S.breaks(1,24);
elseif HLcor(i,1) <= S.breaks(1,26)
c1= S.coefs(25,4); c2=S.coefs(25,3); c3=S.coefs(25,2); c4=S.coefs(25,1); xo=S.breaks(1,25);
elseif HLcor(i,1) <= S.breaks(1,27)
c1= S.coefs(26,4); c2=S.coefs(26,3); c3=S.coefs(26,2); c4=S.coefs(26,1); xo=S.breaks(1,26);
elseif HLcor(i,1) <= S.breaks(1,28)
c1= S.coefs(27,4); c2=S.coefs(27,3); c3=S.coefs(27,2); c4=S.coefs(27,1); xo=S.breaks(1,27);
elseif HLcor(i,1) <= S.breaks(1,29)
c1= S.coefs(28,4); c2=S.coefs(28,3); c3=S.coefs(28,2); c4=S.coefs(28,1); xo=S.breaks(1,28);
else HLcor(i,1) >= S.breaks(1,29)
    %disp('Error, HLcor(i,1) too high, try again.');
    c1=0; c2=0; c3=0; c4=0; xo=0;
    clc
end

OLcor(i,3)= (c1+c2*(HLcor(i,1)-xo).^1+c3*(HLcor(i,1)-xo).^2+c4*(HLcor(i,1)-xo).^3)*(OLcor(i,2)/HLcor(i,2));

end

%% Fitting 

%OLFit= -1E-15*(correctedtable(2,j))^6 + 6E-12*(correctedtable(2,j))^5 - 9E-09*(correctedtable(2,j))^4 + 8E-06*(correctedtable(2,j))^3 - 0.0033*(correctedtable(2,j))^2 + 0.7429*(correctedtable(2,j)) - 65.58;

%% Plots
figure()
plot(OLcor(:,1),OLcor(:,3))
ax = gca;
ax.FontSize = 15;
title('OL Intensity vs. Wavelength','FontSize',15);
xlabel('Wavelength','FontSize',15);
ylabel('OL Intensity','FontSize',15);
ylim([0,inf]);

%Plots counts vs. wavelength
%{
figure()
plot(OLcor(:,1),OLcor(:,2))
ax = gca;
ax.FontSize = 15;
title('OL Counts vs. Wavelength','FontSize',15);
xlabel('Wavelength','FontSize',15);
ylabel('OL Net Counts','FontSize',15);
ylim([0,inf]);


figure()
plot(HLcor(:,1),HLcor(:,2))
ax = gca;
ax.FontSize = 15;
title('HL Counts vs. Wavelength','FontSize',15);
xlabel('Wavelength','FontSize',15);
ylabel('HL Net Counts','FontSize',15);
ylim([0,inf]);

%}

