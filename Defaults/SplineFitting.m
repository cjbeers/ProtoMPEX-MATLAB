% Ocean Optics HL-2000-CAL calibration data from Ocean Optics
% calibration:  12/13/2010
% bare optical fiber
% luminace at calibration:  
%STILL WORK IN PROGRESS

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
calib_size = size(lamp_rad);
%Spline for creating calibration factor data.
%Spline Equation is c4+c3(x-Xo)+c2(x-Xo)^2+(x-Xo)^3 for 4th order

S = spline(lamp_wav,lamp_rad);
xx = 300:1:1050;
coefs = S.coefs;

%{
figure;
hold on;
plot(lamp_wav,lamp_rad,'o',xx,ppval(S,xx),'-');
%}

%Creates easy to read table of the calibration lamp values
lamptable=zeros(2,calib_size(1,1));
lamptable(1,:)=lamp_wav;
lamptable(2,:)=lamp_rad;

%Uses lambda_o from USER input in absolute_calib_1spectrum_beers to chose
%corect spline coefficients.
%lambda_o=400;

if lambda_o <= S.breaks(1,1)
    disp('Error, lambda_o too low, try again.')
elseif lambda_o <= S.breaks(1,2)
c1= S.coefs(1,4); c2=S.coefs(1,3); c3=S.coefs(1,2); c4=S.coefs(1,1); xo=S.breaks(1,1);
elseif lambda_o <= S.breaks(1,3)
c1= S.coefs(2,4); c2=S.coefs(2,3); c3=S.coefs(2,2); c4=S.coefs(2,1); xo=S.breaks(1,2);
elseif lambda_o <= S.breaks(1,4)
c1= S.coefs(3,4); c2=S.coefs(3,3); c3=S.coefs(3,2); c4=S.coefs(3,1); xo=S.breaks(1,3);
elseif lambda_o <= S.breaks(1,5)
c1= S.coefs(4,4); c2=S.coefs(4,3); c3=S.coefs(4,2); c4=S.coefs(4,1); xo=S.breaks(1,4);
elseif lambda_o <= S.breaks(1,6)
c1= S.coefs(5,4); c2=S.coefs(5,3); c3=S.coefs(5,2); c4=S.coefs(5,1); xo=S.breaks(1,5);
elseif lambda_o <= S.breaks(1,7)
c1= S.coefs(6,4); c2=S.coefs(6,3); c3=S.coefs(6,2); c4=S.coefs(6,1); xo=S.breaks(1,6);
elseif lambda_o <= S.breaks(1,8)
c1= S.coefs(7,4); c2=S.coefs(7,3); c3=S.coefs(7,2); c4=S.coefs(7,1); xo=S.breaks(1,7);
elseif lambda_o <= S.breaks(1,9)
c1= S.coefs(8,4); c2=S.coefs(8,3); c3=S.coefs(8,2); c4=S.coefs(8,1); xo=S.breaks(1,8);
elseif lambda_o <= S.breaks(1,10)
c1= S.coefs(9,4); c2=S.coefs(9,3); c3=S.coefs(9,2); c4=S.coefs(9,1); xo=S.breaks(1,9);
elseif lambda_o <= S.breaks(1,11)
c1= S.coefs(10,4); c2=S.coefs(10,3); c3=S.coefs(10,2); c4=S.coefs(10,1); xo=S.breaks(1,10);
elseif lambda_o <= S.breaks(1,12)
c1= S.coefs(11,4); c2=S.coefs(11,3); c3=S.coefs(11,2); c4=S.coefs(11,1); xo=S.breaks(1,11);
elseif lambda_o <= S.breaks(1,13)
c1= S.coefs(12,4); c2=S.coefs(12,3); c3=S.coefs(12,2); c4=S.coefs(12,1); xo=S.breaks(1,12);
elseif lambda_o <= S.breaks(1,14)
c1= S.coefs(13,4); c2=S.coefs(13,3); c3=S.coefs(13,2); c4=S.coefs(13,1); xo=S.breaks(1,13);
elseif lambda_o <= S.breaks(1,15)
c1= S.coefs(14,4); c2=S.coefs(14,3); c3=S.coefs(14,2); c4=S.coefs(14,1); xo=S.breaks(1,14);
elseif lambda_o <= S.breaks(1,16)
c1= S.coefs(15,4); c2=S.coefs(15,3); c3=S.coefs(15,2); c4=S.coefs(15,1); xo=S.breaks(1,15);
elseif lambda_o <= S.breaks(1,17)
c1= S.coefs(16,4); c2=S.coefs(16,3); c3=S.coefs(16,2); c4=S.coefs(16,1); xo=S.breaks(1,16);
elseif lambda_o <= S.breaks(1,18)
c1= S.coefs(17,4); c2=S.coefs(17,3); c3=S.coefs(17,2); c4=S.coefs(17,1); xo=S.breaks(1,17);
elseif lambda_o <= S.breaks(1,19)
c1= S.coefs(18,4); c2=S.coefs(18,3); c3=S.coefs(18,2); c4=S.coefs(18,1); xo=S.breaks(1,18);
elseif lambda_o <= S.breaks(1,20)
c1= S.coefs(19,4); c2=S.coefs(19,3); c3=S.coefs(19,2); c4=S.coefs(19,1); xo=S.breaks(1,19);
elseif lambda_o <= S.breaks(1,21)
c1= S.coefs(20,4); c2=S.coefs(20,3); c3=S.coefs(20,2); c4=S.coefs(20,1); xo=S.breaks(1,20);
elseif lambda_o <= S.breaks(1,22)
c1= S.coefs(21,4); c2=S.coefs(21,3); c3=S.coefs(21,2); c4=S.coefs(21,1); xo=S.breaks(1,21);
elseif lambda_o <= S.breaks(1,23)
c1= S.coefs(22,4); c2=S.coefs(22,3); c3=S.coefs(22,2); c4=S.coefs(22,1); xo=S.breaks(1,22);
elseif lambda_o <= S.breaks(1,24)
c1= S.coefs(23,4); c2=S.coefs(23,3); c3=S.coefs(23,2); c4=S.coefs(23,1); xo=S.breaks(1,23);
elseif lambda_o <= S.breaks(1,25)
c1= S.coefs(24,4); c2=S.coefs(24,3); c3=S.coefs(24,2); c4=S.coefs(24,1); xo=S.breaks(1,24);
elseif lambda_o <= S.breaks(1,26)
c1= S.coefs(25,4); c2=S.coefs(25,3); c3=S.coefs(25,2); c4=S.coefs(25,1); xo=S.breaks(1,25);
elseif lambda_o <= S.breaks(1,27)
c1= S.coefs(26,4); c2=S.coefs(26,3); c3=S.coefs(26,2); c4=S.coefs(26,1); xo=S.breaks(1,26);
elseif lambda_o <= S.breaks(1,28)
c1= S.coefs(27,4); c2=S.coefs(27,3); c3=S.coefs(27,2); c4=S.coefs(27,1); xo=S.breaks(1,27);
elseif lambda_o <= S.breaks(1,29)
c1= S.coefs(28,4); c2=S.coefs(28,3); c3=S.coefs(28,2); c4=S.coefs(28,1); xo=S.breaks(1,28);
else lambda_o >= S.breaks(1,29)
    disp('Error, lambda_o too high, try again.')
