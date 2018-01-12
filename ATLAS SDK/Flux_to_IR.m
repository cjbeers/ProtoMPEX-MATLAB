cleanup

%--------------------------------------------------------------------------
% Uses sections of test_calc_flux_mpex script to determine, given r and z
% eval, the map along flux-lines to the target in r with fixed z. Assuming
% revolutional symmetry, the field lines are the same in both x and y
% directions. Traces are made for both r directional maps, and trace marker
% is projected onto IR camera image at target using IRMovie script.
%--------------------------------------------------------------------------

%% Flux Mapping part
% begin from test_calc_flux_mpex

helicon_current = 160;
current_A = 4000;
current_B = 4000;
current_C = 600;
config = 'newstandard';
current_in = [helicon_current,current_A,current_B,current_C];
verbose = 1;
[coil,current] = build_Proto_coils_jackson(current_in,config,verbose);
%[radius = .5 diameter of machine @ diagnostic &
% converstion from [cm] to [m]]
% radius= 15.2/200; % up to Spool 6.5
% radius= 41/200;   % at Spool 6.5
%radius= 49/200;   % past Spool 6.5
%Hf = (radius-0.05); % length of diagnostic into the machine

%USER inputs
th = 1.8/1000; % thickness of diagnostic tip, lengthwise
Zeval = 3.8911; % axial distance into the machine
W = 0.254/1000; % width of diagnostic
Roff = 0.000; % offset from central axis, if any (+ toward pit side, - away from pit)
%Hi = Hf-th; % length of diagnostic tip into machine
Hf = 0.05; % distance of diagnostic tip from machine center axis (make negative for below central axis)
Hi = Hf+th; % top of tip thickness

Reval=zeros(1,4);
t = zeros(1,4);
top = zeros(1,4);

%Reval(:,1) = radius-Hf; %radial distance of diagnostic end from center
%Reval(:,2) = radius-Hi;
Reval(:,1) = Hf;
Reval(:,2) = Hi;
Rmax = 0.05715; % maximum radius of target
for ii=1:2
if Reval(:,ii)<0
    t(:,ii) = 1; % truth for negative input
    Reval(:,ii) = abs(Reval(:,ii));
else
    Reval(:,ii) = abs(Reval(:,ii));
end
end

Reval(:,3) = (W/2)-Roff; % - side
Reval(:,4) = (W/2)+Roff; % +side
for ii=3:4
if Reval(:,ii)<0
    t(:,ii) = 1; % truth for negative input
    Reval(:,ii) = abs(Reval(:,ii));
else 
    Reval(:,ii) = abs(Reval(:,ii));
end
end

dz_want = 0.01;
Ztarg = 4.33415;  % Set axial position for mapping
L = Ztarg - Zeval;
nsteps = round(abs(L/dz_want));
dz = L/nsteps;
bfield.coil = coil; bfield.current = current; bfield.type = 'MPEX';

for ii=1:4
psi_eval = calc_psi_mpex(coil,current,Reval(:,ii),Zeval);
Rmap = map_pt_to_target_mpex(coil,current,Ztarg,Reval(:,ii),Zeval);
f = follow_fieldlines_rzphi_dz(bfield,Reval(:,ii),Zeval,0,dz,nsteps);
fprintf('Point (R,Z) = (%6.3f,%6.3f) [m] maps to radius %8.5f [m] at Z = %6.3f [m]\n',Reval(:,ii),Zeval,f.r(end),Ztarg)

top(:,ii)= f.r(end);

skimmer = 1;
target_position = 2;
sleeve = 1;
reflector = 1;
geo = get_Proto_geometry(1,1,skimmer,target_position,sleeve,reflector);
plot(Zeval,Reval(:,ii),'ko')
plot(f.z,f.r,'b','linewidth',2)
plot(f.z(end),f.r(end),'rx','markersize',12)

allin = all(inpolygon(f.z,f.r,geo.vessel_clip_z,geo.vessel_clip_r));
if allin
    fprintf('No intersections detected\n')
else
    fprintf('Found intersection(s)\n')
    ins = inpolygon(f.z,f.r,geo.vessel_clip_z,geo.vessel_clip_r);
    int1 = find(ins==0,1,'first') - 1;
    fprintf('Last point before intersection (R,Z) = (%6.3f,%6.3f) [m]\n',f.r(int1),f.z(int1))
    plot(f.z(int1),f.r(int1),'mx','markersize',12,'linewidth',3)
end
end
% end from test_calc_flux_mpex

