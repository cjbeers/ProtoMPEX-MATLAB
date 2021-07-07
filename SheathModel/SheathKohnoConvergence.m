
d=0.005;

LayerData1=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle1.txt');
LayerData1=table2array(LayerData1);

LayerData2=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle2.txt');
LayerData2=table2array(LayerData2);

LayerData3=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle3.txt');
LayerData3=table2array(LayerData3);

LayerData4=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle4.txt');
LayerData4=table2array(LayerData4);

LayerData5=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle5.txt');
LayerData5=table2array(LayerData5);

LayerData6=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle6.txt');
LayerData6=table2array(LayerData6);

LayerData7=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle7.txt');
LayerData7=table2array(LayerData7);

LayerData8=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle8.txt');
LayerData8=table2array(LayerData8);

LayerData9=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle9.txt');
LayerData9=table2array(LayerData9);


Max(1,1)=max(abs((LayerData1(:,3))))*d;
Max(1,2)=max(abs((LayerData2(:,3))))*d;
Max(1,3)=max(abs((LayerData3(:,3))))*d;
Max(1,4)=max(abs((LayerData4(:,3))))*d;
Max(1,5)=max(abs((LayerData5(:,3))))*d;
Max(1,6)=max(abs((LayerData6(:,3))))*d;
Max(1,7)=max(abs((LayerData7(:,3))))*d;
Max(1,8)=max(abs((LayerData8(:,3))))*d;
Max(1,9)=max(abs((LayerData9(:,3))))*d;

%% plots

% plot(Max)
% xlabel('Iteration number')
% ylabel('Max voltage in layer [V]')
% set(gcf,'color','w')
% set(gca,'fontsize',15)


%%
d=0.0002;
LayerData1=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle1v31.txt');
LayerData1=table2array(LayerData1);

LayerData2=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle2v31.txt');
LayerData2=table2array(LayerData2);

LayerData3=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle3v31.txt');
LayerData3=table2array(LayerData3);

LayerData4=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle4v31.txt');
LayerData4=table2array(LayerData4);

LayerData5=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle5v31.txt');
LayerData5=table2array(LayerData5);

LayerData6=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle6v31.txt');
LayerData6=table2array(LayerData6);

LayerData7=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle7v31.txt');
LayerData7=table2array(LayerData7);

LayerData8=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle8v31.txt');
LayerData8=table2array(LayerData8);

% LayerData9=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle9v8.txt');
% LayerData9=table2array(LayerData9);

% ii=1;
% for jj=1:100
%     
%     Inputs.Y(jj,1)=LayerData1(ii,2);
%     
%    Inputs.VlayerInitial1(jj,1)=trapz(LayerData1(ii:ii+49,3),LayerData1(ii:ii+49,1));
%    Inputs.VlayerInitial2(jj,1)=trapz(LayerData2(ii:ii+49,3),LayerData2(ii:ii+49,1));
%    Inputs.VlayerInitial3(jj,1)=trapz(LayerData3(ii:ii+49,3),LayerData3(ii:ii+49,1));
%    Inputs.VlayerInitial4(jj,1)=trapz(LayerData4(ii:ii+49,3),LayerData4(ii:ii+49,1));
%    %Inputs.VlayerInitial5(jj,1)=trapz(LayerData5(ii:ii+49,3),LayerData5(ii:ii+49,1));
%    ii=ii+50;
%        
%     
% end

Inputs.Y=LayerData1(:,2);

% Max(1,1)=max(abs(Inputs.VlayerInitial1))*d;
% Max(1,2)=max(abs((Inputs.VlayerInitial2)))*d;
% Max(1,3)=max(abs((Inputs.VlayerInitial3)))*d;
% Max(1,4)=max(abs((Inputs.VlayerInitial4)))*d;
%Max(1,5)=max(abs((Inputs.VlayerInitial5)))*d;
Max(1,1)=max(abs((LayerData1(:,3))))*d;
Max(1,2)=max(abs((LayerData2(:,3))))*d;
Max(1,3)=max(abs((LayerData3(:,3))))*d;
Max(1,4)=max(abs((LayerData4(:,3))))*d;
Max(1,5)=max(abs((LayerData5(:,3))))*d;
Max(1,6)=max(abs((LayerData6(:,3))))*d;
Max(1,7)=max(abs((LayerData7(:,3))))*d;
Max(1,8)=max(abs((LayerData8(:,3))))*d;
% Max(1,9)=max(abs((LayerData9(:,3))))*d;

