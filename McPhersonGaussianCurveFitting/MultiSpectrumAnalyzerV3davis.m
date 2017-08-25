
cleanup
format shortG;
format compact;
tic

PLOTPIXELS=0;
PLOTWAVELENGTH=1;
PLOTINTENSITY=1;
USEIPEAKS=0;
USEIPEAKSFORINTENSITYPEAKS=0;
FINDFWHM=0;
FINDFLOW=0;
FINDIONTEMP=0;
IONTEMPSINGLEFRAME=0;
VOLUMECALC=0;
POWERLOSS=1;

Fiber1_5North = 58.9279/100+0.5; %[cm to m]
Fiber1_5Top = 58.9279/100+0.5;
Fiber2_5North = 92.9258/100+0.5;
Fiber2_5Top = 92.9258/100+0.5;
Fiber4_5Bottom = 139.1259/100+0.5;
Fiber5_5North = 170.9183/100+0.5;
Fiber6_5North = 198.1936/100+0.5;
Fiber6_5South = 210.4186/100+0.5;
Fiber7_5North = 250.2509/100+0.5;
Fiber9_5South = 298.9854/100+0.5;
Fiber9_5North = 298.9854/100+0.5;
Fiber10_5South = 330.698/100+0.5;
Fiber11_5North = 362.43/100+0.5;

Fibers= [Fiber2_5North Fiber2_5North Fiber2_5North Fiber2_5North Fiber2_5North];%Enter all fiber locations for Fibers 1-5 left to right (0 indicates Fiber not in use)

B_Field = [160 4000 4000 600]; %In order: helicon current, current_A, current_B, current_C in Amps

Spectra.Grating = 1800;
Spectra.Wavelength = 7291;
[Spectra.RawDATA, Spectra.ExposureTime] = readSPE('Z:\McPherson\2016_08_19\D2He_20um_7291_10021.SPE');
Spectra.Length = size(Spectra.RawDATA);
Spectra.RawBGDATA = readSPE('Z:\McPherson\calibration\cal_2016_08_04\ROIs\abs_calib_20um_1s_bg_1.SPE');

if length(Spectra.Length) == 2
    Spectra.Length(1,3)=1;
end

if Spectra.Length(1,3) == 1
    Spectra.FrameOfInterest = 1;
elseif Spectra.Length(1,3) == 13
    Spectra.FrameOfInterest = 8;
elseif Spectra.Length(1,3) == 37
    Spectra.FrameOfInterest = 14;
elseif Spectra.Length(1,3) == 50
    Spectra.FrameOfInterest = 28;
else
    disp('Spectra frames used are weird fix FrameOfInterest');
end

if Spectra.Grating == 300
    Spectra.Lambda0 = (Spectra.Wavelength*.4);
elseif Spectra.Grating == 1800
    %Spectra.Lambda0 = 480.6;
    %Spectra.Lambda0 = 410.2; %D deta
    %Spectra.Lambda0 = 434.1; %D gamma
    Spectra.Lambda0 = 486.14; %D beta
    %Spectra.Lambda0 = Spectra.Wavelength/15;
end

if Spectra.Grating == 300
    Spectra.P0 = 261;
elseif Spectra.Grating == 1800
    Spectra.P0 = 182;
    %Spectra.P0 = 261; %McPherson has been centered
end

Spectra.RawFiber1 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));
Spectra.RawFiber2 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));
Spectra.RawFiber3 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));
Spectra.RawFiber4 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));
Spectra.RawFiber5 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));

Spectra.RawFiberBG1 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));
Spectra.RawFiberBG2 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));
Spectra.RawFiberBG3 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));
Spectra.RawFiberBG4 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));
Spectra.RawFiberBG5 = zeros(Spectra.Length(:,3), Spectra.Length(:,2));

