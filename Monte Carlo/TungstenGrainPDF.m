%% Cold Rolled Tunsten Grain Misoreintation Distribution

%x=misorientation angle in deg
%y=Number Fraction

ColdRolledWMisDis = [3.3293035336143797, 0.3193403087866532;
6.5829898254056785, 0.05761963630407563;
9.871618380566488, 0.025555429895134207;
13.070239409101365, 0.032277915787585376;
16.109748345507224, 0.014671850809014786;
19.306809451570253, 0.028998958751750015;
22.426966379770928, 0.018233933773491418;
25.707327345830908, 0.02647422423105572;
28.740908576843726, 0.037765723043564736;
31.856541729876025, 0.04905410201113003;
34.97747861931262, 0.034486766007729375;
38.09389173358084, 0.04197283395015261;
41.45412073019971, 0.060856475433170965;
44.49191375188653, 0.05161549470991289;
47.692094702893264, 0.05073335855207989;
50.89695542131555, 0.027037356243394706;
54.014928458055635, 0.02691880213553388;
57.127597758391396, 0.052655962998639005;
60.41154654613667, 0.04340562274054982];

% Plot distribution and curve fitting

figure
Fig1=plot(ColdRolledWMisDis(:,1),ColdRolledWMisDis(:,2),'ok');
ax = gca;
ax.FontSize = 13;
title('Colled rolled W grain misorientation distribution')
xlabel('Misoreintation angle [deg]', 'FontSize', 13);
ylabel('Number Fraction', 'FontSize', 13);
xlim([0 65])
ylim([0 0.4])
hold on

% Curve fitting
%cftool(ColdRolledWMisDis(:,1),ColdRolledWMisDis(:,2))
%yielded a power fit with 2 terms:

f1.x=0:1:60;
f1.a=49.51;
f1.b=-4.295;
f1.c=0.03672;
f1.fun=f1.a*(f1.x.^f1.b)+f1.c;

plot(f1.x,f1.fun);
hold off

%% Tungsten fuzz growth at misorientation angle

FuzzMisDis=[18.00881826	0.984505083;
26.93603412	0.980861321;
28.03880785	0.980411209;
28.98404247	0.980025399;
29.98179012	0.979618155;
35.02316646	1.006131879;
35.97277717	2.005744283;
36.96602371	0.976767448;
40.01177971	0.975524282;
47.05302745	2.001221732;
48.99175867	1.029001842;
49.98938129	1.00002322;
51.10528328	3.99956775;
52.98712538	2.02737108;
57.09176921	3.997124286;
58.03700383	3.996738476;
59.06088297	9.967749138;
60.00186653	8.995936491 ];

% Plot distribution and curve fitting

figure
Fig2=plot(FuzzMisDis(:,1),(FuzzMisDis(:,2)./max(FuzzMisDis)),'ok');
ax = gca;
ax.FontSize = 13;
title('Number of grains with W fuzz at a given mis. angle')
xlabel('Misoreintation angle [deg]', 'FontSize', 13);
ylabel('Counts', 'FontSize', 13);
xlim([0 65])
ylim([0 1])
hold on

% Curve fitting
%cftool(FuzzMisDis(:,1),FuzzMisDis(:,2))
%yielded a 2 term power fit:

f2.x=0:1:65;
f2.a=1.527E-14;
f2.b=8.255;
f2.c=0.7568;
f2.fun=f2.a*(f2.x.^f2.b)+f2.c;
plot(f2.x,f2.fun./max(f2.fun));
hold off

%% 5 deg magnetic field angle

Mag5IncAng=[1.970133613	0.003838093;
6.824440369	0.014601248;
11.79081885	0.031444027;
16.91235118	0.04132691;
21.80217157	0.041341271;
27.09952551	0.03800881;
31.90463715	0.023661689;
37.11524467	0.006584481;
42.29150293	-9.63526E-05;
47.18074113	9.42179E-05;
51.41064827	-0.000157677;
56.82793351	0.000210656;
61.98235962	0.000137688;
67.26894303	6.51083E-05;
71.36523739	0.00025335;
77.04829273	0.000181935;
82.20300993	2.08618E-05;
86.5636189	0.00020988];

% Plot distribution and curve fitting