% V(:,1)=(abs(Inputs.VlayerInitial1))*d;
% V(:,2)=(abs(Inputs.VlayerInitial2))*d;
% V(:,3)=(abs(Inputs.VlayerInitial3))*d;
% V(:,4)=(abs(Inputs.VlayerInitial4))*d;
%V(:,5)=(abs(Inputs.VlayerInitial5))*d;
V(:,1)=(abs((LayerData1(:,3))))*d;
V(:,2)=(abs((LayerData2(:,3))))*d;
V(:,3)=(abs((LayerData3(:,3))))*d;
V(:,4)=(abs((LayerData4(:,3))))*d;
V(:,5)=(abs((LayerData5(:,3))))*d;
V(:,6)=(abs((LayerData6(:,3))))*d;
V(:,7)=(abs((LayerData7(:,3))))*d;
V(:,8)=(abs((LayerData8(:,3))))*d;
% V(:,9)=(abs((LayerData9(:,3))))*d;


%% plots
figure
plot(Max,'k')
xlabel('Iteration number')
ylabel('Max voltage in layer [V]')
set(gcf,'color','w')
set(gca,'fontsize',15)

figure
plot(V(:,1))
hold on
plot(V(:,2))
plot(V(:,3))
plot(V(:,4))
%plot(V(:,5))
% plot(V(:,6))
% plot(V(:,7))
% plot(V(:,8))
legend('Iter1','Iter2','Iter3','Iter4','Iter5','Iter6','Iter7','Iter8')
xlabel('Length Along Y-direction')
ylabel('Voltage in layer [V]')
set(gcf,'color','w')
set(gca,'fontsize',15)


%%
d=0.0002;
LayerData1=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle1v31.txt');
LayerData1=table2array(LayerData1);

LayerData2=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle2v32.txt');
LayerData2=table2array(LayerData2);

LayerData3=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle3v32.txt');
LayerData3=table2array(LayerData3);

LayerData4=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle4v32.txt');
LayerData4=table2array(LayerData4);

LayerData5=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle5v32.txt');
LayerData5=table2array(LayerData5);

LayerData6=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle6v32.txt');
LayerData6=table2array(LayerData6);

LayerData7=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle7v32.txt');
LayerData7=table2array(LayerData7);

LayerData8=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle8v32.txt');
LayerData8=table2array(LayerData8);

% LayerData9=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle9v8.txt');
% LayerData9=table2array(LayerData9);

% ii=1;
% for jj=1:100
%     
%     Inputs.Y(jj,1)=LayerData1(ii,2);
%     
%    Inputs.VlayerInitial1(jj,1)=trapz(LayerData1(ii:ii+49,3),LayerData1(ii:ii+49,1));
%    Inputs.VlayerInitial2(jj,1)=trapz(LayerData2(ii:ii+49,3),LayerData2(ii:ii+49,1));
%    Inputs.VlayerInitial3(jj,1)=trapz(LayerData3(ii:ii+49,3),LayerData3(ii:ii+49,1));
%    Inputs.VlayerInitial4(jj,1)=trapz(LayerData4(ii:ii+49,3),LayerData4(ii:ii+49,1));
%    %Inputs.VlayerInitial5(jj,1)=trapz(LayerData5(ii:ii+49,3),LayerData5(ii:ii+49,1));
%    ii=ii+50;
%        
%     
% end

Inputs.Y=LayerData1(:,2);

