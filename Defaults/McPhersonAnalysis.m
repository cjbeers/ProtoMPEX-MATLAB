%Coded by Josh Beers @ ONRL
%For Proto-MPEX Calcutron computer to run McPherson data to tree between
%shots

%Modify intensity

%% Begin Code

function McPhersonAnalysis(ShotNum)
ExcelData= readtable('\\mpexserver\ProtoMPEX_Data\McPherson\McPherson Electronic Shot Log.xlsx', 'ReadVariableNames', true);
[row,~]=find(table2array(ExcelData(:,2))==ShotNum); %Finds the row with the shot

%if no shot number
if row==isempty(row)
    disp('No Shot')
    return
elseif row~=isempty(row) %if row is populated (shot exsists) run script

Spectra.Fibers=[table2array(ExcelData(row,6)) table2array(ExcelData(row,7)) table2array(ExcelData(row,8)) table2array(ExcelData(row,9)) table2array(ExcelData(row,10))];   

if Spectra.Fibers(1)==Spectra.Fibers(2)==Spectra.Fibers(3)==Spectra.Fibers(4)==Spectra.Fibers(5)
    disp('No fiber used')
    return
end
Spectra.Grating=table2array(ExcelData(row,5)); %Grooves/mm grating used
Spectra.McPherLoc=table2array(ExcelData(row,4)); %What you tunned the Mcpherson to in nanometers!
Spectra.Lambda0=table2array(ExcelData(row,3)); %Wavelength of interest
Spectra.StartTime=table2array(ExcelData(row,17)); %Gets the starting time point to make the time vector later


%Constants
c=299792458; %m/s
h=6.2607E-34; %Js
%E=hc/lambda %in Joules/photon.

%Reads in data file
Spectra.FileName=(['\\mpexserver\ProtoMPEX_Data\McPherson\2018_08_08\Shot',num2str(ShotNum),'.SPE']);
[Spectra.RawDATA,Spectra.ExposureTime, Spectra.Gain] = readSPE(Spectra.FileName);
Spectra.Length = size(Spectra.RawDATA);
fclose all;

if Spectra.Gain==1
    Spectra.RawDATA=Spectra.RawDATA*1.89;
elseif Spectra.Gain==3
    Spectra.RawDATA=Spectra.RawDATA/1.9;
elseif Spectra.Gain==2
else
    disp('McPherson - Error in Gain')
end

%Creates the spectra location to build wavelength vector from dispersion
if Spectra.Lambda0==0
if Spectra.Grating==300
Spectra.Lambda0 = (Spectra.McPherLoc*.4); 
elseif Spectra.Grating == 1800
Spectra.Lambda0 = (Spectra.McPherLoc/15);
end
elseif Spectra.Lambda0 ~=0
if Spectra.Grating==300
    if Spectra.McPherLoc*0.4 < Spectra.Lambda0-0.4
        Spectra.P0=180;
    elseif Spectra.McPherLoc*0.4 >= Spectra.Lambda0-0.4
        Spectra.P0=230;
    end
elseif Spectra.Grating==1800
     if Spectra.McPherLoc/15 < Spectra.Lambda0-0.4
        Spectra.P0=180;
    elseif Spectra.McPherLoc/15>= Spectra.Lambda0-0.4
        Spectra.P0=230;
     end
end
end

%% Begin data 

%Creates a matrix to be filled with raw data
Spectra.RawFiber1=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 1
Spectra.RawFiber2=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 2
Spectra.RawFiber3=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 3
Spectra.RawFiber4=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 4
Spectra.RawFiber5=zeros(Spectra.Length(:,3),Spectra.Length(:,2)); %making a matrix that is 50x512 for Fiber 5
        
