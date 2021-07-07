%% Plots Ion Flux Values from 8/2/17
%Coded by Josh Beers @ ORNL

%% Load in data

HeliconPower=load('C:\Users\cxe\Documents\Proto-MPEX\Analyzed Data\2017_08_02\Shot15951_HeliconPower');
% Run DLP_v5 for Shot 19543

%%
Te_K=Te{1,1}(1,:)*11604.3;  % 11604.3 K/eV
Ti{1,1}(1,:)=Te{1,1}(1,:);
k_b=8.6173324E-5; %eV/K
m_i=2*((931.5E6)/(2.998E8)^2); %eV/c^2
%For now the USER inputs Ti, eventually want code to find this Std_Ti=0; 
Ti_K{1,1}(1,:)=Ti{1,1}(1,:)*11604.3; %Ion Temp. in K
y=3; %3 for 1D adiabatic flow, 1 for isothermal flow
ye=5.5; %sheath transmission factor for electrons
yt=1.5; %sheath transmission factor for ions
%Gamma_se = Flux to sheath entrance

Gamma_se{1,1}(1,:)=0.61*Ni{1,1}(1,:).*((((k_b)*(Te{1,1}(1,:)+y*Ti_K{1,1}(1,:)))/(m_i)).^0.5) %(1/(m^2*s^1));


%% Plot

figure;
subplot(4,1,1); hold on
plot(HeliconPower(:,1),(HeliconPower(:,2)-10),'k');
ax = gca;
ax.FontSize = 13;
ylabel('Helicon Power [kW]', 'FontSize', 13);
xlim([4.2 4.3]);
ylim([90 110]);
xtic=([]);

subplot(4,1,2)
plot(time{1,1}(1,:),Ni{1,1}(1,:),'k');
ax = gca;
ax.FontSize = 13;
ylabel('N_e [m^{-2}s^{-1}]', 'FontSize', 13);
xlim([4.2 4.3]);
%ylim([0 inf]);
xtick=([]);

subplot(4,1,3)
plot(time{1,1}(1,:),Te{1,1}(1,:),'k');
ax = gca;
ax.FontSize = 13;
ylabel('T_e [eV]', 'FontSize', 13);
xlim([4.2 4.3]);
%ylim([0 inf]);
xtick=([]);

subplot(4,1,4)
plot(time{1,1}(1,:),Gamma_se{1,1}(1,:),'k');
ax = gca;
ax.FontSize = 13;
ylabel('Ion Flux [m^{-2}s^{-1}]', 'FontSize', 13);
xlabel('Time [s]', 'FontSize', 13);
xlim([4.2 4.3]);
%ylim([0 inf]);
%xtick=([]);
hold off

%% Plot only flux

figure
plot(time{1,1}(1,:),Gamma_se{1,1}(1,:),'k');
ax = gca;
ax.FontSize = 13;
ylabel('Ion Flux [m^{-2}s^{-1}]', 'FontSize', 13);
xlabel('Time [s]', 'FontSize', 13);
xlim([4.0 4.7]);
%ylim([0 inf]);
%xtick=([]);

 







