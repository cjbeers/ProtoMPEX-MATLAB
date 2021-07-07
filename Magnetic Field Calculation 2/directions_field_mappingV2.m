%Running: magnetic field mapping + the magnetic field strength along the
%machine length
%V2 makes the magnetic field go from only the dump tank to the ballest tank

%Creates full device parameters for GITR simulation
CreateGITRInputs=1;

%step 1: load proto_mpex_12coils_flat_field_highdens.mat
load('proto_mpex_13coils_flat_field_highdens.mat');

%step 2: load shot number and associated current
KnownFields = 1;

if KnownFields == 0

shot = input('Choose shot to analyze - enter shot number only ' ); 
if shot > 15100 % Need to edit get_proto_geometry beforehand
    [helicon_current,current_A,current_B,config,skimmer,current_C] = get_Proto_current(shot);
else
    [helicon_current,current_A,current_B,config,skimmer,current_C] = get_Proto_current(shot);
end

elseif KnownFields == 1
    
   helicon_current = 320; %Coils 3,4 PS3 %Window limiting
   current_A = 6000; %Coils 9-13  PS2
   current_B = 6500; %Coils 1,6 PS1
   current_C = 530;  %Coil 2 TR1
   current_D = 3500;  %Coil 7,8 TR2
   
%    helicon_current = 650; %Coils 3,4 PS3
%    current_A = 2500; %Coils 9-13  PS2
%    current_B = 6500; %Coils 1,6 PS1
%    current_C = 530;  %Coil 2 TR1
%    current_D = 4500;  %Coil 7,8 TR2

%    helicon_current = 380; %Coils 3,4 PS3 %Upstream limiting
%    current_A = 6000; %Coils 9-13  PS2
%    current_B = 4000; %Coils 1,6 PS1
%    current_C = 0;  %Coil 2 TR1
%    current_D = 3500;  %Coil 7,8 TR2

skimmer = 1;
   config = 'flat3';
   add_reflector = 1;
   
else
    disp('Error')
    return;    
end

target_position = 3;   %target position 1: 7.5, 2: 11.5, 3: Off center 11.5
sleeve = 1;

current_in = [helicon_current, current_A,current_B, current_C, current_D];
[fil,cur] = setup_Proto_coils(current_in,config); %will reassign cur based on shot. 

%step 2: run geom_coaxial_coilsm.m
[Brg,Bzg,Atg,avec,zvec]=geom_coaxial_coilsm(z0,cl,rr1,rr2,nturns,nlayers,zmax,rmax,nz,nr);

%assign variables to avoid renumbering/capitalization issues
brg=Brg;
bzg=Bzg;
atg=Atg;