for ii = 1:Spectra.Length(:,3)
    Spectra.RawFiber1(ii,:) = double(Spectra.RawDATA(1,:,ii));
    Spectra.RawFiber2(ii,:) = double(Spectra.RawDATA(2,:,ii));
    Spectra.RawFiber3(ii,:) = double(Spectra.RawDATA(3,:,ii));
    Spectra.RawFiber4(ii,:) = double(Spectra.RawDATA(4,:,ii));
    Spectra.RawFiber5(ii,:) = double(Spectra.RawDATA(5,:,ii));
    
    Spectra.RawFiberBG1(1,:) = double(Spectra.RawBGDATA(1,:));
    Spectra.RawFiberBG2(2,:) = double(Spectra.RawBGDATA(2,:));
    Spectra.RawFiberBG3(3,:) = double(Spectra.RawBGDATA(3,:));
    Spectra.RawFiberBG4(4,:) = double(Spectra.RawBGDATA(4,:));
    Spectra.RawFiberBG5(5,:) = double(Spectra.RawBGDATA(5,:));
    
    Spectra.BGSub1 = Spectra.RawFiber1-Spectra.RawFiberBG1;
    Spectra.BGSub2 = Spectra.RawFiber2-Spectra.RawFiberBG2;
    Spectra.BGSub3 = Spectra.RawFiber3-Spectra.RawFiberBG3;
    Spectra.BGSub4 = Spectra.RawFiber4-Spectra.RawFiberBG4;
    Spectra.BGSub5 = Spectra.RawFiber5-Spectra.RawFiberBG5;
    
    Spectra.SelfBG1(ii,1) = abs(mean2(Spectra.RawFiber1(ii,1:30)));
    Spectra.SelfBG2(ii,1) = abs(mean2(Spectra.RawFiber2(ii,1:30)));
    Spectra.SelfBG3(ii,1) = abs(mean2(Spectra.RawFiber3(ii,1:30)));
    Spectra.SelfBG4(ii,1) = abs(mean2(Spectra.RawFiber4(ii,1:30)));
    Spectra.SelfBG5(ii,1) = abs(mean2(Spectra.RawFiber5(ii,1:30)));
    
    Spectra.SelfBGSub1(ii,:) = Spectra.RawFiber1(ii,:)-Spectra.SelfBG1(ii,1);
    Spectra.SelfBGSub2(ii,:) = Spectra.RawFiber2(ii,:)-Spectra.SelfBG2(ii,1);
    Spectra.SelfBGSub3(ii,:) = Spectra.RawFiber3(ii,:)-Spectra.SelfBG3(ii,1);
    Spectra.SelfBGSub4(ii,:) = Spectra.RawFiber4(ii,:)-Spectra.SelfBG4(ii,1);
    Spectra.SelfBGSub5(ii,:) = Spectra.RawFiber5(ii,:)-Spectra.SelfBG5(ii,1);
end

Spectra.Pixels = (1:512);

if PLOTPIXELS==1
    
figure;
plot(Spectra.Pixels,(Spectra.SelfBGSub1(Spectra.FrameOfInterest,:)));
hold on;
plot(Spectra.Pixels,(Spectra.SelfBGSub2(Spectra.FrameOfInterest,:)));
plot(Spectra.Pixels,(Spectra.SelfBGSub3(Spectra.FrameOfInterest,:)));
plot(Spectra.Pixels,(Spectra.SelfBGSub4(Spectra.FrameOfInterest,:)));
plot(Spectra.Pixels,(Spectra.SelfBGSub5(Spectra.FrameOfInterest,:)));
ax = gca;
ax.FontSize = 13;
title('Counts vs Corrected Pixels', 'FontSize', 13);
xlabel('Pixel', 'FontSize', 13);
ylabel('Counts', 'FontSize', 13);
xlim([0 512]);
ylim([0 inf]);
hold off;
end

Spectra.PixelsC(1:Spectra.P0,:) = (Spectra.P0-1:-1:0)';
Spectra.PixelsC(Spectra.P0+1:Spectra.Length(1,2),:) = (1:1:(Spectra.Length(1,2)-Spectra.P0))';

