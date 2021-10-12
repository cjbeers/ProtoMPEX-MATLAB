%%
data=load('C:\Users\cxe\Documents\GitHub\GITR1\protoMPEx\Al\assets\Beers_Helicon_3D_ModelPaperDensity_Plasma.txt');

%%
[aa bb]=size(data);

%%
for jj=1:bb
    
    for ii=1:aa
        if isnan(data(ii,jj))==1
        data(ii,jj)=data(ii-1,jj);
        end
    end
end
        