%Shot comparison - shell

%Constants for both shots required for analysis 


Cp=710; %J/kg*C
density=1760; %kg/m3
thickness= .25*(2.54/100); %inches to m
delta_tframe = 0.01;%gap between frames
% x_c = 100;
% y_c = 200;

number2compare = input ('How many shots are opening (can pick up to four)? ');

[FILENAME1] = uigetfile('*.m;*.mat', 'Choose the first IR shot file to compare (.mat or .m)');
load(FILENAME1);

area_TG1=area_TG;
avg_area1=avg_area;
center_plate1=center_plate;
DeltaTMatrix_step1=DeltaTMatrix_step;
emax1 = emax;
Frame1 = Frame;
hel_templist1 = hel_templist;
hel_templist_step1 = hel_templist_step;
meanlist1=meanlist;
meanlist_step1=meanlist_step;
px_per_cm1=px_per_cm;
TG_templist1=TG_templist;
TG_templist_step1=TG_templist_step;
% TC_radius1=TC_radius;
% shotnumber1=shotnumber;
% zoomframes1 = zoomframes;
% TG_frame1 = TG_frame;
% finalframenumber1=finalframenumber;
plasmaframe1=plasmaframe;
helicon_start1=helicon_start;

px_per_m1=px_per_cm1*100;
hel_radius1 = 3/px_per_m1;%pixels per m.
area_hel1 = pi*(hel_radius1^2); %same as area_TG;
TG_radius1 = 3/px_per_m1;
avg_side1 = (87*2)/px_per_m1;
avg_area1 = avg_side1^2;

% TG_powerdensity_step1 = ((Cp*TG_templist_step1*thickness*density)/delta_tframe)/1E6; %MW/m2
% hel_powerdensity_step1 = ((Cp*hel_templist_step1*thickness*density)/delta_tframe)/1E6; %MW/m2
% avg_powerdensity_step1 = ((Cp*meanlist_step1*thickness*density)/delta_tframe)/1E6; %MW/m2
% 
% TG_power_step1 = TG_powerdensity_step1*area_TG1*1000;  %kW
% hel_power_step1 = hel_powerdensity_step1*area_hel1*1000; %kW
% avg_power_step1 = avg_powerdensity_step1*avg_area1*1000; %kW

zoomframes1 = length(hel_templist1);