figure
Fig3=plot(Mag5IncAng(:,1),(Mag5IncAng(:,2)),'ok');
ax = gca;
ax.FontSize = 13;
title('Impact angle for a 5deg magnetic field angle')
xlabel('Angle of Incidence [deg]', 'FontSize', 13);
ylabel('Rate of Incidence per 1 deg', 'FontSize', 13);
xlim([0 90])
ylim([0 0.1])
hold on

% Curve fitting
%cftool(Mag5IncAng(:,1),Mag5IncAng(:,2))
%yielded a 5 term 4n poly fit:

f3.x=0:1:90;
f3.p1 =  -2.356e-08;
f3.p2 =   4.821e-06;
f3.p3 =  -0.0003243;
f3.p4 =  0.007374;
f3.p5 =  -0.01438;

f3.fun=f3.p1*f3.x.^4 + f3.p2*f3.x.^3 + f3.p3*f3.x.^2 + f3.p4*f3.x + f3.p5;

plot(f3.x,f3.fun);
hold off

%% 20deg magnetic field angle

Mag20IncAng=[1.850202311	0.0001373;
7.133001485	0.001210084;
11.8825139	0.003690993;
17.0180188	0.009344841;
22.27985911	0.016761176;
27.01569004	0.023383014;
36.64803656	0.0279928;
31.89473991	0.026657255;
41.53727476	0.028183371;
46.70334469	0.024586208;
52.2676331	0.02046158;
57.1824877	0.012898922;
61.95994527	0.006921763;
66.99560446	0.002795583;
72.02573283	0.000343396;
76.78368701	0.000269263;
81.93665764	0.00063682];

% Plot distribution and curve fitting

figure
Fig4=plot(Mag20IncAng(:,1),(Mag20IncAng(:,2)),'ok');
ax = gca;
ax.FontSize = 13;
title('Impact angle for a 20deg magnetic field angle')
xlabel('Angle of Incidence [deg]', 'FontSize', 13);
ylabel('Rate of Incidence per 1 deg', 'FontSize', 13);
xlim([0 90])
ylim([0 0.1])
hold on

% Curve fitting
%cftool(Mag20IncAng(:,1),Mag20IncAng(:,2))
%yielded a 6 term 5n poly fit:

f4.x=0:1:90;
f4.p1 =-1.818E-10;
f4.p2 =5.52E-08;
f4.p3 = -5.51E-6;
f4.p4 =  0.000201;
f4.p5 = -0.001674;
f4.p6 = 0.003294;

f4.fun=f4.p1*f4.x.^5 + f4.p2*f4.x.^4 + f4.p3*f4.x.^3 + f4.p4*f4.x.^2 + f4.p5*f4.x + f4.p6;

plot(f4.x,f4.fun);
hold off

%% 45 deg magnetic field angle 

Mag45IncAng=[13.48033651	0;
6.609029779	0;
22.1986435	0.001342435;
31.3014875	0.006214984;
39.86434955	0.01452207;
49.09090909	0.021950048;
57.80339417	0.02497123;
67.45961051	0.022356417;
76.07166769	0.01577378;
85.09125841	0.005844322;
89.4693331	0.000747048];


% Plot distribution and curve fitting

figure
Fig4=plot(Mag45IncAng(:,1),(Mag45IncAng(:,2)),'ok');
ax = gca;
ax.FontSize = 13;
title('Impact angle for a 45deg magnetic field angle')
xlabel('Angle of Incidence [deg]', 'FontSize', 13);
ylabel('Rate of Incidence per 1 deg', 'FontSize', 13);
xlim([0 90])
ylim([0 0.1])
hold on

% Curve fitting
%cftool(Mag45IncAng(:,1),Mag45IncAng(:,2))
%yielded a 6 term 5n poly fit:

f5.x=0:1:90;
f5.p1 =4.51E-9;
f5.p2 =-1.197E-6;
f5.p3 =9.04E-05;
f5.p4 =-0.001851;
f5.p5 =0.009571;

f5.fun= + f5.p1*f5.x.^4 + f5.p2*f5.x.^3 + f5.p3*f5.x.^2 + f5.p4*f5.x + f5.p5;

plot(f5.x,f5.fun);
hold off

%% 