% Max(1,1)=max(abs(Inputs.VlayerInitial1))*d;
% Max(1,2)=max(abs((Inputs.VlayerInitial2)))*d;
% Max(1,3)=max(abs((Inputs.VlayerInitial3)))*d;
% Max(1,4)=max(abs((Inputs.VlayerInitial4)))*d;
%Max(1,5)=max(abs((Inputs.VlayerInitial5)))*d;
Max1(1,1)=max(abs((LayerData1(:,3))))*d;
Max1(1,2)=max(abs((LayerData2(:,3))))*d;
Max1(1,3)=max(abs((LayerData3(:,3))))*d;
Max1(1,4)=max(abs((LayerData4(:,3))))*d;
Max1(1,5)=max(abs((LayerData5(:,3))))*d;
Max1(1,6)=max(abs((LayerData6(:,3))))*d;
Max1(1,7)=max(abs((LayerData7(:,3))))*d;
Max1(1,8)=max(abs((LayerData8(:,3))))*d;
% Max1(1,9)=max(abs((LayerData9(:,3))))*d;

% V(:,1)=(abs(Inputs.VlayerInitial1))*d;
% V(:,2)=(abs(Inputs.VlayerInitial2))*d;
% V(:,3)=(abs(Inputs.VlayerInitial3))*d;
% V(:,4)=(abs(Inputs.VlayerInitial4))*d;
%V(:,5)=(abs(Inputs.VlayerInitial5))*d;
V1(:,1)=(abs((LayerData1(:,3))))*d;
V1(:,2)=(abs((LayerData2(:,3))))*d;
V1(:,3)=(abs((LayerData3(:,3))))*d;
V1(:,4)=(abs((LayerData4(:,3))))*d;
V1(:,5)=(abs((LayerData5(:,3))))*d;
V1(:,6)=(abs((LayerData6(:,3))))*d;
V1(:,7)=(abs((LayerData7(:,3))))*d;
V1(:,8)=(abs((LayerData8(:,3))))*d;
% V(:,9)=(abs((LayerData9(:,3))))*d;

%% plots

x=linspace(1,size(V1,2),8);
%y=linspace(33.619,33.619,8);
y=linspace(124.2388,124.2388,8);

figure
plot(Max,'--*k')
hold on
plot(Max1,'--om')
plot(x,y,'k')
xlabel('Iteration number')
ylabel('Max voltage in layer [V]')
legend('Kohno 2017 Fit','Myra 2017 Fit','Kohno 2017 Data')
set(gcf,'color','w')
set(gca,'fontsize',15)
ylim([120 130])
xlim([1 8])

%%

%1kA/m case
% Re=[1.695483864
% 1.54986098
% 1.512054318
% 1.499622874
% 1.495612488
% 1.494336847
% 1.493934128
% 1.493807433];
% 
% Re1=[1.676895746
% 1.539696092
% 1.49653944
% 1.482550272
% 1.478068709
% 1.476650667
% 1.476205195
% 1.476065738];
% 
% Im=[0.536380216
% 0.461475614
% 0.442580909
% 0.436421979
% 0.434440922
% 0.433811378
% 0.433612692
% 0.433550191];
% 
% Im1=[0.516729442
% 0.444376987
% 0.422515956
% 0.415524921
% 0.413295231
% 0.412590729
% 0.412369513
% 0.41230027];

Re=[3.818532274
3.900814792
3.900232308
3.900106044
3.900076716
3.900071449
3.90007054
3.900070385];

Re1=[3.606614698
3.681542901
3.681008018
3.680892081
3.680865151
3.680860316
3.680859481
3.680859339];

Im=[1.772613747
1.819661482
1.819333768
1.819262719
1.819246216
1.819243252
1.819242741
1.819242653];

Im1=[1.842631863
1.900798507
1.900382435
1.900292251
1.900271304
1.900267543
1.900266894
1.900266783];


%%
x=linspace(1,8,8);
% yRe=linspace(1.501,1.501,8);
% yIm=linspace(0.43797,0.43797,8);
yRe=linspace(3.90108,3.90108,8);
yIm=linspace(1.8215,1.8215,8);
Colors=distinguishable_colors(6);

