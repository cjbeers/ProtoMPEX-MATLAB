
%% OL Calibration

%Creates Absolute Intensity (Iabs) based on wavelengths obsereved in current data
%file being read.
%Creates table of counts for finding correction factor(Icts)
%Creates intensity correction factor IntensityCF
j=1;



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
 
