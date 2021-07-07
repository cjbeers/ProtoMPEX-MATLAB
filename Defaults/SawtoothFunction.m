

Sawtooth_freq=200; %Hz
Sawtooth_Tri_num=300; %Number of triangles
Sawtooth_time = Sawtooth_Tri_num*(1/Sawtooth_freq); %sample rate
Sawtooth_fs = 100000;
Sawtooth_t = (0:1/Sawtooth_fs:Sawtooth_time-1/Sawtooth_fs);
Sawtooth_y = (sawtooth(2*pi*Sawtooth_freq*Sawtooth_t,1/2))*30;
plot((Sawtooth_t+4.1613),Sawtooth_y)
xlim([-inf inf])
ylim([-inf inf])
grid on