for ii = 1:Spectra.Length(:,3) %Breaks raw data into individual fibers
  Spectra.RawFiber1(ii,:) = flip(double(Spectra.RawDATA(5,:,ii)));
  Spectra.RawFiber2(ii,:) = flip(double(Spectra.RawDATA(4,:,ii)));
  Spectra.RawFiber3(ii,:) = flip(double(Spectra.RawDATA(3,:,ii)));
  Spectra.RawFiber4(ii,:) = flip(double(Spectra.RawDATA(2,:,ii)));
  Spectra.RawFiber5(ii,:) = flip(double(Spectra.RawDATA(1,:,ii)));
  
  %Creates a background array from each frame on each fiber 
  Spectra.SelfBG1(ii,1)=abs(mean2(Spectra.RawFiber1(ii,5:10)));
  Spectra.SelfBG2(ii,1)=abs(mean2(Spectra.RawFiber2(ii,5:10)));
  Spectra.SelfBG3(ii,1)=abs(mean2(Spectra.RawFiber3(ii,5:10)));
  Spectra.SelfBG4(ii,1)=abs(mean2(Spectra.RawFiber4(ii,5:10)));
  Spectra.SelfBG5(ii,1)=abs(mean2(Spectra.RawFiber5(ii,5:10)));
  
  %Creates a data array that has its self backgorund subtracted, 
  %IF A PEAK IS IN THIS BG IT WILL MESS UP FITTINGS
  Spectra.SelfBGSub1(ii,:)=Spectra.RawFiber1(ii,:)-Spectra.SelfBG1(ii,1);
  Spectra.SelfBGSub2(ii,:)=Spectra.RawFiber2(ii,:)-Spectra.SelfBG2(ii,1);
  Spectra.SelfBGSub3(ii,:)=Spectra.RawFiber3(ii,:)-Spectra.SelfBG3(ii,1);
  Spectra.SelfBGSub4(ii,:)=Spectra.RawFiber4(ii,:)-Spectra.SelfBG4(ii,1);
  Spectra.SelfBGSub5(ii,:)=Spectra.RawFiber5(ii,:)-Spectra.SelfBG5(ii,1);
end

Spectra.Pixels=(1:512); %Creates an array of pixels to match camera pixels

%% Uses dispersion to create wavelength at each pixel

%Creates a pixel array for using dispersion to map wavelength to the pixels
Spectra.PixelsC(1:Spectra.P0,:) = (Spectra.P0-1:-1:0)'; %From 1 to Peak of Interest 
Spectra.PixelsC(Spectra.P0+1:Spectra.Length(1,2),:) = (1:1:(Spectra.Length(1,2)-Spectra.P0))'; %From Peak of Interest to 512

%Creates the Dispersion of the Mcpherson, DO NOT CHANGE
for ii=1:512
      if Spectra.Grating ==300
      Spectra.Disper = -0.055; %For 300nm Grating
      elseif Spectra.Grating==1800
      Spectra.Disper= -(0.09354-3.8264E-6*Spectra.Lambda0*10+8.7181E-11*(Spectra.Lambda0*10)^2-1.0366E-14*(Spectra.Lambda0*10)^3-2.5001E-18*(Spectra.Lambda0*10)^4)/10; %For 1800nm Grating, this Grating has been working for everything atm
     end
    Spectra.PixCDisp(ii,1) = Spectra.PixelsC(ii,1)*Spectra.Disper; %The entire file times the dispersion coeff.
end

%Creates the wavelength (lambda) for plotting
Spectra.Lambda(1:Spectra.P0,:) = Spectra.Lambda0 - Spectra.PixCDisp(1:Spectra.P0,:); %Conversion of pixel to wavelength
Spectra.Lambda(Spectra.P0+1:Spectra.Length(1,2),:) = rot90(Spectra.Lambda0 + Spectra.PixCDisp(Spectra.P0+1:Spectra.Length(1,2),:)); %Conversion of pixel to wavelength
Spectra.LambdaPlot=rot90((flip(Spectra.Lambda)));
Spectra.LambdaMin=Spectra.LambdaPlot(1,512); %Used for x min and max in plots
Spectra.LambdaMax=Spectra.LambdaPlot(1,1);
Spectra.PixelSize=Spectra.LambdaPlot(1,1)-Spectra.LambdaPlot(1,2); %Nm/pixel 

