%% Read in data

% cleanup
% 
% fileID = fopen('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_HighDensity_Plasma.txt','r');
% %fileID = fopen('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Helicon\Data Out\Beers Outputs\Beers_Helicon_3D_100kW_LowDensity_Plasma.txt','r');
% Data{1} = textscan(fileID, '%f');
% fclose(fileID);
% 
% 
% 
% Data=reshape(Data,17,[]);
% Dataorg=Data;
% 
% 
%%

%xfit=abs(Data{1,1}(:,2)*(6/0.06));
xfit=[0:0.01:7];
xfit=[0, 1, 2, 3, 4, 5, 6, 6.25, 7]
       a1 =       19.95;
       b1 =      0.5664;
       c1 =     -0.4981;
       a2 =       15.98;
       b2 =      0.7021;
       c2 =       2.234;
       a3 =       25.52;
       b3 =       2.555;
       c3 =      0.5101;
       a4 =       25.39;
       b4 =       2.577;
       c4 =       3.558;
       a5 =      0.3901;
       b5 =       5.271;
       c5 =     -0.8918;
yfit=a1*sin(b1*xfit+c1) + a2*sin(b2*xfit+c2) + a3*sin(b3*xfit+c3) + a4*sin(b4*xfit+c4) + a5*sin(b5*xfit+c5);

figure
plot(xfit,yfit)
ax = gca;
ax.FontSize = 13;
title('DLP 2.5 Startup Data','FontSize',13);
xlabel('Radius [cm]','FontSize',13);
ylabel('Temperature Profile Shape','FontSize',13);
xlim([0 inf]);
ylim([0 inf]);
set(gcf,'color','w')
hold off;

%
Data{1,1}(:,15)=yfit;
Data{1,1}(:,16)=yfit;
