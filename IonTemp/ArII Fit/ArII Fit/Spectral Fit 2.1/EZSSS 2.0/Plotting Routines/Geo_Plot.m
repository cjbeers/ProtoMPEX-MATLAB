function Geo_Plot(OBS,FIELD,OPT)

%*******************************************************************
%Color of magnetic, DC electric, and RF electric fields respecitvely
%*******************************************************************
COL={'blue','black','red'};

%**********************************************
%Nomial length of field and observation vectors
%**********************************************
STEM_WIDTH=0.02;

%*************************************
%Nomial length of polarization vectors
%*************************************
POL_LENGTH=0.6;

%****************
%Assign the input
%****************
B=FIELD.B;
EDC=FIELD.EDC;
ERF=FIELD.ERF;

POL=OBS.POL;
VIEW=OBS.VIEW;

TEXT_BOX=OPT.PLOT.GEO.TEXT_BOX;
FIG_VIEW=OPT.PLOT.GEO.FIG_VIEW;

%****************************************************
%Normalize the field vectors to have magnitude LENGTH
%****************************************************
NOR=abs(B.MAG);
if NOR==0
    NOR=1;
end
B_VEC=[0 0 B.MAG/NOR];

NOR=sum(EDC.MAG.^2)^.5;
if NOR==0
    NOR=1;
end
EDC_VEC=EDC.MAG/NOR;

NOR=sum(sum(ERF.MAG,1).^2)^.5;
if NOR==0
    NOR=1;
end
ERF_VEC=sum(ERF.MAG,1)/NOR;

%**************************
%Calc. the observation cord
%**************************
OBS_VEC(1)=cos(VIEW.AZIM)*sin(VIEW.POLAR);
OBS_VEC(2)=sin(VIEW.AZIM)*sin(VIEW.POLAR);
OBS_VEC(3)=cos(VIEW.POLAR);

if POL.T(1)~=POL.T(2)
    %********************************
    %Assign the transmission fraction
    %********************************
    if POL.T(2)==0
        T1=-POL_LENGTH;
        T2=0;
    else
        T1=POL.T(1)*-POL_LENGTH;
        T2=POL.T(2)*POL_LENGTH;
    end

    %**************************************
    %Assign the initial polariation vectors
    %**************************************
    POL_VEC{1}=[T1*cos(POL.ANG),-T1*sin(POL.ANG),1];
    POL_VEC{2}=[T2*sin(POL.ANG),T2*cos(POL.ANG),1];

    %*****************************
    %Rotate in the polar direction
    %*****************************
    POL_VEC{1}=[POL_VEC{1}(1)*cos(VIEW.POLAR)+POL_VEC{1}(3)*sin(VIEW.POLAR),...
                POL_VEC{1}(2),...
               -POL_VEC{1}(1)*sin(VIEW.POLAR)+POL_VEC{1}(3)*cos(VIEW.POLAR)];

    POL_VEC{2}=[POL_VEC{2}(1)*cos(VIEW.POLAR)+POL_VEC{2}(3)*sin(VIEW.POLAR),...
                POL_VEC{2}(2),...
               -POL_VEC{2}(1)*sin(VIEW.POLAR)+POL_VEC{2}(3)*cos(VIEW.POLAR)];   

    %*********************************
    %Rotate in the azimuthal direction
    %*********************************
    POL_VEC{1}=[POL_VEC{1}(1)*cos(VIEW.AZIM)-POL_VEC{1}(2)*sin(VIEW.AZIM),...
                POL_VEC{1}(1)*sin(VIEW.AZIM)+POL_VEC{1}(2)*cos(VIEW.AZIM),...
                POL_VEC{1}(3)];

    POL_VEC{2}=[POL_VEC{2}(1)*cos(VIEW.AZIM)-POL_VEC{2}(2)*sin(VIEW.AZIM),...
                POL_VEC{2}(1)*sin(VIEW.AZIM)+POL_VEC{2}(2)*cos(VIEW.AZIM),...
                POL_VEC{2}(3)];   
else
    POL_VEC(1:2)={OBS_VEC};
end

%*****************
%Calc. axis limits
%*****************
MAX=max(abs([B_VEC,EDC_VEC,ERF_VEC,OBS_VEC,POL_VEC{1},POL_VEC{2}]));

