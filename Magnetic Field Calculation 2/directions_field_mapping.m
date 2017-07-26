%Running: magnetic field mapping + the magnetic field strength along the
%machine length

%step 1: load proto_mpex_12coils_flat_field_highdens.mat
load('proto_mpex_12coils_flat_field_highdens.mat');

%step 2: load shot number and associated current
KnownFields = 1;

if KnownFields == 0

shot = input('Choose shot to analyze - enter shot number only ' ); 
if shot > 15100 % Need to edit get_proto_geometry beforehand
    [helicon_current,current_A,current_B,config,skimmer,current_C] = get_Proto_current(shot);
else
    [helicon_current,current_A,current_B,config,skimmer,current_C] = get_Proto_current(shot);
end

else KnownFields == 1
    
   helicon_current =260; %Coils 3,4
   current_A = 4000; %Coils 1,6
   current_B = 4000; %Coils 7-12
   current_C = 0;  %Coil 2
   skimmer = 1;
   config = 'newstandard';
   add_reflector = 1;
end

target_position = 3;   %target position 1: 7.5, 2: 11.5, 3: Off center 11.5
sleeve = 1;


current_in = [helicon_current, current_A,current_B, current_C];
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
    skimmer_y1=[.058/2,.15/2,.15/2,.058/2,.058/2];
    skimmer_y2=-skimmer_y1;
    tube_x=[0,0,24*.0254,24*.0254,0]+z0(7)-.0254;
    tube_y=[-.04,.04,.04,-.04,-.04];
    ant_x=[2.03,2.18,2.18,2.03,2.03];
    ant_y=[.028,.028,.034,.034,.028];
    lhres=.1650;
    b_lh_x=[0,1];
    b_lh_y=[1,1]*lhres;
    rlocs=[.01,.02,.03,.04,.05,.06,.0625];
    geop=get_Proto_geometry(0,0,1,3,1,1);

    [br,bz,psi]=B_coaxial_coilsm(brg,bzg,atg,avec,cur);

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




    m_y=[0,0,bma,bma,0];
    vals=psivals(avec,zvec,psi,zvec(bmloc),rlocs);
    disp(zvec(bmloc))
    subplot(2,1,1);
    hold off
    contour(zvec,avec,psi,vals,'b');
    hold on
    contour(zvec,avec,psi,[vals(7),vals(7)],'r');
    plot(geop.vessel.z,geop.vessel.r,'k',tube_x,tube_y,'c--',skimmer_x,skimmer_y1,'r--',skimmer_x,skimmer_y2,'r--',window_x,window_y,'c');
    grid
    title('Flux tube mapping');
    h=ylabel('R  (m)');
    set(h,'fontsize',22,'fontweight','bold');
    h=xlabel('Z  (m)');
    set(h,'fontsize',22,'fontweight','bold');
    axis([0,zmax,0,.2])
    set(gca,'Fontsize',22,'fontweight','bold');
    %set(findall(gcf,'type','text'),'fontsize',fontsize,'fontweight',fontweight)
    subplot(2,1,2)

    plot(zvec,bt(1,:),'b',m1_x,m_y,'r',m2_x,m_y,'r',m3_x,m_y,'r',m4_x,m_y,'r',...
                          m5_x,m_y,'r',m6_x,m_y,'r',m7_x,m_y,'r',m8_x,m_y,'r',...
                          m9_x,m_y,'r',m10_x,m_y,'r',m11_x,m_y,'r',m12_x,m_y,'r','linewidth',2);
    grid
    title('mod B on axis');
    h=ylabel('|B|  (T)');
    set(h,'fontsize',22,'fontweight','bold');
    h=xlabel('Z  (m)');
    set(h,'fontsize',22,'fontweight','bold');

    text(m1_x(1)+.15*cl(1),0.05*bma,'1','fontsize',14);
    text(m2_x(1)+.15*cl(1),0.05*bma,'2','fontsize',14);
    text(m3_x(1)+.15*cl(1),0.05*bma,'3','fontsize',14);
    text(m4_x(1)+.15*cl(1),0.05*bma,'4','fontsize',14);
    text(m5_x(1)+.15*cl(1),0.05*bma,'5','fontsize',14);
    text(m6_x(1)+.15*cl(1),0.05*bma,'6','fontsize',14);
    text(m7_x(1)+.15*cl(1),0.05*bma,'7','fontsize',14);
    text(m8_x(1)+.15*cl(1),0.05*bma,'8','fontsize',14);
    text(m9_x(1)+.15*cl(1),0.05*bma,'9','fontsize',14);
    text(m10_x(1)+.15*cl(1),0.05*bma,'10','fontsize',14);
    text(m11_x(1)+.15*cl(1),0.05*bma,'11','fontsize',14);
    text(m12_x(1)+.15*cl(1),0.05*bma,'12','fontsize',14);

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
             'C12 = ',num2str(cur(12)),' amps   '];

    locs=axis;		 

    axis([0,zmax,locs(3),locs(4)]);
    set(gca,'Fontsize',22,'fontweight','bold');
    %set(findall(gcf,'type','text'),'fontsize',fontsize,'fontweight',fontweight)
    text(-.1*locs(2),-.22*locs(4),textout1,'fontsize',12,'fontweight','normal');	
    text(-.1*locs(2),-.27*locs(4),textout2,'fontsize',12,'fontweight','normal');
    hold off



                             