for ii = 1:512
    if Spectra.Grating == 300
        Spectra.Disper = -0.055;
    elseif Spectra.Grating == 1800
        Spectra.Disper = -(0.09354-3.8264E-6*Spectra.Lambda0*10+8.7181E-11*(Spectra.Lambda0*10)^2-1.0366E-14*(Spectra.Lambda0*10)^3-2.5001E-18*(Spectra.Lambda0*10)^4)/10;
    end
    Spectra.PixCDisp(ii,1) = Spectra.PixelsC(ii,1)*Spectra.Disper;
end

Spectra.Lambda(1:Spectra.P0,:) = Spectra.Lambda0 - Spectra.PixCDisp(1:Spectra.P0,:);
Spectra.Lambda(Spectra.P0+1:Spectra.Length(1,2),:) = rot90(Spectra.Lambda0 + Spectra.PixCDisp(Spectra.P0+1:Spectra.Length(1,2),:));
Spectra.LambdaPlot = (rot90(Spectra.Lambda));
Spectra.LambdaMin = Spectra.LambdaPlot(1,512);
Spectra.LambdaMax = Spectra.LambdaPlot(1,1);
Spectra.PixelSize = Spectra.LambdaPlot(1,1)-Spectra.LambdaPlot(1,2);

if USEIPEAKS==1

x = Spectra.LambdaPlot;
y = flip(Spectra.BGSub3(Spectra.FrameOfInterest,:));
SlopeThreshold = 0.001;
smoothwidth = 9;
peakgroup = 6;
smoothtype = 1;
AmpThreshold = 1000;
CountsPeak = findpeaksL(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype);
if CountsPeak(1,2) == 0
    disp('Error in AmpThreshold for Counts');
end
sizeP = size(CountsPeak);

for ii = 1:512
    for j = 1:sizeP(1,1)
        if CountsPeak(j,2) == correctedtable(2,ii)
            Words = ['Peak#= ',num2str(j), ' CorrectedPixel#=', num2str(correctedtable(1,ii)), ' Wavelength=', num2str(correctedtable(2,ii)), ' Counts=', num2str(correctedtable(3,ii)),];
            disp(Words);
        end
    end
end

PeakD = (0.3/18);
AmpT = 2000;
SlopeT = 0.001;
SmoothW = 9;
FitW = 10;
DataMatrix = [x;y];
end

if PLOTWAVELENGTH==1
    
figure;
plot(Spectra.LambdaPlot,Spectra.SelfBGSub1(Spectra.FrameOfInterest,:));
hold on;
plot(Spectra.LambdaPlot,Spectra.SelfBGSub2(Spectra.FrameOfInterest,:));
plot(Spectra.LambdaPlot,Spectra.SelfBGSub3(Spectra.FrameOfInterest,:));
plot(Spectra.LambdaPlot,Spectra.SelfBGSub4(Spectra.FrameOfInterest,:));
plot(Spectra.LambdaPlot,Spectra.SelfBGSub5(Spectra.FrameOfInterest,:));
ax = gca;
ax.FontSize = 13;
title('Counts vs Wavelength','FontSize',13);
xlabel('Wavelength [nm]','FontSize',13);
ylabel('Counts','FontSize',13);
xlim([Spectra.LambdaMin Spectra.LambdaMax]);
ylim([0 inf]);
hold off;
end