figure
plot(x,Re,'-p','color',[Colors(1,1) Colors(1,2) Colors(1,3)])
hold on
plot(x,Re1,'-s','color',[Colors(2,1) Colors(2,2) Colors(2,3)])
plot(x,yRe,'-+','color',[Colors(3,1) Colors(3,2) Colors(3,3)])
plot(x,Im,'--','color',[Colors(4,1) Colors(4,2) Colors(4,3)])
plot(x,Im1,'-d','color',[Colors(5,1) Colors(5,2) Colors(5,3)])
plot(x,yIm,'-*','color',[Colors(6,1) Colors(6,2) Colors(6,3)])
hA1=legend('Kohno 2017 Fit $Re(\hat{z}_{sh})$','Myra 2017 Fit $Re(\hat{z}_{sh})$','Kohno 2017 $Re(\hat{z}_{sh})$ Data','Kohno 2017 Fit $Im(\hat{z}_{sh})$','Myra 2017 Fit $Im(\hat{z}_{sh})$','Kohno 2017 $Im(\hat{z}_{sh})$ Data','Interpreter','latex','Location','eastoutside');
xlabel('Iteration number')
ylabel('Max $\hat{z}_{sh}$','Interpreter','latex')
set(gcf,'color','w')
set(gca,'fontsize',15)
ylim([0 5])
xlim([1 inf])

%% For plots 6-10

d=0.0002;
LayerData1=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle1v33.txt');
LayerData1=table2array(LayerData1);

LayerData2=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle2v33.txt');
LayerData2=table2array(LayerData2);

LayerData3=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle3v33.txt');
LayerData3=table2array(LayerData3);

LayerData4=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle4v33.txt');
LayerData4=table2array(LayerData4);

LayerData5=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle5v33.txt');
LayerData5=table2array(LayerData5);

LayerData6=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle6v33.txt');
LayerData6=table2array(LayerData6);

LayerData7=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle7v33.txt');
LayerData7=table2array(LayerData7);

LayerData8=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle8v33.txt');
LayerData8=table2array(LayerData8);

% LayerData9=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle9v8.txt');
% LayerData9=table2array(LayerData9);

% ii=1;
% for jj=1:100
%     
%     Inputs.Y(jj,1)=LayerData1(ii,2);
%     
%    Inputs.VlayerInitial1(jj,1)=trapz(LayerData1(ii:ii+49,3),LayerData1(ii:ii+49,1));
%    Inputs.VlayerInitial2(jj,1)=trapz(LayerData2(ii:ii+49,3),LayerData2(ii:ii+49,1));
%    Inputs.VlayerInitial3(jj,1)=trapz(LayerData3(ii:ii+49,3),LayerData3(ii:ii+49,1));
%    Inputs.VlayerInitial4(jj,1)=trapz(LayerData4(ii:ii+49,3),LayerData4(ii:ii+49,1));
%    %Inputs.VlayerInitial5(jj,1)=trapz(LayerData5(ii:ii+49,3),LayerData5(ii:ii+49,1));
%    ii=ii+50;
%        
%     
% end

Inputs.Y=LayerData1(:,2);

% Max(1,1)=max(abs(Inputs.VlayerInitial1))*d;
% Max(1,2)=max(abs((Inputs.VlayerInitial2)))*d;
% Max(1,3)=max(abs((Inputs.VlayerInitial3)))*d;
% Max(1,4)=max(abs((Inputs.VlayerInitial4)))*d;
%Max(1,5)=max(abs((Inputs.VlayerInitial5)))*d;
Max(1,1)=max(abs((LayerData1(:,3))))*d;
Max(1,2)=max(abs((LayerData2(:,3))))*d;
Max(1,3)=max(abs((LayerData3(:,3))))*d;
Max(1,4)=max(abs((LayerData4(:,3))))*d;
Max(1,5)=max(abs((LayerData5(:,3))))*d;
Max(1,6)=max(abs((LayerData6(:,3))))*d;
Max(1,7)=max(abs((LayerData7(:,3))))*d;
Max(1,8)=max(abs((LayerData8(:,3))))*d;
% Max(1,9)=max(abs((LayerData9(:,3))))*d;

