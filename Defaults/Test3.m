
idx=find(zvec == Coil10)
Yidx=bt(idx)

%vq=interp1(zvec,bt(1,:),((Coil9+Coil10)/2)) %Use this for McPher v3
vp=interp1(zvec,bt(1,:), 3.6)


%% 
figure;
mesh(flux)
set(gca,'XTickLabel',time(1:16.66:100,1))