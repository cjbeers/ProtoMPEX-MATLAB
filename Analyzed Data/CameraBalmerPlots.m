%% Plots Balmer data from FVC data for C, SS, and SiC targets
%Coded by Josh Beers @ ORNL

%% Load in data

load('CameraBalmer.mat')

%% Plot Data
%SS target alpha, beta, gamma
fig=figure;
plot(374-8.925+((200:700)*0.0134),(SS.a(335,200:700))/max(max(SS.a(335,200:700))),'r')
hold on;
plot(374-8.925+((200:700)*0.0134),(SS.b(335,200:700)/max(max(SS.b(335,200:700)))),'g')
plot(374-8.925+((200:700)*0.0134),(SS.g(335,200:700)/max(max(SS.g(335,200:700)))),'b')

% plot(374-8.925+((200:700)*0.0134),(SS.a(335,200:700)),'r')
% hold on;
% plot(374-8.925+((200:700)*0.0134),(SS.b(335,200:700)),'g')
% plot(374-8.925+((200:700)*0.0134),(SS.g(335,200:700)),'b')

vline(374,'k','Target Location')
%set(gca,'yscale','log')
xlim([368 375])
%ylim([1E-2 1]);
ylabel('Normalized Intensity [a. u.]')
xlabel('Machine z-location [cm]')
legend('Alpha','Beta','Gamma','Location','north');
hold off

%% Plot Data
%SS target beta/gamma and gamma/alpha
 SS.ga=SS.g./SS.a;
 SS.gb=SS.g./SS.b;

fig=figure;
plot(374-8.925+((200:700)*0.0134),(SS.ga(335,200:700)),'k')
hold on;
plot(374-8.925+((200:700)*0.0134),(SS.gb(335,200:700)),'m')

vline(374,'k','Target Location')
%set(gca,'yscale','log')
xlim([368 375])
%ylim([0 2]);
ylabel('Balmer Ratios [Ab. Units]')
xlabel('Machine z-location [cm]')
legend('Gamma/Alpha','Gamma/Beta','Location','north');
hold off

%%
%C target
fig=figure;
plot((424-8-50+((200:775)*0.0108)),(C.a(400,200:775)/max(max(C.a(400,200:775)))),'r')
hold on;
plot((424-8-50+((200:775)*0.0108)),(C.b(400,200:775)/max(max(C.b(400,200:775)))),'g')
plot((424-8-50+((200:775)*0.0108)),(C.g(400,200:775)/max(max(C.g(400,200:775)))),'b')

% plot((424-8-50+((200:775)*0.0108)),(C.a(400,200:775)),'r')
% hold on;
% plot((424-8-50+((200:775)*0.0108)),(C.b(400,200:775)),'g')
% plot((424-8-50+((200:775)*0.0108)),(C.g(400,200:775)),'b')

vline(424-50,'k','Target Location')
%set(gca,'yscale','log')
xlim([418-50 425-50])
%ylim([1E-2 1]);
ylabel('Normalized Intensity [a. u.]')
xlabel('Machine z-location [cm]')
legend('Alpha','Beta','Gamma','Location','north');
hold off

%% Plot Data
%C target beta/gamma and gamma/alpha
 C.ga=C.g./C.a;
 C.gb=C.g./C.b;

fig=figure;
plot(374-7.5+((200:700)*0.0108),(C.ga(412,200:700)),'k')
hold on;
plot(374-7.5+((200:700)*0.0108),(C.gb(412,200:700)),'m')


%set(gca,'yscale','log')
xlim([368 375])
ylim([0 1]);
vline(374,'k','Target Location')
%ylim([1E-2 1]);
ylabel('Balmer Ratios [a. u.]')
xlabel('Machine z-location [cm]')
legend('Gamma/Alpha','Gamma/Beta','Location','north');
hold off

%%
%SiC target
fig=figure;
plot((374-7.71+((200:600)*0.0134)),(SiC.a(412,200:600)/max(max(SiC.a(412,200:600)))),'r')
hold on;
%plot((374-7.71+((200:600)*0.0134)),(SiC.b(412,200:600)/max(max(SiC.b(412,200:600)))),'g')
plot((374-6.25+((100:500)*0.0134)),(SiC.g(412,100:500)/max(max(SiC.g(412,100:500)))),'b')

% plot((374-7.71+((200:600)*0.0134)),(SiC.a(412,200:600)),'r')
% hold on;
% %plot((374-7.71+((200:600)*0.0134)),(SiC.b(412,200:600)),'g')
% plot((374-6.25+((100:500)*0.0134)),(SiC.g(412,100:500)),'b')

vline(374,'k','Target Location')
%set(gca,'yscale','log')
xlim([375-6 375])
%ylim([1E-2 1]);
ylabel('Normalized Intensity [a. u.]')
xlabel('DMachine z-location [cm]')
legend('Alpha','Gamma','Location','north');
hold off

%% Plot Data
%SiC target beta/gamma and gamma/alpha
 SiC.ga=SiC.g./SiC.a;
 SiC.gb=SiC.g./SiC.b;

fig=figure;
plot((374-7.80+((200:600)*0.0134)),(((SiC.g(412,77:477))./SiC.a(412,185:585))),'k')
hold on;
plot((374-7.80+((200:600)*0.0134)),(((SiC.g(412,77:477))./SiC.b(412,185:585))),'m')
%set(gca,'yscale','log')
xlim([375-6 375])
ylim([0 inf]);
vline(374,'k','Target Location')
%ylim([1E-2 1]);
ylabel('Balmer Ratios [a. u.]')
xlabel('Machine z-location [cm]')
legend('Gamma/Alpha','Gamma/Beta','Location','north');
hold off
%% Image Plots

figure;
figDeltaT=imagesc((C.a/max(max(C.a))), 'CDataMapping','scaled');
hold on
caxis([0 1])
colormap jet
c=colorbar;
ylabel(c, 'Normalized D_{\alpha} Intensity [a. u.]')
hline(400,'white','Line Traces')
ax.FontSize = 13;
xticks([]);
yticks([]);
%xlabel('Pixels','FontSize',13);
%ylabel('Pixels','FontSize',13);
hold off


%% Combined Plots 
% All material's gamma
figure;

plot((424-8-50+((200:775)*0.0108)),(C.g(400,200:775)/max(max(C.g(400,200:775)))),'k')
hold on;
plot(374-8.925+((200:700)*0.0134),(SS.g(335,200:700)/max(max(SS.g(335,200:700)))),'m')
plot((374-6.25+((100:500)*0.0134)),(SiC.g(412,100:500)/max(max(SiC.g(412,100:500)))),'c')
vline(374,'k','Target Location')
%set(gca,'yscale','log')
xlim([375-6 375])
%ylim([1E-2 1]);
ylabel('D_{\gamma} Intensities [a. u.]')
xlabel('Machine z-location [cm]')
legend('Graphite Gamma','SS Gamma','SiC Gamma','Location','north');
hold off

%% Combined Plots
% All materials gamma/alpha

fig=figure;
plot(374-7.5+((200:700)*0.0108),(C.ga(412,200:700)),'k')
hold on;
plot(374-9.1+((200:700)*0.0134),(SS.ga(335,200:700)),'m')
plot((374-7.80+((200:600)*0.0134)),(((SiC.g(412,77:477))./SiC.a(412,185:585))),'c')
xlim([375-6 375])
ylim([0 10]);
vline(374,'k','Target Location')
%ylim([1E-2 1]);
ylabel('D_{\gamma}/ D_{\alpha} Ratio')
xlabel('Machine z-location [cm]')
legend('Graphite Target','SS','SiC','Location','north');
hold off