end

%Creates Absolute Intensity (Iabs) based on wavelengths obsereved in current data
%file being read.
%Creates table of counts for finding correction factor(Icts)
%Creates intensity correction factor IntensityCF

j=1;

if k==1
    for j = 1:512
    RawCounts(1,a+j)=Fiber1(1,j);
    RawBkg(1,a+j)=Fiber1bg(1,j);
    CCounts(1,a+j)=cor_f1(1,j);
    Iabs(k+2,(a+j))= c1+c2*(correctedtable(2,j)-xo).^1+c3*(correctedtable(2,j)-xo).^2+c4*(correctedtable(2,j)-xo).^3;
    Iabs(1,(a+j))=lambdanum(1,l);
    Iabs(2,(a+j))=correctedtable(2,j);
    Icts(1,(a+j))=lambdanum(1,l);
    Icts(2,(a+j))=correctedtable(2,j);
    Icts(k+2,(a+j))=correctedtable(3,j);
    IntensityCF(1,a+j)=lambdanum(1,l);
	IntensityCF(2,(a+j))=correctedtable(2,j);
    IntensityCF(k+2,(a+j))=(Iabs(k+2,(a+j)))/(Icts(k+2,(a+j)));
    CorrectedIabs(1,(a+j))=lambdanum(1,l);
    CorrectedIabs(2,(a+j))=correctedtable(2,j);
    CorrectedIabs(k+2,(a+j))=IntensityCF(k+2,(a+j))*Iabs(k+2,(a+j));
    end 
    a=a+512;
    elseif k==2
    for j = 1:512
    RawCounts(2,b+j)=Fiber2(1,j);
    RawBkg(2,b+j)=Fiber2bg(1,j);
    CCounts(2,b+j)=cor_f2(1,j);
    Iabs(k+2,(b+j))= c1+c2*(correctedtable(2,j)-xo).^1+c3*(correctedtable(2,j)-xo).^2+c4*(correctedtable(2,j)-xo).^3;
    Icts(k+2,b+j)=correctedtable(3,j);
    IntensityCF(k+2,(b+j))= (Iabs(k+2,(b+j)))/(Icts(k+2,(b+j)));
    CorrectedIabs(k+2,(b+j))=IntensityCF(k+2,(b+j))*Iabs(k+2,(b+j));
    end 
    b=b+512;