%% Intensity calculations
%WL remakes CF for each wavelength looked at with single files
%Intensity in (mW/cm2-micron) converted to (mW/m2) for HL source
%Intenisty in (mW/cm2-sr-nm) converted to (mW/m2) for OL source
%Intensity now in Photons/s/m2

%For 300nm Grating, wihich uses HL to calibrate

if Spectra.Grating ==300
for jj=1:Spectra.Length(1,3)
    Spectra.Time(jj)=Spectra.StartTime+((jj-1)*Spectra.ExposureTime);
for ii=1:512
WL=Spectra.LambdaPlot(1,ii);
PolTrans=((0.007568*WL^2+38.71*WL+-1.655E4)/(WL+-391.3))/100; %Transmission of the Polarizer
Spectra.F1CF(1,ii) =-(3056574429229055*WL^6)/2596148429267413814265248164610048 + (5619162961737097*WL^5)/1267650600228229401496703205376 - (4231508340035941*WL^4)/618970019642690137449562112 + (3345429297905545*WL^3)/604462909807314587353088 - (5859150790520435*WL^2)/2361183241434822606848 + (5387567721134835*WL)/9223372036854775808 - 8114035101143863/144115188075855872;
Spectra.Intensity1(jj,ii)=(((Spectra.F1CF(1,ii)*(Spectra.SelfBGSub1(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F2CF(1,ii) =(7302221534579973*WL^6)/5192296858534827628530496329220096 - (1512047247641153*WL^5)/316912650057057350374175801344 + (519560686567997*WL^4)/77371252455336267181195264 - (6069351690507449*WL^3)/1208925819614629174706176 + (4967682192603545*WL^2)/2361183241434822606848 - (4324620186983531*WL)/9223372036854775808 + 6262978433970463/144115188075855872;
Spectra.Intensity2(jj,ii)=(((Spectra.F2CF(1,ii)*(Spectra.SelfBGSub2(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F3CF(1,ii) =(6685689374474273*WL^6)/5192296858534827628530496329220096 - (5538637756507167*WL^5)/1267650600228229401496703205376 + (3809644293763157*WL^4)/618970019642690137449562112 - (2786038952453225*WL^3)/604462909807314587353088 + (4572309193917549*WL^2)/2361183241434822606848 - (3994730768181719*WL)/9223372036854775808 + 5813337095729975/144115188075855872;
Spectra.Intensity3(jj,ii)=(((Spectra.F3CF(1,ii)*(Spectra.SelfBGSub3(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F4CF(1,ii) =(2626695280632411*WL^6)/1298074214633706907132624082305024 - (1076220889837839*WL^5)/158456325028528675187087900672 + (5845266505055671*WL^4)/618970019642690137449562112 - (8418572225483743*WL^3)/1208925819614629174706176 + (3392225726576867*WL^2)/1180591620717411303424 - (5804480930144169*WL)/9223372036854775808 + 4122263530836521/72057594037927936;
Spectra.Intensity4(jj,ii)=(((Spectra.F4CF(1,ii)*(Spectra.SelfBGSub4(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F5CF(1,ii) =(1101630822525047*WL^6)/649037107316853453566312041152512 - (7265777621430527*WL^5)/1267650600228229401496703205376 + (4967798444037317*WL^4)/618970019642690137449562112 - (7213530429423309*WL^3)/1208925819614629174706176 + (5868229780194579*WL^2)/2361183241434822606848 - (5074883106023453*WL)/9223372036854775808 + 7297156861788209/144115188075855872;
Spectra.Intensity5(jj,ii)=(((Spectra.F5CF(1,ii)*(Spectra.SelfBGSub5(jj,ii)))/(Spectra.ExposureTime*1000))*100^2)*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
end
end

%For 1800nm Grating, which uses OL to calibrate 

elseif Spectra.Grating ==1800
for jj=1:Spectra.Length(1,3)
    Spectra.Time(jj)=Spectra.StartTime+((jj-1)*Spectra.ExposureTime);
for ii=1:512
WL=Spectra.LambdaPlot(1,ii);
PolTrans=((0.007568*WL^2+38.71*WL+-1.655E4)/(WL+-391.3))/100; %Transmission of the Polarizer
Spectra.F1CF(1,ii) = -(8128602229559119*WL^6)/5316911983139663491615228241121378304 + (6770935128186101*WL^5)/1298074214633706907132624082305024 - (4612227632479779*WL^4)/633825300114114700748351602688 + (6554231572492777*WL^3)/1237940039285380274899124224 - (5094898972821211*WL^2)/2417851639229258349412352 + (8142021870704233*WL)/18889465931478580854784 - 2567853893604121/73786976294838206464;
Spectra.Intensity1(jj,ii)=(((Spectra.F1CF(1,ii)*(Spectra.SelfBGSub1(jj,ii))*100^2*4*pi/PolTrans*1.1)/(Spectra.ExposureTime*1000)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F2CF(1,ii) = -(8789350527914021*WL^6)/42535295865117307932921825928971026432 + (5905492503948825*WL^5)/10384593717069655257060992658440192 - (2783491648979549*WL^4)/5070602400912917605986812821504 + (204987856063123*WL^3)/1237940039285380274899124224 + (4720037523702579*WL^2)/77371252455336267181195264 - (7531592530322833*WL)/151115727451828646838272 + 1292104971979181/147573952589676412928;
Spectra.Intensity2(jj,ii)=(((Spectra.F2CF(1,ii)*(Spectra.SelfBGSub2(jj,ii))*100^2*4*pi/PolTrans*1.1)/(Spectra.ExposureTime*1000)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F3CF(1,ii) = -(8006662218097889*WL^6)/21267647932558653966460912964485513216 + (93141810256361*WL^5)/81129638414606681695789005144064 - (3448877051813151*WL^4)/2535301200456458802993406410752 + (7538698440583817*WL^3)/9903520314283042199192993792 - (217389890528869*WL^2)/1208925819614629174706176 + (1741527951873869*WL)/2417851639229258349412352 + 1326004963232429/295147905179352825856;
Spectra.Intensity3(jj,ii)=(((Spectra.F3CF(1,ii)*(Spectra.SelfBGSub3(jj,ii))*100^2*4*pi/PolTrans*1.1)/(Spectra.ExposureTime*1000)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F4CF(1,ii) = -(2395703957625853*WL^6)/10633823966279326983230456482242756608 + (1625869995473377*WL^5)/2596148429267413814265248164610048 - (6317357511792973*WL^4)/10141204801825835211973625643008 + (8577283721094079*WL^3)/39614081257132168796771975168 + (3175833775833093*WL^2)/77371252455336267181195264 - (6887963036818475*WL)/151115727451828646838272 + 4937937996623129/590295810358705651712;
Spectra.Intensity4(jj,ii)=(((Spectra.F4CF(1,ii)*(Spectra.SelfBGSub4(jj,ii))*100^2*4*pi/PolTrans*1.1)/(Spectra.ExposureTime*1000)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
Spectra.F5CF(1,ii) = -(3243414316440337*WL^6)/10633823966279326983230456482242756608 + (2309603620420301*WL^5)/2596148429267413814265248164610048 - (4965101537564181*WL^4)/5070602400912917605986812821504 + (579661006787533*WL^3)/1237940039285380274899124224 - (272890451144983*WL^2)/4835703278458516698824704 - (3949141763188333*WL)/151115727451828646838272 + 4030589618284611/590295810358705651712;
Spectra.Intensity5(jj,ii)=(((Spectra.F5CF(1,ii)*(Spectra.SelfBGSub5(jj,ii))*100^2*4*pi/PolTrans*1.1)/(Spectra.ExposureTime*1000)))*(1/1000)*((Spectra.LambdaPlot(ii)*1E-9)/(h*c));
%Spectra.IntensityAll=Spectra.Intenisty1

end
end
end

clear WL ans ii jj
end
end