%INTENSITY CALCS%
if Spectra.Grating == 300
for ii = 1:512
  WL = Spectra.LambdaPlot(1,ii);
  Spectra.F1CF(1,ii) =(1101630822525047*WL^6)/649037107316853453566312041152512 - (7265777621430527*WL^5)/1267650600228229401496703205376 + (4967798444037317*WL^4)/618970019642690137449562112 - (7213530429423309*WL^3)/1208925819614629174706176 + (5868229780194579*WL^2)/2361183241434822606848 - (5074883106023453*WL)/9223372036854775808 + 7297156861788209/144115188075855872;
  Spectra.Intensity1(1,ii)=((Spectra.F1CF(1,ii)*flip(Spectra.BGSub1(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2/(pi*sind(2)^2);
  Spectra.F2CF(1,ii) =(2626695280632411*WL^6)/1298074214633706907132624082305024 - (1076220889837839*WL^5)/158456325028528675187087900672 + (5845266505055671*WL^4)/618970019642690137449562112 - (8418572225483743*WL^3)/1208925819614629174706176 + (3392225726576867*WL^2)/1180591620717411303424 - (5804480930144169*WL)/9223372036854775808 + 4122263530836521/72057594037927936;
  Spectra.Intensity2(1,ii)=((Spectra.F2CF(1,ii)*flip(Spectra.BGSub2(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2/(pi*sind(2)^2);
  Spectra.F3CF(1,ii) =(6685689374474273*WL^6)/5192296858534827628530496329220096 - (5538637756507167*WL^5)/1267650600228229401496703205376 + (3809644293763157*WL^4)/618970019642690137449562112 - (2786038952453225*WL^3)/604462909807314587353088 + (4572309193917549*WL^2)/2361183241434822606848 - (3994730768181719*WL)/9223372036854775808 + 5813337095729975/144115188075855872;
  Spectra.Intensity3(1,ii)=((Spectra.F3CF(1,ii)*flip(Spectra.BGSub3(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2/(pi*sind(2)^2);
  Spectra.F4CF(1,ii) =(7302221534579973*WL^6)/5192296858534827628530496329220096 - (1512047247641153*WL^5)/316912650057057350374175801344 + (519560686567997*WL^4)/77371252455336267181195264 - (6069351690507449*WL^3)/1208925819614629174706176 + (4967682192603545*WL^2)/2361183241434822606848 - (4324620186983531*WL)/9223372036854775808 + 6262978433970463/144115188075855872;
  Spectra.Intensity4(1,ii)=((Spectra.F4CF(1,ii)*flip(Spectra.BGSub4(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2/(pi*sind(2)^2);
  Spectra.F5CF(1,ii) =-(3056574429229055*WL^6)/2596148429267413814265248164610048 + (5619162961737097*WL^5)/1267650600228229401496703205376 - (4231508340035941*WL^4)/618970019642690137449562112 + (3345429297905545*WL^3)/604462909807314587353088 - (5859150790520435*WL^2)/2361183241434822606848 + (5387567721134835*WL)/9223372036854775808 - 8114035101143863/144115188075855872;
  Spectra.Intensity5(1,ii)=((Spectra.F5CF(1,ii)*flip(Spectra.BGSub5(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2/(pi*sind(2)^2);
end
elseif Spectra.Grating == 1800
for ii = 1:512
    WL=Spectra.LambdaPlot(1,ii);
    Spectra.F1CF(1,ii) = (8639858633378925*WL^6)/162259276829213363391578010288128 - (6752534369187517*WL^5)/39614081257132168796771975168 + (4371564017049417*WL^4)/19342813113834066795298816 - (1500140754751339*WL^3)/9444732965739290427392 + (1151024590460689*WL^2)/18446744073709551616 - (1872109269432241*WL)/144115188075855872 + 5042492432869085/4503599627370496;
    Spectra.Intensity1(1,ii)=(((Spectra.F1CF(1,ii)*flip(Spectra.SelfBGSub1(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2)/(.25*sind(2)^2);
    Spectra.F2CF(1,ii) =(633581297858053*WL^6)/5070602400912917605986812821504 - (8121773701465285*WL^5)/19807040628566084398385987584 + (2690009207465985*WL^4)/4835703278458516698824704 - (7542774615408457*WL^3)/18889465931478580854784 + (2950856088803465*WL^2)/18446744073709551616 - (4887277633992995*WL)/144115188075855872 + 6693695750256497/2251799813685248;
    Spectra.Intensity2(1,ii)=(((Spectra.F2CF(1,ii)*flip(Spectra.SelfBGSub2(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2)/(.25*sind(2)^2);
    Spectra.F3CF(1,ii) =(4558147662457993*WL^6)/40564819207303340847894502572032 - (911820085030147*WL^5)/2475880078570760549798248448 + (2413104084810979*WL^4)/4835703278458516698824704 - (6758446563225483*WL^3)/18889465931478580854784 + (5282100525926083*WL^2)/36893488147419103232 - (2184730141835485*WL)/72057594037927936 + 5978301140921691/2251799813685248;
    Spectra.Intensity3(1,ii)=(((Spectra.F3CF(1,ii)*flip(Spectra.SelfBGSub3(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2)/(.25*sind(2)^2);
    Spectra.F4CF(1,ii) =(2612623629397875*WL^6)/20282409603651670423947251286016 - (8357945244197111*WL^5)/19807040628566084398385987584 + (172707543343351*WL^4)/302231454903657293676544 - (1933629052041071*WL^3)/4722366482869645213696 + (6040887448379897*WL^2)/36893488147419103232 - (1248386249030235*WL)/36028797018963968 + 6826993165843605/2251799813685248;
    Spectra.Intensity4(1,ii)=(((Spectra.F4CF(1,ii)*flip(Spectra.SelfBGSub4(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2)/(.25*sind(2)^2);
    Spectra.F5CF(1,ii) =(1217788750296653*WL^6)/10141204801825835211973625643008 - (7799579479577659*WL^5)/19807040628566084398385987584 + (1290709320930039*WL^4)/2417851639229258349412352 - (7233120040344691*WL^3)/18889465931478580854784 + (5655494708893753*WL^2)/36893488147419103232 - (4680239615105187*WL)/144115188075855872 + 6406011523163739/2251799813685248;
    Spectra.Intensity5(1,ii)=(((Spectra.F5CF(1,ii)*flip(Spectra.SelfBGSub5(Spectra.FrameOfInterest,ii)))/(Spectra.ExposureTime*1000))*100^2)/(.25*sind(2)^2);
end
elseif Spectra.Grating ~= 300 && Spectra.Grating ~= 1800
    disp('Error in Grating Chosen')
end

clear WL
%END INTENSITY CALCS%

if PLOTINTENSITY==1

figure;
plot(Spectra.LambdaPlot,(Spectra.Intensity1))
hold on
plot(Spectra.LambdaPlot,(Spectra.Intensity2))
plot(Spectra.LambdaPlot,(Spectra.Intensity3))
plot(Spectra.LambdaPlot,(Spectra.Intensity4))
plot(Spectra.LambdaPlot,(Spectra.Intensity5))
ax = gca;
ax.FontSize = 15;
title('Intensity vs wavelength [nm]','FontSize',15);
xlabel('Wavelength [nm]','FontSize',15);
ylabel('Intensity [mW/m^2]','FontSize',15);
xlim([Spectra.LambdaMin Spectra.LambdaMax])
ylim([0 inf]);
hold off
end

if USEIPEAKSFORINTENSITYPEAKS==1

x=Spectra.LambdaPlot;
y=(Spectra.Intensity3); %USER changes to which fiber is observed. 
SlopeThreshold=0.0001;
smoothwidth=1.5;
peakgroup=10;
smoothtype=10;
AmpThreshold=50; %USER changes this if want to see more or less peaks depending on spectrum
IntensityPeak = findpeaksL(x,y,SlopeThreshold,AmpThreshold,smoothwidth,peakgroup,smoothtype);
if IntensityPeak(1,2)==0
    disp('Error in AmpThreshold for Intensity')
end
end

if FINDFWHM == 1

Gaussian.FWHMarray = zeros(Spectra.Length(1,1),1,Spectra.Length(1,3));
Gaussian.Residuals = zeros(Spectra.Length(1,1),1,Spectra.Length(1,3));
Gaussian.GaussCenter = zeros(Spectra.Length(1,1),1,Spectra.Length(1,3));

DATA.X = flip(Spectra.LambdaPlot);

for aa = 1:Spectra.Length(1,3)
for bb = 5:5 %1:Spectra.Length(1,1)

DATA.I = Spectra.RawDATA(bb,:,aa);

try %#ok<TRYNC>
[Gaussian.FWHMcurrent,Gaussian.residuals,Gaussian.Center] = ElijahGaussianFit(DATA,Spectra.Lambda0, Spectra.LambdaPlot);
if FWHMcurrent{1} >= 6
    FWHMcurrent{1} = 0;
    CenterOfInterest = 470.23;
    Center = CenterOfInterst;
end
end
Gaussian.FWHMarray(bb,1,aa)=Gaussian.FWHMcurrent{1};
format longg
Gaussian.Residuals(bb,1,aa) = mean(Gaussian.residuals);
Gaussian.GaussCenter(bb,1,aa) = Gaussian.Center;
end
end
end

if FINDFLOW==1
    
    v_c = 299790458;
    theta = 10;
    Gaussian.DeltaLambda(:,:,:) = Gaussian.GaussCenter(:,:,:)-CenterOfInterest;
    velocity = (Spectra.DeltaLambda/CenterOfInterest)*v_c;
end

if FINDIONTEMP==1
    
    Spectra.RawDATA=double(Spectra.RawDATA);
    
    CHIarray = zeros(Spectra.Length(1,1)-Spectra.Length(1,3));
    KTNarray = zeros(Spectra.Length(1,1)-Spectra.Length(1,3));
    
    DATA.X = flip(Spectra.LambdaPlot);
muo = (4*pi)*10^(-7);
Coil1 = (0.939200000000000+0.939200000000000+0.0979000000000000)/2; %Center of Coil 1
Coil2 = (1.24920000000000+1.24920000000000+0.0979000000000000)/2; % Center of Coil 2
Coil3 = (1.57920000000000+1.57920000000000+0.0979000000000000)/2; % Center of Coil 3
Coil4 = (1.81520000000000+1.81520000000000+0.0979000000000000)/2; % Center of Coil 4
Coil5 = (2.14120000000000+2.14120000000000+0.0979000000000000)/2; % Center of Coil 5
Coil6 = (2.33920000000000+2.33920000000000+0.0979000000000000)/2; % Center of Coil 6
Coil7 = (2.89520000000000+2.89520000000000+0.0979000000000000)/2; % Center of Coil 7
Coil8 = (3.17120000000000+3.17120000000000+0.0979000000000000)/2; % Center of Coil 8
Coil9 = (3.36920000000000+3.36920000000000+0.0979000000000000)/2; % Center of Coil 9
Coil10 = (3.68520000000000+3.68520000000000+0.0979000000000000)/2; %Center of Coil 10
Coil11 = (3.99920000000000+3.99920000000000+0.0979000000000000)/2; % Center of Coil 11
Coil12 = (4.31720000000000+4.31720000000000+0.0979000000000000)/2; % Center of Coil 12
INSFUN = [0.2559 0.2521 0.2516 0.2568 0.2658]; %Pin-Lamp instrument function input
for ii=1:5
    if Fibers(:,ii)==0
    else
    BIN = ((muo*40*B_Field(:,1)*(21.7/100)^2/2)*(((Fibers(:,ii)-Coil3)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil4)^2+(21.7/100)^2)^(-3/2)))+((muo*40*B_Field(:,2)*(21.7/100)^2/2)*(((Fibers(:,ii)-Coil1)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil5)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil6)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil7)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil8)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil9)^2+(21.7/100)^2)^(-3/2)))+((muo*40*B_Field(:,3)*(21.7/100)^2/2)*(((Fibers(:,ii)-Coil10)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil11)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil12)^2+(21.7/100)^2)^(-3/2)))+((muo*40*B_Field(:,4)*(21.7/100)^2/2)*(((Fibers(:,ii)-Coil2)^2+(21.7/100)^2)^(-3/2)));
    % Adjust BIN designations depending upon magnetic geometry. 
%    BIN = 0.874;
    
for aa = 1:5
for bb = 8:8
    
DATA.I = Spectra.RawDATA(aa,:,bb);
[KTN, CHI] = FIT_EXAMPLE_V3(DATA,BIN,INSFUN(:,ii));

if KTN >= 30 || KTN <= 1E-5
    KTN = 0;
    CHI = 0;
end
KTNarray(bb,ii,aa) = KTN;
CHIarray(bb,ii,aa) = CHI;
end
end
end
end
end

if IONTEMPSINGLEFRAME==1

muo = (4*pi)*10^(-7);
Coil1 = (0.939200000000000+0.939200000000000+0.0979000000000000)/2; %Center of Coil 1
Coil2 = (1.24920000000000+1.24920000000000+0.0979000000000000)/2; % Center of Coil 2
Coil3 = (1.57920000000000+1.57920000000000+0.0979000000000000)/2; % Center of Coil 3
Coil4 = (1.81520000000000+1.81520000000000+0.0979000000000000)/2; % Center of Coil 4
Coil5 = (2.14120000000000+2.14120000000000+0.0979000000000000)/2; % Center of Coil 5
Coil6 = (2.33920000000000+2.33920000000000+0.0979000000000000)/2; % Center of Coil 6
Coil7 = (2.89520000000000+2.89520000000000+0.0979000000000000)/2; % Center of Coil 7
Coil8 = (3.17120000000000+3.17120000000000+0.0979000000000000)/2; % Center of Coil 8
Coil9 = (3.36920000000000+3.36920000000000+0.0979000000000000)/2; % Center of Coil 9
Coil10 = (3.68520000000000+3.68520000000000+0.0979000000000000)/2; %Center of Coil 10
Coil11 = (3.99920000000000+3.99920000000000+0.0979000000000000)/2; % Center of Coil 11
Coil12 = (4.31720000000000+4.31720000000000+0.0979000000000000)/2; % Center of Coil 12
INSFUN = [0.2559 0.2521 0.2516 0.2568 0.2658]; %Pin-Lamp instrument function input
for ii=1:5
if Fibers(:,ii)==0
else 
BIN = ((muo*40*B_Field(:,1)*(21.7/100)^2/2)*(((Fibers(:,ii)-Coil3)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil4)^2+(21.7/100)^2)^(-3/2)))+((muo*40*B_Field(:,2)*(21.7/100)^2/2)*(((Fibers(:,ii)-Coil1)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil5)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil6)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil7)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil8)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil9)^2+(21.7/100)^2)^(-3/2)))+((muo*40*B_Field(:,3)*(21.7/100)^2/2)*(((Fibers(:,ii)-Coil10)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil11)^2+(21.7/100)^2)^(-3/2)+((Fibers(:,ii)-Coil12)^2+(21.7/100)^2)^(-3/2)))+((muo*40*B_Field(:,4)*(21.7/100)^2/2)*(((Fibers(:,ii)-Coil2)^2+(21.7/100)^2)^(-3/2)));    
% Adjust BIN designations depending upon magnetic geometry.
%BIN = 0.874;
for jj = 1:1
    if ii==1
DATA.I = Spectra.SelfBGSub1(Spectra.FrameOfInterest,:);
    elseif ii==2
DATA.I = Spectra.SelfBGSub2(Spectra.FrameOfInterest,:);
    elseif ii==3
DATA.I = Spectra.SelfBGSub3(Spectra.FrameOfInterest,:);
    elseif ii==4
DATA.I = Spectra.SelfBGSub4(Spectra.FrameOfInterest,:); 
    elseif ii==5
DATA.I = Spectra.SelfBGSub3(Spectra.FrameOfInterest,:);
    end
DATA.X = flip(Spectra.LambdaPlot);
[KTNarray(jj,ii), CHIarray(jj,ii)] = FIT_EXAMPLE_V3(DATA,BIN,INSFUN(:,ii));
end
end
end
end

%%
if POWERLOSS==1
    
    VOLUMECALC=1;
end

if VOLUMECALC==1 % Calculates the volume of the plasma near fiber optic
    
[coil1, coil2] = Spool_Finder(Fibers);
h=zeros(1,5); %set up for radii of machine at fiber location
for ii=1:5
    if Fibers(:,ii) == Fiber1_5North | Fiber1_5Top | Fiber2_5North | Fiber2_5Top | Fiber4_5Bottom | Fiber5_5North
        h(:,ii) = 15.2/200; % [h = .5 diameter & converstion from [cm] to [m]
    elseif Fibers(:,ii) == Fiber6_5North || Fiber6_5South
        h(:,ii) = 41/200;
    elseif Fibers(:,ii) == Fiber7_5North | Fiber9_5South | Fiber9_5North | Fiber10_5South | Fiber11_5North
        h(:,ii) = 49/200;
    end
end
L=h*tand(1); %0.5 range of acceptance cone for fiber optic along z-axis
[r,s,ContourValues] = test_calc_flux_mpex_V3(coil1,coil2, B_Field,Fibers,L); %r=radii values for plasma calculations, s=radii values for cone calculations
Area = pi*r.^2;
Area2 = pi*s.^2;
VolumePlasma=zeros(1,5);
VolumeCone=zeros(1,5);
for ii=1:5
    VolumePlasma(:,ii) = sum((Area(:,ii)*(coil2(:,ii)-coil1(:,ii))/nnz(Area(:,ii)))); 
    VolumeCone(:,ii) = sum(Area2(:,ii)*(2*L(:,ii))/nnz(Area2(:,ii)));
end 
Volume = zeros(1,5);
VRatio = zeros(1,5);
for ii=1:5
    if VolumePlasma(:,ii) >= VolumeCone(:,ii)
    Volume(:,ii) = VolumeCone(:,ii);
    elseif VolumePlasma(:,ii) < VolumeCone(:,ii)
    Volume(:,ii) = VolumePlasma(:,ii);
    end
end
if POWERLOSS==1
else
fprintf('Volume = %i\n', Volume);
end
end

if POWERLOSS==1   

%Calculates the amount of power lost by using fiber as opposed to looking
%at entire plasma. In cases where the fiber can encompass the whole plasma
%between nearest two coils, the loss is said to be zero. Note that if a
%fiber is not in use for this experiment, the loss should also be zero, so
%use caution when interpreting zero as a return.
Spectra.Loss1=(Spectra.Intensity1/h(:,5))*Volume(:,5);
Spectra.Loss2=(Spectra.Intensity2/h(:,4))*Volume(:,4);
Spectra.Loss3=(Spectra.Intensity3/h(:,3))*Volume(:,3);
Spectra.Loss4=(Spectra.Intensity4/h(:,2))*Volume(:,2);
Spectra.Loss5=(Spectra.Intensity5/h(:,1))*Volume(:,1);
%VRatio must be written in reverse order as shown, as Fibers array lists
%fibers in physical fiber order from 1 to 5, while Intensity is calculated
%in the standard way.
figure;
plot(Spectra.LambdaPlot,(Spectra.Loss1))
hold on
plot(Spectra.LambdaPlot,(Spectra.Loss2))
plot(Spectra.LambdaPlot,(Spectra.Loss3))
plot(Spectra.LambdaPlot,(Spectra.Loss4))
plot(Spectra.LambdaPlot,(Spectra.Loss5))
ax = gca;
ax.FontSize = 15;
title('Power Loss vs wavelength [nm]','FontSize',15);
xlabel('Wavelength [nm]','FontSize',15);
ylabel('Power [mW]','FontSize',15);
xlim([Spectra.LambdaMin Spectra.LambdaMax])
ylim([0 inf]);
hold off
end