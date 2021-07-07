clearvars; clc; close all;
load('MC_Error_Pixelated')

err = zeros(length(Ti),length(S2N),MC);
SSS = zeros(length(Ti),length(S2N));
MMM = zeros(length(Ti),length(S2N));
PER = zeros(length(Ti),length(S2N));

for ii = 1:length(S2N)  
    for kk=1:length(Ti)
        for jj = 1:MC
            err(kk,ii,jj) = abs(Ti_new(kk,ii,jj)-Ti(kk));
        end
    MMM(kk,ii) = (mean(squeeze(err(kk,ii,:))));
    SSS(kk,ii) = (std(squeeze(Ti_new(kk,ii,:))));
    PER(kk,ii) = SSS(kk,ii)/Ti(kk);
    end  
end
% SSS = std(Ti_new,3);
% MMM = (mean(err,3));
% SSS = (std(err,3));
% VAR = var(err,3);

Ti_pred = mean(Ti_new,3);


for ii=1:length(S2N)
    Ti_offset(:,ii) = Ti_pred(:,ii)-Ti';
end
contourf(S2N,Ti,PER,[0:0.1:1.5])
axis([0 100 0 19])
colorbar
    
   
% figure(1)
% contourf(S2N,Ti,MMM,[0,0.1,5.0])
% colorbar
% title('log_{10}(Percent Error)')
% xlabel('Signal to Noise Ratio')
% ylabel('T_i [eV]')
% set(gca,'fontsize',18,'fontname','times')
% 
% 
% figure(2)
% contourf(S2N,Ti,SSS,[0.0:0.1:1])
% colorbar
% title('Error (\sigma [eV])')
% xlabel('Signal to Noise Ratio')
% ylabel('T_i [eV]')
% set(gca,'fontsize',18,'fontname','times')
% 
% print(figure(1),'PercentError','-dpng')
% print(figure(2),'Error','-dpng')

Ti_MC  = Ti;
S2N_MC = S2N;

save('Table_MC_Error_Pixelated','SSS','MMM','PER','Ti_MC','S2N_MC')