if number2compare >1
    [FILENAME2] = uigetfile('*.m;*.mat', 'Choose the second IR shot file to compare (.mat or .m)');
    load(FILENAME2);

    area_TG2=area_TG;
    avg_area2=avg_area;
    center_plate2=center_plate;
    DeltaTMatrix_step2=DeltaTMatrix_step;
    emax2 = emax;
    Frame2 = Frame;
    hel_templist2 = hel_templist;
    hel_templist_step2 = hel_templist_step;
    meanlist2=meanlist;
    meanlist_step2=meanlist_step;
    px_per_cm2=px_per_cm;
    TG_templist2=TG_templist;
    TG_templist_step2=TG_templist_step;
    plasmaframe2=plasmaframe;
    helicon_start2=helicon_start;
    % TC_radius2=TC_radius;
    % shotnumber2=shotnumber;
    % zoomframes2 = zoomframes;
    % TG_frame2 = TG_frame;
    % finalframenumber2=finalframenumber;

    px_per_m2=px_per_cm2*100;
    hel_radius2 = 3/px_per_m2;%pixels per m.
    area_hel2 = pi*(hel_radius2^2); %same as area_TG;
    TG_radius2 = 3/px_per_m2;
    avg_side2 = (87*2)/px_per_m2;
    avg_area2 = avg_side2^2;

    TG_powerdensity_step2 = ((Cp*TG_templist_step2*thickness*density)/delta_tframe)/1E6; %MW/m2
    hel_powerdensity_step2 = ((Cp*hel_templist_step2*thickness*density)/delta_tframe)/1E6; %MW/m2
    avg_powerdensity_step2 = ((Cp*meanlist_step2*thickness*density)/delta_tframe)/1E6; %MW/m2

    TG_power_step2 = TG_powerdensity_step2*area_TG1*1000;  %kW
    hel_power_step2 = hel_powerdensity_step2*area_hel1*1000; %kW
    avg_power_step2 = avg_powerdensity_step2*avg_area1*1000; %kW
   
    zoomframes2 = length(hel_templist2);

    if number2compare>2
        
        [FILENAME3] = uigetfile('*.m;*.mat', 'Choose the second IR shot file to compare (.mat or .m)');
        load(FILENAME3);

        area_TG3=area_TG;
        avg_area3=avg_area;
        center_plate3=center_plate;
        DeltaTMatrix_step3=DeltaTMatrix_step;
        emax3 = emax;
        Frame3 = Frame;
        hel_templist3 = hel_templist;
        hel_templist_step3 = hel_templist_step;
        meanlist3=meanlist;
        meanlist_step3=meanlist_step;
        px_per_cm3=px_per_cm;
        TG_templist3=TG_templist;
        TG_templist_step3=TG_templist_step;
        plasmaframe3=plasmaframe;
        helicon_start3=helicon_start;
        % TC_radius3=TC_radius;
        % shotnumber3=shotnumber;
        % zoomframes3 = zoomframes;
        % TG_frame3 = TG_frame;
        % finalframenumber3=finalframenumber;

        px_per_m3=px_per_cm3*100;
        hel_radius3 = 3/px_per_m3;%pixels per m.
        area_hel3 = pi*(hel_radius3^2); %same as area_TG;
        TG_radius3 = 3/px_per_m3;
        avg_side3 = (87*2)/px_per_m3;
        avg_area3 = avg_side3^2;

        TG_powerdensity_step3 = ((Cp*TG_templist_step3*thickness*density)/delta_tframe)/1E6; %MW/m2
        hel_powerdensity_step3 = ((Cp*hel_templist_step3*thickness*density)/delta_tframe)/1E6; %MW/m2
        avg_powerdensity_step3 = ((Cp*meanlist_step3*thickness*density)/delta_tframe)/1E6; %MW/m2

        TG_power_step3 = TG_powerdensity_step3*area_TG1*1000;  %kW
        hel_power_step3 = hel_powerdensity_step3*area_hel1*1000; %kW
        avg_power_step3 = avg_powerdensity_step3*avg_area1*1000; %kW
        
        zoomframes3 = length(hel_templist3);

            if number2compare>3
                
            [FILENAME4] = uigetfile('*.m;*.mat', 'Choose the second IR shot file to compare (.mat or .m)');
            load(FILENAME4);

            area_TG4=area_TG;
            avg_area4=avg_area;
            center_plate4=center_plate;
            DeltaTMatrix_step4=DeltaTMatrix_step;
            emax4 = emax;
            Frame4 = Frame;
            hel_templist4 = hel_templist;
            hel_templist_step4 = hel_templist_step;
            meanlist4=meanlist;
            meanlist_step4=meanlist_step;
            px_per_cm4=px_per_cm;
            TG_templist4=TG_templist;
            TG_templist_step4=TG_templist_step;
            plasmaframe4=plasmaframe;
            helicon_start4=helicon_start;
            % TC_radius4=TC_radius;
            % shotnumber4=shotnumber;
            % zoomframes4 = zoomframes;
            % TG_frame4 = TG_frame;
            % finalframenumber4=finalframenumber;

            px_per_m4=px_per_cm4*100;
            hel_radius4 = 3/px_per_m4;%pixels per m.
            area_hel4 = pi*(hel_radius4^2); %same as area_TG;
            TG_radius4 = 3/px_per_m4;
            avg_side4 = (87*2)/px_per_m4;
            avg_area4 = avg_side4^2;

            TG_powerdensity_step4 = ((Cp*TG_templist_step4*thickness*density)/delta_tframe)/1E6; %MW/m2
            hel_powerdensity_step4 = ((Cp*hel_templist_step4*thickness*density)/delta_tframe)/1E6; %MW/m2
            avg_powerdensity_step4 = ((Cp*meanlist_step4*thickness*density)/delta_tframe)/1E6; %MW/m2

            TG_power_step4 = TG_powerdensity_step4*area_TG1*1000;  %kW
            hel_power_step4 = hel_powerdensity_step4*area_hel1*1000; %kW
            avg_power_step4 = avg_powerdensity_step4*avg_area1*1000; %kW

            zoomframes4 = length(hel_templist4);
            
            end
    end
end