%run bprofm_12_coils_geo.m
    fontsize=14;
    fontweight='normal';
    ant_mid=.5*(z0(3)+cl(3)+z0(4));
    window_x=[-.15,-.15,.15,.15,-.15]+ant_mid;
    window_y=[-.0625,.0625,.0625,-.0626,-.0625];
    skimmer_x=[-.005,-.005,.005,.005,-.005]+z0(5)+cl(5)/2+.0702;
    skimmer_y1=[.070/2,.15/2,.15/2,.070/2,.070/2];
    skimmer_y2=-skimmer_y1;
    tube_x=[0,0,24*.0254,24*.0254,0]+z0(7)-.0254;
    tube_y=[-.04,.04,.04,-.04,-.04];
    ant_x=[2.03,2.18,2.18,2.03,2.03];
    ant_y=[.028,.028,.034,.034,.028];
    lhres=.1650;
    b_lh_x=[0,1];
    b_lh_y=[1,1]*lhres;
    %rlocs=[0.01:0.001:0.07];
    %$rlocs=[.01,.02,.03,.04,.05,.0525,.0575];
    rlocs=[.01,.02,.03,.04,.05,.06,.0625 .07];
    
    geop=get_Proto_geometry(0,0,skimmer,target_position,sleeve,add_reflector);

    [br,bz,psi]=B_coaxial_coilsm(brg,bzg,atg,avec,cur);

    %bt is the total B field using the B at z and B at r points at the points avec and zvec 
    bt=sqrt(br.^2+bz.^2);
    bt0=bt(1,:);
    bta=bt(1,:);
    bma=max(bta);


    %xloc_left=find(zvec < tube_x(1));
    xloc_left=find(zvec<1.58);
    xloc_left=max(xloc_left);
    xloc_right=find(zvec >1.8);
    xloc_right=min(xloc_right);
    bmina=min(bta(xloc_left:xloc_right));
    bmloc=find(bta(xloc_left:xloc_right)==bmina)+xloc_left-1;
    disp(bta(bmloc))
    m1_x=[z0(1),z0(1)+cl(1),z0(1)+cl(1),z0(1),z0(1)];
    m2_x=[z0(2),z0(2)+cl(2),z0(2)+cl(2),z0(2),z0(2)];
    m3_x=[z0(3),z0(3)+cl(3),z0(3)+cl(3),z0(3),z0(3)];
    m4_x=[z0(4),z0(4)+cl(4),z0(4)+cl(4),z0(4),z0(4)];
    m5_x=[z0(5),z0(5)+cl(5),z0(5)+cl(5),z0(5),z0(5)];
    m6_x=[z0(6),z0(6)+cl(6),z0(6)+cl(6),z0(6),z0(6)];
    m7_x=[z0(7),z0(7)+cl(7),z0(7)+cl(7),z0(7),z0(7)];
    m8_x=[z0(8),z0(8)+cl(8),z0(8)+cl(8),z0(8),z0(8)];
    m9_x=[z0(9),z0(9)+cl(9),z0(9)+cl(9),z0(9),z0(9)];
    m10_x=[z0(10),z0(10)+cl(10),z0(10)+cl(10),z0(10),z0(10)];
    m11_x=[z0(11),z0(11)+cl(11),z0(11)+cl(11),z0(11),z0(11)];
    m12_x=[z0(12),z0(12)+cl(12),z0(12)+cl(12),z0(12),z0(12)];
    m13_x=[z0(13),z0(13)+cl(13),z0(13)+cl(13),z0(13),z0(13)];


    m_y=[0,0,bma,bma,0];
    vals=psivals(avec,zvec,psi,zvec(bmloc),rlocs);
    disp(zvec(bmloc))
   
    zmax=4.5;
    PSIarray=psi;
    
    