%******************
%Assign axis limits
%******************
AXIS(1:6)=0;
for ii=1:3
    T1=min([B_VEC(ii),EDC_VEC(ii),ERF_VEC(ii),OBS_VEC(ii),POL_VEC{1}(ii),POL_VEC{2}(ii),...
           -B_VEC(ii),-EDC_VEC(ii),-ERF_VEC(ii)]);
    T2=max([B_VEC(ii),EDC_VEC(ii),ERF_VEC(ii),OBS_VEC(ii),POL_VEC{1}(ii),POL_VEC{2}(ii),...
           -B_VEC(ii),-EDC_VEC(ii),-ERF_VEC(ii)]);

    AXIS(1+2*(ii-1):2*ii)=(T2+T1)/2+[-MAX,MAX];
end

%*******************************************
%Generate parameter information for text box
%*******************************************
TEXT{1}=['B\phantom{$_{DC}$} =[0.0,0.0,' num2str(B.MAG,'%3.1f') '] T']; 
TEXT{2}=['E$_{DC}$ =[' num2str(EDC.MAG(1)/1e5,'%3.1f') ',' num2str(EDC.MAG(2)/1e5,'%3.1f') ',' num2str(EDC.MAG(3)/1e5,'%3.1f') '] kV/cm']; 
TEXT{3}=['E$_{RF}$ =[' num2str(sum(ERF.MAG(:,1))/1e5,'%3.1f') ',' num2str(sum(ERF.MAG(:,2))/1e5,'%3.1f') ',' num2str(sum(ERF.MAG(:,3))/1e5,'%3.1f') '] kV/cm']; 
TEXT{4}=['[$\theta,\phi$]=[' num2str(VIEW.POLAR*180/pi,'%3.0f') ',' num2str(VIEW.AZIM*180/pi,'%3.0f') '] degrees'];
if POL.T(1)==POL.T(2)
    TEXT{5}='Unpolarized';
elseif POL.T(2)==0
    TEXT{5}=['$\theta_{P}\hspace{.26cm}$ =' num2str(POL.ANG*180/pi,'%3.0f') ' degrees'];
else
    TEXT{5}=['$\theta_{P}\hspace{.26cm}$ =' num2str(POL.ANG*180/pi,'%3.0f') ' degrees $-$ [$T_1,T_2$]=[' num2str(POL.T(1)*100,'%3.1f') ',' num2str(POL.T(2)*100,'%3.1f') '] $\%$'];
end

%*****************
%Plot the geometry
%*****************
figure
mArrow3(-B_VEC,B_VEC,'color',COL{1},'stemWidth',STEM_WIDTH);
mArrow3(-EDC_VEC,EDC_VEC,'color',COL{2},'stemWidth',STEM_WIDTH);
mArrow3([0,0,0],ERF_VEC,'color',COL{3},'stemWidth',STEM_WIDTH);
mArrow3([0,0,0],-ERF_VEC,'color',COL{3},'stemWidth',STEM_WIDTH);
mArrow3(OBS_VEC,[0 0 0],'color','green','stemWidth',STEM_WIDTH);
mArrow3(OBS_VEC,POL_VEC{1},'color','green','stemWidth',STEM_WIDTH);
mArrow3(OBS_VEC,POL_VEC{2},'color','green','stemWidth',STEM_WIDTH);
if isempty(FIG_VIEW)==0
    view(FIG_VIEW)
end
light('Position',[-1,0,0],'Style','local');  
if B.LOGIC==1
    text(B_VEC(1)*1.05,B_VEC(2)*1.05,B_VEC(3)*1.05,'B','FontSize',38,'FontWeight','Bold','Color',COL{1})
end
if EDC.LOGIC==1
    text(EDC_VEC(1)*1.05,EDC_VEC(2)*1.05,EDC_VEC(3)*1.05,'E_{DC}','FontSize',38,'FontWeight','Bold','Color',COL{2})
end
if ERF.LOGIC==1
    text(ERF_VEC(1)*1.05,ERF_VEC(2)*1.05,ERF_VEC(3)*1.05,'E_{RF}','FontSize',38,'FontWeight','Bold','Color',COL{3})
end
text(OBS_VEC(1)*1.05,OBS_VEC(2)*1.05,OBS_VEC(3)*1.05,'VIEW','FontSize',38,'FontWeight','Bold','Color',[85,160,60]/sum([85,160,60]))
if strcmpi(TEXT_BOX,'on')==1
    annotation('textbox',[0.135 0.6 0.4 0.2],'LineStyle','none','FontSize',30, 'Interpreter', 'latex','string',TEXT);
end
xlabel('X-Axis','FontSize',38)
ylabel('Y-Axis','FontSize',38)
zlabel('Z-Axis','FontSize',38)
grid on
axis(AXIS*1.1)
AH=gca;
AH.XTickLabel=' ';
AH.YTickLabel=' ';
AH.ZTickLabel=' ';