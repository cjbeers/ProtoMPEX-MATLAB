

FONTSIZE=25;
FONTWEIGHT='Normal';
LEVEL={'Lower Level','Upper Level'};

LL=DATA.STATE.LL.EL;
UL=DATA.STATE.UL.EL;

Array=0.1:0.1:5.9;

figure;
plot([Array(1),Array(9)],[LL(1),LL(1)],'k','LineWidth',5)
hold on;
plot([Array(11),Array(19)],[LL(2),LL(2)],'k','LineWidth',5)
plot([Array(21),Array(29)],[LL(3),LL(3)],'k','LineWidth',5)
plot([Array(31),Array(39)],[LL(4),LL(4)],'k','LineWidth',5)
plot([Array(41),Array(49)],[LL(5),LL(5)],'k','LineWidth',5)
plot([Array(51),Array(59)],[LL(6),LL(6)],'k','LineWidth',5)

plot([Array(1),Array(9)],[UL(1),UL(1)],'k','LineWidth',5)
plot([Array(11),Array(19)],[UL(2),UL(2)],'k','LineWidth',5)
plot([Array(21),Array(29)],[UL(3),UL(3)],'k','LineWidth',5)
plot([Array(31),Array(39)],[UL(4),UL(4)],'k','LineWidth',5)
plot([Array(41),Array(49)],[UL(5),UL(5)],'k','LineWidth',5)
plot([Array(51),Array(59)],[UL(6),UL(6)],'k','LineWidth',5)

hold off
            grid on
            xlim([0 6])
            xlabel('\Phi_n','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            ylabel('Energy (eV)','FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)
            
            set(gca,'FontSize',FONTSIZE,'FontWeight',FONTWEIGHT)