%    rvsZ=contourdata; %gets r vs. z for the LCFS
    %% Plots flux tube and B field
    
    offset=0.0;
    
    figure;
    subplot(2,1,1);
    hold off
    [cc hh]=contour(zvec(1:end,1:end-offset),avec(1:end),PSIarray(1:end,offset+1:end),vals,'k');
    hold on
    [cc hh]=contour(zvec(:,1:end-offset),avec,PSIarray(:,offset+1:end),[vals(7),vals(7)],'--m','LineWidth',2);
    set(gcf,'renderer','zbuffer')
    plot(geop.vessel.z-offset,geop.vessel.r,'k',tube_x-offset,tube_y,'c--',skimmer_x-offset,skimmer_y1,'r--',skimmer_x-offset,skimmer_y2,'r--',window_x-offset,window_y,'c',geop.target.z-offset,geop.target.r,'k');
    plot(geop.target.z*[1,1]-offset,geop.target.r*[0,1],'k','linewidth',3)
    grid
    title('Flux tube mapping');
    h=ylabel('R  (m)');
    set(h,'fontsize',15);
    h=xlabel('Z  (m)');
    set(h,'fontsize',15);
    axis([0,zmax,0,.2])
    set(gca,'Fontsize',15);
    set(gcf,'color','w')
    %set(findall(gcf,'type','text'),'fontsize',fontsize,'fontweight',fontweight)
    
  
    subplot(2,1,2)
    hold off
    plot(zvec(1,1:end),bt(1,1:end),'m',m1_x-offset,m_y,'k',m2_x-offset,m_y,'k',m3_x-offset,m_y,'k',m4_x-offset,m_y,'k',...
                          m5_x-offset,m_y,'k',m6_x-offset,m_y,'k',m7_x-offset,m_y,'k',m8_x-offset,m_y,'k',...
                          m9_x-offset,m_y,'k',m10_x-offset,m_y,'k',m11_x-offset,m_y,'k',m12_x-offset,m_y,'k',m13_x-offset,m_y,'k',geop.target.z-offset,geop.target.r,'k','linewidth',2);
    hold on
    plot(geop.target.z*[1,1]-offset,geop.target.r*[0,offset],'k','linewidth',3)
    grid
    axis([0, zmax, 0, bma])
    title('Axial magnetic field');
    h=ylabel('|B| (T)','fontsize',15,'Color','k');
    %set(h,'fontsize',15,'fontweight','bold');
    h=xlabel('Z (m)','fontsize',15,'Color','k');
    set(gcf,'color','w')
    %set(h,'fontsize',18,'fontweight','bold');

    text(m1_x(1)+.15*cl(1)-offset,0.05*bma,'1','fontsize',14,'Color','k');
    text(m2_x(1)+.15*cl(1)-offset,0.05*bma,'2','fontsize',14,'Color','k');
    text(m3_x(1)+.15*cl(1)-offset,0.05*bma,'3','fontsize',14,'Color','k');
    text(m4_x(1)+.15*cl(1)-offset,0.05*bma,'4','fontsize',14,'Color','k');
    text(m5_x(1)+.15*cl(1)-offset,0.05*bma,'5','fontsize',14,'Color','k');
    text(m6_x(1)+.15*cl(1)-offset,0.05*bma,'6','fontsize',14,'Color','k');
    text(m7_x(1)+.15*cl(1)-offset,0.05*bma,'7','fontsize',14,'Color','k');
    text(m8_x(1)+.15*cl(1)-offset,0.05*bma,'8','fontsize',14,'Color','k');
    text(m9_x(1)+.15*cl(1)-offset,0.05*bma,'9','fontsize',14,'Color','k');
    text(m10_x(1)+.0*cl(1)-offset,0.05*bma,'10','fontsize',13,'Color','k');
    text(m11_x(1)+.0*cl(1)-offset,0.05*bma,'11','fontsize',13,'Color','k');
    text(m12_x(1)+.0*cl(1)-offset,0.05*bma,'12','fontsize',13,'Color','k');
    text(m13_x(1)+.0*cl(1)-offset,0.05*bma,'13','fontsize',13,'Color','k');

    %for ii=1:14,text(z0(ii)+cl(1)/4,1.05*bma,num2str(ii));end
    textout1=['C1 = ',num2str(cur(1)),' amps   ',...
             'C2 = ',num2str(cur(2)),' amps   ',...
             'C3 = ',num2str(cur(3)),' amps   ',...
             'C4 = ',num2str(cur(4)),' amps   ',...
             'C5 = ',num2str(cur(5)),' amps   ',...
             'C6 = ',num2str(cur(6)),' amps   ',...
             'C7 = ',num2str(cur(7)),' amps'];
    textout2=['C8 = ',num2str(cur(8)),' amps   ',...
             'C9 = ',num2str(cur(9)),' amps   ',...
             'C10 = ',num2str(cur(10)),' amps   ',...
             'C11 = ',num2str(cur(11)),' amps   ',...
             'C12 = ',num2str(cur(12)),' amps   '...
             'C13 = ',num2str(cur(13)),' amps   '];

    locs=axis;		 
    
    axis([0,zmax,locs(3),locs(4)]);
   set(gca,'Fontsize',15);
%     set(findall(gcf,'type','text'),'fontsize',fontsize,'fontweight',fontweight)
%     text(-.1*locs(2),-.22*locs(4),textout1,'fontsize',12,'fontweight','normal','Color','k');	
%     text(-.1*locs(2),-.27*locs(4),textout2,'fontsize',12,'fontweight','normal','Color','k');
    hold off