if number2compare == 1 
     time1=zeros(zoomframes1,1);
    for i = 1:plasmaframe1
        time1(i) = helicon_start-(plasmaframe1-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe1:zoomframes1
        time1(i) = helicon_start+(i-plasmaframe)*0.01;
        i=i+1;
    end
    
    figure;
    %plot(1:zoomframes1,TG_powerdensity_step1,'-k.',1:zoomframes1,hel_powerdensity_step1,'-b.',1:zoomframes1,avg_powerdensity_step1,'-m.')
    plot(time1,TG_powerdensity_step1,'LineWidth',2,'-k.',time1,hel_powerdensity_step1,'LineWidth',2,'-b.',time1,avg_powerdensity_step1,'LineWidth',2,'-m.')
    ax.FontSize = 13;
    title(['Power Density between Frames'],'FontSize',13);
    xlabel('Time(s)','FontSize',13);
    ylabel('Power Density (MW/m2)','FontSize',13);
    legend('TG','Helicon','Average'); 
    legend('Location','Northwest')

    figure;
    plot(time1,avg_power_step1,'LineWidth',2,'-m.')
    ax.FontSize = 13;
    title(['Power between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Power(kW)','FontSize',13);
    legend('Average'); 
    legend('Location','Northwest')
    
end

if number2compare == 2
     time1=zeros(zoomframes1,1);
    for i = 1:plasmaframe1
        time1(i) = helicon_start1-(plasmaframe1-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe1:zoomframes1
        time1(i) = helicon_start1+(i-plasmaframe1)*0.01;
        i=i+1;
    end
     time2=zeros(zoomframes2,1);
    for i = 1:plasmaframe2
        time2(i) = helicon_start2-(plasmaframe2-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe2:zoomframes2
        time2(i) = helicon_start2+(i-plasmaframe2)*0.01;
        i=i+1;
    end
   
    figure; %plot the TG/edge power density for all three shots 
    plot(time1,TG_templist_step1,'-r','LineWidth',2)
    hold on
    plot(time2,TG_templist_step2,'-.b','LineWidth',2)
    ax.FontSize = 13;
    xlim([4.1 4.6]);
    title(['Delta T for TG/Edge between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)]);
    legend('Location','Northwest')
    
    figure; %plot the center/helicon power density for all three shots
    plot(time1,hel_templist_step1,'-r','LineWidth',2)
    hold on
    plot(time2,hel_templist_step2,'-.b','LineWidth',2)
    ax.FontSize = 13;
    xlim([4.1 4.6]);
    title(['Delta T for Helicon/Center between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)]);
    legend('Location','Northwest')
    
    figure; % plot the average power density for all three shots
    plot(time1,meanlist_step1,'-r','LineWidth',2)
    hold on
    plot(time2,meanlist_step2,'-.b','LineWidth',2)
    ax.FontSize = 13;
    xlim([4.1 4.6]);
    title(['Delta T for Average between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)]);
    legend('Location','Northwest')

    figure; %plot the TG/edge power density for all three shots 
    plot(time1,TG_templist1,'-r','LineWidth',2)
    hold on
    plot(time2,TG_templist2,'-b.','LineWidth',2)
    ax.FontSize = 13;
    title(['Delta T  for TG/Edge'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)]);
    legend('Location','Northwest')
    
    figure; %plot the center/helicon power density for all three shots
    plot(time1,hel_templist1,'-r','LineWidth',2)
    hold on
    plot(time2,hel_templist2,'-b.','LineWidth',2)
    ax.FontSize = 13;
    title(['Delta T for Helicon/Center'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)]);
    legend('Location','Northwest')
    
    figure; % plot the average power density for all three shots
    plot(time1,meanlist1,'-r','LineWidth',2)
    hold on
    plot(time2,meanlist2,'-b.','LineWidth',2)
    ax.FontSize = 13;
    title(['Delta T for Average'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)]);
    legend('Location','Northwest')
    
%     figure;
%     plot(time1,avg_power_step1,'-r','LineWidth',2)
%     hold on
%     plot(time2,avg_power_step2,'-.b','LineWidth',2)
%     ax.FontSize = 13;
%     xlim([4.1 4.6]);
%     title(['Power between Frames'],'FontSize',13);
%     xlabel('Time (s)','FontSize',13);
%     ylabel('Power(kW)','FontSize',13);
%     legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)]);
%     legend('Location','Northwest')

end

if number2compare == 3
         time1=zeros(zoomframes1,1);
    for i = 1:plasmaframe1
        time1(i) = helicon_start1-(plasmaframe1-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe1:zoomframes1
        time1(i) = helicon_start1+(i-plasmaframe1)*0.01;
        i=i+1;
    end
     time2=zeros(zoomframes2,1);
    for i = 1:plasmaframe2
        time2(i) = helicon_start2-(plasmaframe2-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe2:zoomframes2
        time2(i) = helicon_start2+(i-plasmaframe2)*0.01;
        i=i+1;
    end
    time3=zeros(zoomframes3,1);
    for i = 1:plasmaframe3
        time3(i) = helicon_start3-(plasmaframe3-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe3:zoomframes3
        time3(i) = helicon_start3+(i-plasmaframe3)*0.01;
        i=i+1;
    end
    
    figure; %plot the TG/edge power density for all three shots
    plot(time1,TG_templist_step1,'-r','LineWidth',2)
    hold on
    plot(time2,TG_templist_step2,'-.b','LineWidth',2)
    hold on
    plot(time3,TG_templist_step3,'--g.','LineWidth',2)
    ax.FontSize = 13;
    xlim([4.1 4.6]);
    title(['Delta T for TG/Edge between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)]);
    legend('Location','Northwest')
    
    figure; %plot the center/helicon power density for all three shots
    plot(time1,hel_templist_step1,'-r','LineWidth',2)
    hold on
    plot(time2,hel_templist_step2,'-.b','LineWidth',2)
    hold on
    plot(time3,hel_templist_step3,'--g.','LineWidth',2)
    ax.FontSize = 13;
    xlim([4.1 4.6]);
    title(['Delta T for Helicon/Center between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)]);
    legend('Location','Northwest')
    
    figure; % plot the average power density for all three shots
    plot(time1,meanlist_step1,'-r','LineWidth',2)
    hold on
    plot(time2,meanlist_step2,'-.b','LineWidth',2)
    hold on
    plot(time3,meanlist_step3,'--g.','LineWidth',2)
    ax.FontSize = 13;
    xlim([4.1 4.6]);
    title(['Delta T for Average between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)]);
    legend('Location','Northwest')

    figure; %plot the TG/edge power density for all three shots 
    plot(time1,TG_templist1,'-r','LineWidth',2)
    hold on
    plot(time2,TG_templist2,'-.b','LineWidth',2)
    hold on
    plot(time3,TG_templist3,'--g','LineWidth',2)
    ax.FontSize = 13;
    title(['Delta T  for TG/Edge'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)]);
    legend('Location','Northwest')
    
    figure; %plot the center/helicon power density for all three shots
    plot(time1,hel_templist1,'-r','LineWidth',2)
    hold on
    plot(time2,hel_templist2,'-.b','LineWidth',2)
    hold on
    plot(time3,hel_templist3,'--g','LineWidth',2)
    ax.FontSize = 13;
    title(['Delta T for Helicon/Center'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)]);
    legend('Location','Northwest')
    
    figure; % plot the average power density for all three shots
    plot(time1,meanlist1,'-r','LineWidth',2)
    hold on
    plot(time2,meanlist2,'-.b','LineWidth',2)
    hold on
    plot(time3,meanlist3,'--g','LineWidth',2)
    ax.FontSize = 13;
    title(['Delta T for Average'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)]);
    legend('Location','Northwest')
%     figure;
%     plot(time1,avg_power_step1,'-m.')
%     hold on
%     plot(time2,avg_power_step2,'-b.')
%     hold on
%     plot(time3,avg_power_step3,'-k.')
%     ax.FontSize = 13;
%     title(['Power between Frames'],'FontSize',13);
%     xlabel('Time (s)','FontSize',13);
%     ylabel('Power(kW)','FontSize',13);
%     legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)]);
%     legend('Location','Northwest')
    
end

if number2compare == 4 
    time1=zeros(zoomframes1,1);
    for i = 1:plasmaframe1
        time1(i) = helicon_start1-(plasmaframe1-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe1:zoomframes1
        time1(i) = helicon_start1+(i-plasmaframe1)*0.01;
        i=i+1;
    end
     time2=zeros(zoomframes2,1);
    for i = 1:plasmaframe2
        time2(i) = helicon_start2-(plasmaframe2-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe2:zoomframes2
        time2(i) = helicon_start2+(i-plasmaframe2)*0.01;
        i=i+1;
    end
    time3=zeros(zoomframes3,1);
    for i = 1:plasmaframe3
        time3(i) = helicon_start3-(plasmaframe3-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe3:zoomframes3
        time3(i) = helicon_start3+(i-plasmaframe3)*0.01;
        i=i+1;
    end
        time4=zeros(zoomframes4,1);
    for i = 1:plasmaframe4
        time4(i) = helicon_start4-(plasmaframe4-i)*0.01;
        i=i+1;
    end
    for i = plasmaframe4:zoomframes4
        time4(i) = helicon_start4+(i-plasmaframe4)*0.01;
        i=i+1;
    end
    
    figure; %plot the TG/edge power density for all three shots
    plot(time1,TG_templist_step1,'-r','LineWidth',2)
    hold on
    plot(time2,TG_templist_step2,'-.b','LineWidth',2)
    hold on
    plot(time3,TG_templist_step3,'--g.','LineWidth',2)
    plot(time4,TG_templist_step4,'-*k','LineWidth',2)
    ax.FontSize = 13;
    xlim([4.1 4.6]);
    title(['Delta T for TG/Edge between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)],['Shot 4:',FILENAME4(1:end-4)]);
    legend('Location','Northwest')
    
    figure; %plot the center/helicon power density for all three shots
    plot(time1,hel_templist_step1,'-r','LineWidth',2)
    hold on
    plot(time2,hel_templist_step2,'-.b','LineWidth',2)
    hold on
    plot(time3,hel_templist_step3,'--g.','LineWidth',2)
    plot(time4,hel_templist_step4,'-*k','LineWidth',2)
    ax.FontSize = 13;
    xlim([4.1 4.6]);
    title(['Delta T for Helicon/Center between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)],['Shot 4:',FILENAME4(1:end-4)]);
    legend('Location','Northwest')
    
    figure; % plot the average power density for all three shots
    plot(time1,meanlist_step1,'-r','LineWidth',2)
    hold on
    plot(time2,meanlist_step2,'-.b','LineWidth',2)
    hold on
    plot(time3,meanlist_step3,'--g.','LineWidth',2)
    plot(time4,meanlist_step4,'-*k','LineWidth',2)
    ax.FontSize = 13;
    xlim([4.1 4.6]);
    title(['Delta T for Average between Frames'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)],['Shot 4:',FILENAME4(1:end-4)]);
    legend('Location','Northwest')

    figure; %plot the TG/edge power density for all three shots 
    plot(time1,TG_templist1,'-r','LineWidth',2)
    hold on
    plot(time2,TG_templist2,'-.b','LineWidth',2)
    hold on
    plot(time3,TG_templist3,'--g','LineWidth',2)
    plot(time4,TG_templist4,'-*k','LineWidth',2)
    ax.FontSize = 13;
    title(['Delta T  for TG/Edge'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)],['Shot 4:',FILENAME4(1:end-4)]);
    legend('Location','Northwest')
    
    figure; %plot the center/helicon power density for all three shots
    plot(time1,hel_templist1,'-r','LineWidth',2)
    hold on
    plot(time2,hel_templist2,'-.b','LineWidth',2)
    hold on
    plot(time3,hel_templist3,'--g','LineWidth',2)
    plot(time4,hel_templist4,'-*k','LineWidth',2)
    ax.FontSize = 13;
    title(['Delta T for Helicon/Center'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)],['Shot 4:',FILENAME4(1:end-4)]);
    legend('Location','Northwest')
    
    figure; % plot the average power density for all three shots
    plot(time1,meanlist1,'-r','LineWidth',2)
    hold on
    plot(time2,meanlist2,'-.b','LineWidth',2)
    hold on
    plot(time3,meanlist3,'--g','LineWidth',2)
    plot(time4,meanlist4,'-*k','LineWidth',2)
    ax.FontSize = 13;
    title(['Delta T for Average'],'FontSize',13);
    xlabel('Time (s)','FontSize',13);
    ylabel('Delta T (C)','FontSize',13);
    legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)],['Shot 4:',FILENAME4(1:end-4)]);
    legend('Location','Northwest')
    
    
%     figure;
%     plot(time1,avg_power_step1,'-m.')
%     hold on
%     plot(time2,avg_power_step2,'-b.')
%     hold on
%     plot(time3,avg_power_step3,'-k.')
%     hold on
%     plot(time4,avg_power_step4,'-g.')
%     ax.FontSize = 13;
%     title(['Power between Frames'],'FontSize',13);
%     xlabel('Time (s)','FontSize',13);
%     ylabel('Power(kW)','FontSize',13);
%     legend(['Shot 1:' FILENAME1(1:end-4)],['Shot 2:',FILENAME2(1:end-4)],['Shot 3:',FILENAME3(1:end-4)],['Shot 4:',FILENAME4(1:end-4)]);
%     legend('Location','Northwest')
%    
end
%     
% 
% 
