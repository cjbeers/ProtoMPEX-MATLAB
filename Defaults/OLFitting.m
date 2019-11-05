
%% OL Calibration

%Creates Absolute Intensity (Iabs) based on wavelengths obsereved in current data
%file being read.
%Creates table of counts for finding correction factor(Icts)
%Creates intensity correction factor IntensityCF
j=1;

%OL Wavelength and Spectral Radiance in [W/(sr*cm^2*nm)]
OL455.Wavelength=(350:10:1100);
OL455.SpecRad=[8.679E-07,0.000001147,0.000001443,0.000001887,0.000002376,0.000002987,0.000003691,0.000004453,0.000005254,0.000006125,0.000007071,0.000008132,0.000009196,0.00001029,0.00001143,0.00001261,0.00001381,0.00001503,0.00001628,0.00001755,0.00001886,0.00002011,0.0000213,0.00002258,0.00002388,0.00002498,0.00002627,0.00002755,0.00002871,0.00002989,0.00003103,0.00003211,0.00003313,0.00003414,0.0000351,0.00003603,0.00003687,0.00003722,0.00003842,0.00003907,0.00003995,0.00004012,0.00004061,0.00004115,0.00004162,0.00004208,0.00004246,0.0000428,0.00004304,0.00004337,0.00004369,0.00004401,0.0000443,0.00004461,0.00004487,0.00004521,0.00004551,0.00004569,0.00004577,0.00004583,0.00004605,0.0000462,0.00004631,0.00004637,0.00004643,0.00004648,0.00004649,0.00004643,0.00004621,0.00004594,0.00004579,0.00004553,0.00004521,0.00004489,0.00004468,0.00004425];

k=1;
    for j = 1:512
    RawCounts(1,a+j)=Fiber1(1,j);
    RawBkg(1,a+j)=Fiber1bg(1,j);
    CCounts(1,a+j)=cor_f1(1,j);
    Iabs(k+2,(a+j))= -4E-21*correctedtable(2,j)^6 + 1E-17*correctedtable(2,j)^5 - 2E-14*correctedtable(2,j)^4 + 2E-11*correctedtable(2,j)^3 - 6E-09*correctedtable(2,j)^2 + 9E-07*correctedtable(2,j) - 5E-05;
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
k=2;
    for j = 1:512
    RawCounts(2,b+j)=Fiber2(1,j);
    RawBkg(2,b+j)=Fiber2bg(1,j);
    CCounts(2,b+j)=cor_f2(1,j);
    Iabs(k+2,(b+j))= -4E-21*correctedtable(2,j)^6 + 1E-17*correctedtable(2,j)^5 - 2E-14*correctedtable(2,j)^4 + 2E-11*correctedtable(2,j)^3 - 6E-09*correctedtable(2,j)^2 + 9E-07*correctedtable(2,j) - 5E-05;
    Icts(k+2,b+j)=correctedtable(4,j);
    IntensityCF(k+2,(b+j))= (Iabs(k+2,(b+j)))/(Icts(k+2,(b+j)));
    CorrectedIabs(k+2,(b+j))=IntensityCF(k+2,(b+j))*Iabs(k+2,(b+j));
    end 
    b=b+512;
k=3;
    for j = 1:512
    RawCounts(3,c+j)=Fiber3(1,j);
    RawBkg(3,c+j)=Fiber3bg(1,j);
    CCounts(3,c+j)=cor_f3(1,j);
    Iabs(k+2,(c+j))=  -4E-21*correctedtable(2,j)^6 + 1E-17*correctedtable(2,j)^5 - 2E-14*correctedtable(2,j)^4 + 2E-11*correctedtable(2,j)^3 - 6E-09*correctedtable(2,j)^2 + 9E-07*correctedtable(2,j) - 5E-05;
    Icts(k+2,c+j)=correctedtable(5,j);
    IntensityCF(k+2,(c+j))= (Iabs(k+2,(c+j)))/(Icts(k+2,(c+j)));
    CorrectedIabs(k+2,(c+j))=IntensityCF(k+2,(c+j))*Iabs(k+2,(c+j));
    end 
    c=c+512;
    k=4;
    for j = 1:512 
    RawCounts(4,d+j)=Fiber4(1,j);
    RawBkg(4,d+j)=Fiber4bg(1,j);
    CCounts(4,d+j)=cor_f4(1,j);
    Iabs(k+2,(d+j))= -4E-21*correctedtable(2,j)^6 + 1E-17*correctedtable(2,j)^5 - 2E-14*correctedtable(2,j)^4 + 2E-11*correctedtable(2,j)^3 - 6E-09*correctedtable(2,j)^2 + 9E-07*correctedtable(2,j) - 5E-05;
    Icts(k+2,d+j)=correctedtable(6,j);
    IntensityCF(k+2,(d+j))= (Iabs(k+2,(d+j)))/(Icts(k+2,(d+j)));
    CorrectedIabs(k+2,(d+j))=IntensityCF(k+2,(d+j))*Iabs(k+2,(d+j));
    end 
    d=d+512;
    k=5;
    for j = 1:512
    RawCounts(5,e+j)=Fiber5(1,j);
    RawBkg(5,e+j)=Fiber5bg(1,j);
    CCounts(5,e+j)=cor_f5(1,j);
    Iabs(k+2,(e+j))= -4E-21*correctedtable(2,j)^6 + 1E-17*correctedtable(2,j)^5 - 2E-14*correctedtable(2,j)^4 + 2E-11*correctedtable(2,j)^3 - 6E-09*correctedtable(2,j)^2 + 9E-07*correctedtable(2,j) - 5E-05;
    Icts(k+2,e+j)=correctedtable(7,j);
    IntensityCF(k+2,(e+j))= (Iabs(k+2,(e+j)))/(Icts(k+2,(e+j)));
    CorrectedIabs(k+2,(e+j))=IntensityCF(k+2,(e+j))*Iabs(k+2,(e+j));
    end
    e=e+512;
    l=l+1;
%     else 
%     disp('Error in Iabs Table')
%end

wtf=size(IntensityCF);

for ii=1:wtf(1,1)
    for iii=1:wtf(1,2)
if IntensityCF(ii,iii) == inf
    IntensityCF(ii,iii)= IntensityCF(ii, iii-1);
    disp('Error, in Values')
   end
    end
end
 