% V(:,1)=(abs(Inputs.VlayerInitial1))*d;
% V(:,2)=(abs(Inputs.VlayerInitial2))*d;
% V(:,3)=(abs(Inputs.VlayerInitial3))*d;
% V(:,4)=(abs(Inputs.VlayerInitial4))*d;
%V(:,5)=(abs(Inputs.VlayerInitial5))*d;
V(:,1)=(abs((LayerData1(:,3))))*d;
V(:,2)=(abs((LayerData2(:,3))))*d;
V(:,3)=(abs((LayerData3(:,3))))*d;
V(:,4)=(abs((LayerData4(:,3))))*d;
V(:,5)=(abs((LayerData5(:,3))))*d;
V(:,6)=(abs((LayerData6(:,3))))*d;
V(:,7)=(abs((LayerData7(:,3))))*d;
V(:,8)=(abs((LayerData8(:,3))))*d;
% V(:,9)=(abs((LayerData9(:,3))))*d;


%% plots
figure
plot(Max,'k')
xlabel('Iteration number')
ylabel('Max voltage in layer [V]')
set(gcf,'color','w')
set(gca,'fontsize',15)

figure
plot(V(:,1))
hold on
plot(V(:,2))
plot(V(:,3))
plot(V(:,4))
%plot(V(:,5))
% plot(V(:,6))
% plot(V(:,7))
% plot(V(:,8))
legend('Iter1','Iter2','Iter3','Iter4','Iter5','Iter6','Iter7','Iter8')
xlabel('Length Along Y-direction')
ylabel('Voltage in layer [V]')
set(gcf,'color','w')
set(gca,'fontsize',15)


%%
d=0.0002;
LayerData1=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle1v33.txt');
LayerData1=table2array(LayerData1);

LayerData2=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle2v34.txt');
LayerData2=table2array(LayerData2);

LayerData3=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle3v34.txt');
LayerData3=table2array(LayerData3);

LayerData4=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle4v34.txt');
LayerData4=table2array(LayerData4);

LayerData5=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle5v34.txt');
LayerData5=table2array(LayerData5);

LayerData6=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle6v34.txt');
LayerData6=table2array(LayerData6);

LayerData7=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle7v34.txt');
LayerData7=table2array(LayerData7);

LayerData8=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle8v34.txt');
LayerData8=table2array(LayerData8);

% LayerData9=readtable('C:\Users\cxe\Documents\Proto-MPEX\COMSOLmodel\Kohno 2D verification\Outputs\SheathLayerMiddle9v8.txt');
% LayerData9=table2array(LayerData9);

% ii=1;
% for jj=1:100
%     
%     Inputs.Y(jj,1)=LayerData1(ii,2);
%     
%    Inputs.VlayerInitial1(jj,1)=trapz(LayerData1(ii:ii+49,3),LayerData1(ii:ii+49,1));
%    Inputs.VlayerInitial2(jj,1)=trapz(LayerData2(ii:ii+49,3),LayerData2(ii:ii+49,1));
%    Inputs.VlayerInitial3(jj,1)=trapz(LayerData3(ii:ii+49,3),LayerData3(ii:ii+49,1));
%    Inputs.VlayerInitial4(jj,1)=trapz(LayerData4(ii:ii+49,3),LayerData4(ii:ii+49,1));
%    %Inputs.VlayerInitial5(jj,1)=trapz(LayerData5(ii:ii+49,3),LayerData5(ii:ii+49,1));
%    ii=ii+50;
%        
%     
% end

Inputs.Y=LayerData1(:,2);

% Max(1,1)=max(abs(Inputs.VlayerInitial1))*d;
% Max(1,2)=max(abs((Inputs.VlayerInitial2)))*d;
% Max(1,3)=max(abs((Inputs.VlayerInitial3)))*d;
% Max(1,4)=max(abs((Inputs.VlayerInitial4)))*d;
%Max(1,5)=max(abs((Inputs.VlayerInitial5)))*d;
Max1(1,1)=max(abs((LayerData1(:,3))))*d;
Max1(1,2)=max(abs((LayerData2(:,3))))*d;
Max1(1,3)=max(abs((LayerData3(:,3))))*d;
Max1(1,4)=max(abs((LayerData4(:,3))))*d;
Max1(1,5)=max(abs((LayerData5(:,3))))*d;
Max1(1,6)=max(abs((LayerData6(:,3))))*d;
Max1(1,7)=max(abs((LayerData7(:,3))))*d;
Max1(1,8)=max(abs((LayerData8(:,3))))*d;
% Max1(1,9)=max(abs((LayerData9(:,3))))*d;

