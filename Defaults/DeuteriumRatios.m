
for ii=1:5
    
    for jj=1:20
        
        RawMax_Dalpha(ii,jj)=double(max(Spectra.RawDATA(ii,:,jj));
        
    end
end

%%
figure;
plot(x(2:end),BetatoAlphaRatio(5,:))
hold on
plot(x(2:end),BetatoAlphaRatio(1,:))
plot(x(2:end),BetatoAlphaRatio(3,:))
ylabel('Ratio of Dbeta to Dalpha')
xlabel('Time')
ylabel('Ratio of Dbeta to Dalpha')
title('Deuterium Beta/Alpha Ratio')
plot(x(2:end),BetatoAlphaRatio(2,:), 'k')
plot(x(2:end),BetatoAlphaRatio(4,:), 'm')
legend('Location 10.5','Location 11.5 Closer to Target','Location 11.5', '11.5 Bot', '11.5 Top')
hold off