elseif k==3
    for j = 1:512
    RawCounts(3,c+j)=Fiber3(1,j);
    RawBkg(3,c+j)=Fiber3bg(1,j);
    CCounts(3,c+j)=cor_f3(1,j);
    Iabs(k+2,(c+j))= c1+c2*(correctedtable(2,j)-xo).^1+c3*(correctedtable(2,j)-xo).^2+c4*(correctedtable(2,j)-xo).^3;
    Icts(k+2,c+j)=correctedtable(3,j);
    IntensityCF(k+2,(c+j))= (Iabs(k+2,(c+j)))/(Icts(k+2,(c+j)));
    CorrectedIabs(k+2,(c+j))=IntensityCF(k+2,(c+j))*Iabs(k+2,(c+j));
    end 
    c=c+512;
elseif k==4
    for j = 1:512 
    RawCounts(4,d+j)=Fiber4(1,j);
    RawBkg(4,d+j)=Fiber4bg(1,j);
    CCounts(4,d+j)=cor_f4(1,j);
    Iabs(k+2,(d+j))= c1+c2*(correctedtable(2,j)-xo).^1+c3*(correctedtable(2,j)-xo).^2+c4*(correctedtable(2,j)-xo).^3;
    Icts(k+2,d+j)=correctedtable(3,j);
    IntensityCF(k+2,(d+j))= (Iabs(k+2,(d+j)))/(Icts(k+2,(d+j)));
    CorrectedIabs(k+2,(d+j))=IntensityCF(k+2,(d+j))*Iabs(k+2,(d+j));
    end 
    d=d+512;
elseif k==5
    for j = 1:512
    RawCounts(5,e+j)=Fiber5(1,j);
    RawBkg(5,e+j)=Fiber5bg(1,j);
    CCounts(5,e+j)=cor_f5(1,j);
    Iabs(k+2,(e+j))= c1+c2*(correctedtable(2,j)-xo).^1+c3*(correctedtable(2,j)-xo).^2+c4*(correctedtable(2,j)-xo).^3;
    Icts(k+2,e+j)=correctedtable(3,j);
    IntensityCF(k+2,(e+j))= (Iabs(k+2,(e+j)))/(Icts(k+2,(e+j)));
    CorrectedIabs(k+2,(e+j))=IntensityCF(k+2,(e+j))*Iabs(k+2,(e+j));
    end
    e=e+512;
    l=l+1;
    else 
    disp('Error in Iabs Table')
end

wtf=size(IntensityCF);

for ii=1:wtf(1,1)
    for iii=1:wtf(1,2)
if IntensityCF(ii,iii) == inf
    IntensityCF(ii,iii)= IntensityCF(ii, iii-1);
   end
    end
end
 