%% IR part
clear geo

% %begin from IRMovie
% %% % Start Code
% 
% %Loads IR .seq file
% %[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');
% Shots=15375; %USER defines shot number, if not found change the PATHNAME to the correct day/file location
% IR.FrameStart=1;
% IR.FrameEnd=60;
% IR.FILENAME = ['Shot ' ,num2str(Shots),'.seq'];
% IR.PATHNAME = 'Z:\IR_Camera\2017_06_28\';
% FILTERINDEX = 1;
% 
% IR.videoFileName=[IR.PATHNAME IR.FILENAME];
% 
% % Load the Atlats SDK
% FLIR.atPath = getenv('FLIR_Atlas_MATLAB');
% FLIR.atImage = strcat(FLIR.atPath,'Flir.Atlas.Image.dll');
% FLIR.asmInfo = NET.addAssembly(FLIR.atImage);
% %open the IR-file
% file = Flir.Atlas.Image.ThermalImageFile(IR.videoFileName);
% seq = file.ThermalSequencePlayer();
% %Get the pixels
% IR.img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
% IR.im = double(IR.img);
% IR.Counts=seq.ThermalImage.Count; %# of frames
% IR.images=zeros(480, 640, IR.Counts);
% 
% %Puts all frames into images
% i=1;
% if(seq.Count > 1)
%     while(seq.Next())
%         IR.img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
%         IR.im = double(IR.img);
%         images(:,:,i)=(IR.im);
%         i=i+1;
%     end
% end
% 
% %Creates array of tick marks to be used in colorbar
%         IR.colorticks=1.2E5:1E2:3E5;
%         IR.colorsize=size(IR.colorticks);
%         
%           jj=1;
%         for o=10400:1000:30000
%            IR.colorlabels(1,jj) = seq.ThermalImage.GetValueFromSignal(o);
%            jj=jj+1;
%         end
        
PixelArea=(((1.375/sqrt(2))*(2.54/100))^2)/80;
PixelR = sqrt(PixelArea/pi); 
    
% for ii=IR.FrameStart:IR.FrameEnd
%         
%         IR.Temperature(:,:,ii)=arrayfun(@(images) seq.ThermalImage.GetValueFromEmissivity(0.26, images),images(100:300,260:460,ii));
%     end
% 
%     for ii=IR.FrameStart:IR.FrameEnd
%         
%         IR.fig2=figure(5);
%         imagesc(IR.Temperature(:,:,ii), 'CDataMapping','scaled')
%         caxis([0 250])
%         colormap jet
%         c=colorbar;
%         ylabel(c, 'T [°C]', 'FontSize', 13);
%         ax.FontSize = 13;
%         hold on
%         if t(1,1)==0
%            q = 100-round(top(1,1)/PixelR); % sign-dependent variable
%            plot(100+round(Roff/PixelR),q,'ko','MarkerSize',10); %marker for vertical end
%         elseif t(1,1)==1
%            q = 100+round(top(1,1)/PixelR);
%            plot(100+round(Roff/PixelR),q,'ko','MarkerSize',10); %accounts for sign change
%         end
%         if t(1,2)==0
%             plot(100+round(Roff/PixelR),100-round(top(1,2)/PixelR),'ko','MarkerSize',10); % marker for top of probe tip
%         elseif t(1,2)==1
%             plot(100+round(Roff/PixelR),100+round(top(1,2)/PixelR),'ko','MarkerSize',10);
%         end
%         if t(1,3)==0
%             plot(100-round(top(1,3)/PixelR),q-(th/2),'ko','MarkerSize',10); % marker for -
%         elseif t(1,3)==1
%             plot(100+round(top(1,3)/PixelR),q-(th/2),'ko','MarkerSize',10);
%         end
%         if t(1,4)==0
%             plot(100+round(top(1,4)/PixelR),q-(th/2),'ko','MarkerSize',10); % marker for +
%         elseif t(1,4)==1
%             plot(100-round(top(1,4)/PixelR),q-(th/2),'ko','MarkerSize',10);
%         end
%         hold off
%         title(['Shot Number ', num2str(Shots), ' Temperature Movie'],'FontSize',13);
%         xlabel('Pixels','FontSize',13);
%         ylabel('Pixels','FontSize',13);
%         IR.TemperatureFrames(ii)=getframe(IR.fig2);
%         
%     end
%     close figure 2
%     IR.Movie2=implay(IR.TemperatureFrames(IR.FrameStart:IR.FrameEnd),10); %Creates Movie at 10 fps
% 
% % end from IRMovie

% begin from IRshot_AutoAnalysis_graphitetarget_emiss069_halfscreen

[MaxDelta, shotnumber] = IRshot_AutoAnalysis_graphitetarget_emiss069_halfscreenV3();

%m_per_px = 1/px_per_m; 
x = zeros(1,4);
y = zeros(1,4);

%Plot MaxDelta
figure;
figDeltaT=imagesc(MaxDelta, 'CDataMapping','scaled');
hold on
caxis([0 75])
colormap jet
c=colorbar;
ylabel(c, 'Delta T [C]')
ax.FontSize = 13;
title([shotnumber,'; Delta Temperature vs. Camera Pixels'],'FontSize',13);
xlabel('Pixels','FontSize',13);
ylabel('Pixels','FontSize',13);
p = 80+round(Roff/PixelR);
if t(1,1)==0
   q = 80-round(top(1,1)/PixelR); % sign-dependent variable
   plot(p,q,'ko','MarkerSize',10); %marker for vertical end
   x(1,1)=p;
   y(1,1)=q;
elseif t(1,1)==1
   q = 80+round(top(1,1)/PixelR);
   plot(p,q,'ko','MarkerSize',10); %accounts for sign change
   x(1,1)=p;
   y(1,1)=q;
end
if t(1,2)==0
    plot(p,80-round(top(1,2)/PixelR),'ko','MarkerSize',10); % marker for top of probe tip
    x(1,2)=p;
    y(1,2)=80-round(top(1,2)/PixelR);
elseif t(1,2)==1
    plot(p,80+round(top(1,2)/PixelR),'ko','MarkerSize',10);
    x(1,2)=p;
    y(1,2)=80+round(top(1,2)/PixelR);
end
if t(1,3)==0
    plot(80-round(top(1,3)/PixelR),round(q-(th/2)),'ko','MarkerSize',10); % marker for -
    x(1,3)= 80-round(top(1,3)/PixelR);
    y(1,3)= round(q-(th/2));
elseif t(1,3)==1
    plot(80+round(top(1,3)/PixelR),round(q-(th/2)),'ko','MarkerSize',10);
    x(1,3)= 80+round(top(1,3)/PixelR);
    y(1,3)= round(q-(th/2));
end
if t(1,4)==0
    plot(80+round(top(1,4)/PixelR),round(q-(th/2)),'ko','MarkerSize',10); % marker for +
    x(1,4) = 80+round(top(1,4)/PixelR);
    y(1,4) = round(q-(th/2));
elseif t(1,4)==1
    plot(80-round(top(1,4)/PixelR),round(q-(th/2)),'ko','MarkerSize',10);
    x(1,4) = 80-round(top(1,4)/PixelR);
    y(1,4) = round(q-(th/2));
end
hold off

% figure;
% figDeltaT=imagesc(Temperature, 'CDataMapping','scaled');
% hold on
% caxis([0 75])
% colormap jet
% c=colorbar;
% ylabel(c, 'T [C]')
% ax.FontSize = 13;
% title([shotnumber,'; Temperature vs. Camera Pixels'],'FontSize',13);
% xlabel('Pixels','FontSize',13);
% ylabel('Pixels','FontSize',13);

fprintf('Pixel Crosshair Ordering: top, bottom, left, right\n');
fprintf('x Pixels: %6.0f, %6.0f, %6.0f, %6.0f\n', x(1,2),x(1,1),x(1,3),x(1,4));
fprintf('x Meters from Center: %6.5f, %6.5f, %6.5f, %6.5f\n', ((x(1,2)-80)*PixelR),((x(1,1)-80)*PixelR),((x(1,3)-80)*PixelR),((x(1,4)-80)*PixelR));
fprintf('y Pixels: %6.0f, %6.0f, %6.0f, %6.0f\n', y(1,2),y(1,1),y(1,3),y(1,4));
fprintf('y Meters from Center: %6.5f, %6.5f, %6.5f, %6.5f\n', ((y(1,2)-80)*PixelR),((y(1,1)-80)*PixelR),((y(1,3)-80)*PixelR),((y(1,4)-80)*PixelR));
fprintf('Delta T: %6.3f, %6.3f, %6.3f, %6.3f\n', MaxDelta(x(1,2),y(1,2)),MaxDelta(x(1,1),y(1,1)),MaxDelta(x(1,3),y(1,3)),MaxDelta(x(1,4),y(1,4)));