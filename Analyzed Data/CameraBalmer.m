%% Plots Balmer data from FVC data for C, SS, and SiC targets
%Coded by Josh Beers @ ORNL

%% Load in data

%load('CameraBalmer.mat')

%% Plot Data
%SS target
fig=figure;
plot(((200:700)*0.0134),(SS.a(335,200:700)/max(max(SS.a(335,200:700)))),'k')
hold on;
plot(((200:700)*0.0134),(SS.b(335,200:700)/max(max(SS.b(335,200:700)))),'m')
plot(((200:700)*0.0134),(SS.y(335,200:700)/max(max(SS.y(335,200:700)))),'c')
%set(gca,'yscale','log')
xlim([2 9])
%ylim([1E-2 1]);
ylabel('Normalized Data [Ab. Units]')
xlabel('Distance [cm]')
legend('Alpha','Beta','Gamma','Location','north');
hold off

%%
%C target
fig=figure;
plot(((200:750)*0.0108),(C.a(335,200:750)/max(max(C.a(335,200:750)))),'k')
hold on;
plot(((200:750)*0.0108),(C.b(335,200:750)/max(max(C.b(335,200:750)))),'m')
plot(((200:750)*0.0108),(C.y(335,200:750)/max(max(C.y(335,200:750)))),'c')
%set(gca,'yscale','log')
xlim([2 9])
%ylim([1E-2 1]);
ylabel('Normalized Data [Ab. Units]')
xlabel('Distance [cm]')
legend('Alpha','Beta','Gamma','Location','north');
hold off