% V(:,1)=(abs(Inputs.VlayerInitial1))*d;
% V(:,2)=(abs(Inputs.VlayerInitial2))*d;
% V(:,3)=(abs(Inputs.VlayerInitial3))*d;
% V(:,4)=(abs(Inputs.VlayerInitial4))*d;
%V(:,5)=(abs(Inputs.VlayerInitial5))*d;
V1(:,1)=(abs((LayerData1(:,3))))*d;
V1(:,2)=(abs((LayerData2(:,3))))*d;
V1(:,3)=(abs((LayerData3(:,3))))*d;
V1(:,4)=(abs((LayerData4(:,3))))*d;
V1(:,5)=(abs((LayerData5(:,3))))*d;
V1(:,6)=(abs((LayerData6(:,3))))*d;
V1(:,7)=(abs((LayerData7(:,3))))*d;
V1(:,8)=(abs((LayerData8(:,3))))*d;
% V(:,9)=(abs((LayerData9(:,3))))*d;

%% plots

x=linspace(1,size(V1,2),8);
y=linspace(8.619,8.619,8);

figure
plot(Max,'--*k')
hold on
plot(Max1,'--om')
plot(x,y,'k')
xlabel('Iteration number')
ylabel('Max voltage in layer [V]')
legend('Kohno 2017 Fit','Myra 2017 Fit','Kohno 2017 Data')
set(gcf,'color','w')
set(gca,'fontsize',15)
ylim([8 14])
xlim([1 8])

%%
%10 A/m case
Re=[0.716082588
0.680474985
0.67853752
0.678436436
0.678431302
0.678431044
0.678431031
0.678431031];

Re1=[0.751420397
0.716407909
0.71462406
0.714537023
0.714532885
0.714532692
0.714532683
0.714532682
];

Im=[0.448898595
0.403263462
0.40089269
0.400769362
0.400763098
0.400762785
0.400762769
0.400762768
];

Im1=[0.468118329
0.422177324
0.419920547
0.419810613
0.419805387
0.419805142
0.419805131
0.41980513
];


%%
x=linspace(1,8,8);
yRe=linspace(0.67792,0.67792,8);
yIm=linspace(0.4017,0.4017,8);
Colors=distinguishable_colors(6);

figure
plot(x,Re,'-p','color',[Colors(1,1) Colors(1,2) Colors(1,3)])
hold on
plot(x,Re1,'-s','color',[Colors(2,1) Colors(2,2) Colors(2,3)])
plot(x,yRe,'-+','color',[Colors(3,1) Colors(3,2) Colors(3,3)])
plot(x,Im,'--','color',[Colors(4,1) Colors(4,2) Colors(4,3)])
plot(x,Im1,'-d','color',[Colors(5,1) Colors(5,2) Colors(5,3)])
plot(x,yIm,'-*','color',[Colors(6,1) Colors(6,2) Colors(6,3)])
hA1=legend('Kohno 2017 Fit $Re(\hat{z}_{sh})$','Myra 2017 Fit $Re(\hat{z}_{sh})$','Kohno 2017 $Re(\hat{z}_{sh})$ Data','Kohno 2017 Fit $Im(\hat{z}_{sh})$','Myra 2017 Fit $Im(\hat{z}_{sh})$','Kohno 2017 $Im(\hat{z}_{sh})$ Data','Interpreter','latex','Location','eastoutside');
xlabel('Iteration number')
ylabel('Max $\hat{z}_{sh}$','Interpreter','latex')
set(gcf,'color','w')
set(gca,'fontsize',15)
ylim([0 1])
xlim([1 inf])

%%

Colors=distinguishable_colors(3);

figure
plot(COMSOL.X,COMSOL.Y/10,'.-k')
hold on
%plot(Stix.X,Stix.Y/10,'-s','color',[Colors(2,1) Colors(2,2) Colors(2,3)])
plot(Kohno.X,Kohno.Y,'-m')
set(gcf,'color','w')
set(gca,'fontsize',15)
legend('COMSOL','Kohno 2017 Data')
ylabel({'$Im(E_{\parallel})/K_{max}$';' Field Amplitude (V/m)'},'Interpreter','latex')
xlabel('Distance (m)')
