

[COMSOL.Rows,COMSOL.Columns] = size(COMSOL.AllData);
aa=1;
bb=1;

% for kk=0:1:COMSOL.Rows-1
%     
%     COMSOL.ne_min(kk+1)=real(COMSOL.AllData((kk*COMSOL.Rows-1),1));
%     COMSOL.ne_max(kk+1)=real(COMSOL.AllData(kk+1,2));
%     
% end

%%

for kk=0:1:COMSOL.Rows-1
    for jj=1:3:COMSOL.Columns-2
    for ii=1:5:COMSOL.Rows-2
        
    

        COMSOL.Bz{kk+1}(aa,bb) = (COMSOL.AllData((ii+kk),jj));
        COMSOL.realBz{kk+1}(aa,bb) = real(COMSOL.AllData((ii+kk),jj));
        COMSOL.imagBz{kk+1}(aa,bb) = imag(COMSOL.AllData((ii+kk),jj));
        COMSOL.PhaseBz{kk+1}(aa,bb)= (atan2(imag(COMSOL.AllData((ii+kk),jj)),real(COMSOL.AllData((ii+kk),jj))));

        aa=aa+1;
        
    end
    bb=bb+1;
    aa=1;
    end
    bb=1;
end

aa=1;
bb=1;
for kk=0:1:COMSOL.Rows-1
for jj=2:3:COMSOL.Columns-1
    for ii=1:5:COMSOL.Rows-1
    
    
        COMSOL.Br{kk+1}(aa,bb) = (COMSOL.AllData((ii+kk),jj));
        COMSOL.realBr{kk+1}(aa,bb) = real(COMSOL.AllData((ii+kk),jj));
        COMSOL.imagBr{kk+1}(aa,bb) = imag(COMSOL.AllData((ii+kk),jj));
        COMSOL.PhaseBr{kk+1}(aa,bb)= (atan2(imag(COMSOL.AllData((ii+kk),jj)),real(COMSOL.AllData((ii+kk),jj))));

        aa=aa+1;
        
    end
    bb=bb+1;
    aa=1;
end
    bb=1;
end

aa=1;
bb=1;
for kk=0:1:COMSOL.Rows-1
 for jj=3:3:COMSOL.Columns
    for ii=1:5:COMSOL.Rows
   
    
        COMSOL.ne{kk+1}(aa,bb) = real(COMSOL.AllData((ii+kk),jj));
        aa=aa+1;
        
    end
    bb=bb+1;
    aa=1;
 end
    bb=1;
end