%% Create Full Device profiles for Proto-MPEX for GITR simulations
    
if CreateGITRInputs==1

    X=linspace(0,5,5000);
    Y=linspace(0,0.0625,4000);
    rGrid=Y;
    zGrid=X;
    [XX YY]=meshgrid(X,Y);
    
    %Density fit
    ne_max=5e19; %ne_max=3e18;
    ne_min=3e17; %ne_min=1.5e17;
    b=2.15;
    newrlocs=[0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.0625, 0.07];
    density_y=ne_max.*(1-(newrlocs(1:end-1)/0.0625)).^b+ne_min;
 
%Tempeature fit    
xfit=[0, 1, 2, 3, 4, 5, 6, 6.25, 7];
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
   
    %Mach number
    MachGrid=zeros(1,5000);
    MachGrid(501:1750)=linspace(-0.5,-0.1,1750-500);
    MachGrid(1751:4145)=linspace(0.1,0.5,(4145-1750));
    
    Brnew=interpn(avec,zvec,br,YY,XX);
    Brnew(1,:)=Brnew(2,:);
    Bznew=interpn(avec,zvec,bz,YY,XX);
    Bznew(1,:)=Bznew(2,:);
    Btnew=interpn(avec,zvec,bt,YY,XX);
    Btnew(1,:)=Btnew(2,:);
    
    load('HighDensityFullDevicePlasmaParamters.mat', 'HighDensityFullDevicePlasmaParameters');
    NewTest1=scatteredInterpolant(HighDensityFullDevicePlasmaParameters(1,:)',HighDensityFullDevicePlasmaParameters(2,:)', HighDensityFullDevicePlasmaParameters(3,:)');
    Vq1=NewTest1({X,Y});
    HighDensityFullDevicePlasmaNe=Vq1';
    
    NewTest2=scatteredInterpolant(HighDensityFullDevicePlasmaParameters(1,:)',HighDensityFullDevicePlasmaParameters(2,:)', HighDensityFullDevicePlasmaParameters(4,:)');
    Vq2=NewTest2({X,Y});
    HighDensityFullDevicePlasmaTe=Vq2';
    
    k_b=1.3807E-23; %J/K %Boltzman Constant
    y_e=1;
    y_i=3;
    m_p=938.27e6/(3.0E8)^2; %eV %Mass of proton
    m_D=2*m_p; %eV %Mass of D ion
    m_Al_kg=4.48e-23; %kg %mass of Al atom
    %m_Al=5.60958865e35*4.4803831e-23;
    IonSpeed=sqrt(((y_e.*HighDensityFullDevicePlasmaTe)+(y_i.*HighDensityFullDevicePlasmaTe))/m_D);
    %c_s= sqrt(((y_e*T_e_K*k_b)+(y_i*T_i_K*k_b))/m_Al_kg); %m/s %Sound speed from Chen2015 4.41
    
    area=pi.*YY.^2;
    arearatio=area(:,1747)./area;
    Btratio=cc(2,739)./cc(2,2:end);
    NewTest3=interpn(cc(1,2:end),Btratio,X);
    %Ratio=repmat(NewTest3,[4000 1]);
    figure
    plot(X,NewTest3)
    HighDensityFullDevicePlasmaNe1=NewTest3.*HighDensityFullDevicePlasmaNe;
    
    HighDensityFullDevicePlasmaNe=HighDensityFullDevicePlasmaNe1;
    
    Vz=Bznew./Btnew.*IonSpeed.*MachGrid;
    Vr=Brnew./Btnew.*IonSpeed.*MachGrid;
    
    Btnew=Btnew*0;
    
    %save('HighDensityFullDeviceMagneticField.mat','Btnew','Brnew','Bznew','rGrid','zGrid','MachGrid','Vr','Vz','XX','YY')
    %save('HighDensityFullDevicePlasmaNe.mat','HighDensityFullDevicePlasmaNe')
    %save('HighDensityFullDevicePlasmaTe.mat','HighDensityFullDevicePlasmaTe')
end

                             