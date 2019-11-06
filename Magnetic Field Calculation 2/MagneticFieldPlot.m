%% Plots flux tube and B field
    
    offset=0.0;
    
    figure;
    subplot(2,1,1);
    hold off
    contour(zvec(:,1:end-offset),avec,PSIarray(:,offset+1:end),vals,'b');
    hold on
    contour(zvec(:,1:end-offset),avec,PSIarray(:,offset+1:end),[vals(7),vals(7)],'r');
    plot(geop.vessel.z-offset,geop.vessel.r,'k',tube_x-offset,tube_y,'c--',skimmer_x-offset,skimmer_y1,'r--',skimmer_x-offset,skimmer_y2,'r--',window_x-offset,window_y,'c',geop.target.z-offset,geop.target.r,'k');
    plot(geop.target.z*[1,1]-offset,geop.target.r*[0,1],'k','linewidth',3)
    grid
    title('Flux tube mapping');
    h=ylabel('R  (m)');
    set(h,'fontsize',13,'fontweight','bold');
    h=xlabel('Z  (m)');
    set(h,'fontsize',13,'fontweight','bold');
    axis([0,zmax,0,.2])
    set(gca,'Fontsize',13,'fontweight','bold');
    %set(findall(gcf,'type','text'),'fontsize',fontsize,'fontweight',fontweight)
    
  
    subplot(2,1,2)
    hold off
    plot(zvec(1,1:end),bt(1,1:end),'b',m1_x-offset,m_y,'r',m2_x-offset,m_y,'r',m3_x-offset,m_y,'r',m4_x-offset,m_y,'r',...
                          m5_x-offset,m_y,'r',m6_x-offset,m_y,'r',m7_x-offset,m_y,'r',m8_x-offset,m_y,'r',...
                          m9_x-offset,m_y,'r',m10_x-offset,m_y,'r',m11_x-offset,m_y,'r',m12_x-offset,m_y,'r',m13_x-offset,m_y,'r',geop.target.z-offset,geop.target.r,'k','linewidth',2);
    hold on
    plot(geop.target.z*[1,1]-offset,geop.target.r*[0,offset],'k','linewidth',3)
    grid
    axis([0, zmax, 0, bma])
    title('mod B on axis');
    h=ylabel('|B| (T)','fontsize',18,'fontweight','bold','Color','k');
    %set(h,'fontsize',15,'fontweight','bold');
    h=xlabel('Z (m)','fontsize',18,'fontweight','bold','Color','k');
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
    text(m10_x(1)+.10*cl(1)-offset,0.05*bma,'10','fontsize',13,'Color','k');
    text(m11_x(1)+.10*cl(1)-offset,0.05*bma,'11','fontsize',13,'Color','k');
    text(m12_x(1)+.10*cl(1)-offset,0.05*bma,'12','fontsize',13,'Color','k');
    text(m13_x(1)+.10*cl(1)-offset,0.05*bma,'13','fontsize',13,'Color','k');

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
   set(gca,'Fontsize',18,'fontweight','bold');
    %set(findall(gcf,'type','text'),'fontsize',fontsize,'fontweight',fontweight)
    text(-.1*locs(2),-.22*locs(4),textout1,'fontsize',12,'fontweight','normal','Color','k');	
    text(-.1*locs(2),-.27*locs(4),textout2,'fontsize',12,'fontweight','normal','Color','k');
    hold off