%function [Arming_fit,arm_dac_arr,Threshold_arr] = arm_dac_fc(step_fc,Lfit_caldac)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Threhold trimming routine based on Trim_fit Algorithm
% stable version 
% last updated on 10 May 2018 

clearvars;

leg     = 'ArmDac vs. Threshold';
x_label = 'Threshold(fC)';
y_label = 'ArmDAc';
%load Arming_fit.mat;
VFAT3_NUMBER = 'vfat3#45';
Peaking_time = "45"; % 15 25 36 45 
Pre_Gain =  "HG"  ;% LG MG HG  
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(1000);
D1 = uint16(5) ;D2 = uint16(400) ;DELAY = uint8(1);
calpulse = uint8(1);
 
%start_fc = -2.0 ;
%stop_fc = 20.0 ;

num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;

%% connect  hard reset chip
sync_chip();
%% Adjust IREF 
AdjustIref();

%% Cal_dac to fC
start_fc = 0.0 ;
stop_fc = 6.0 ;
[Lfit_caldac,Lfit_charge,step_fc]= caldac_to_fC(VFAT3_NUMBER);
fc_arr = double(start_fc:step_fc:stop_fc);
fc_size = size(fc_arr,2); 
dac = uint8(round(Lfit_caldac(fc_arr)))
%% front end settings

set_preamp(Peaking_time,Pre_Gain);
%% front end default configurations
front_end_default  = [202 255 9 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,front_end_default);
fclose(t);

%% ensure all trim dacs are at zero
for i=0 : 127
    write_register(i,0);
end
%%
start_fc = 0.0 ;
stop_fc = 30.0 ;
fc_arr = double(start_fc:step_fc:stop_fc);
fc_size = size(fc_arr,2); 
dac = uint8(round(Lfit_caldac(fc_arr)))

        Pre_Gain = "LG";
       set_preamp(Peaking_time,Pre_Gain);
i=1;
arm_dac = 25;
while(arm_dac<=75)
    arm_dac_arr_LG(i)= arm_dac;
[~,~,~,M_O_mean_Th,~,~,~] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
%scurve_Multichannels  It performs scurve for more than one channel
Threshold_arr_LG(i) = M_O_mean_Th;
fprintf('\n\r arm_dac = %d, Threshold_LG = %f, Pre_Gain = %s',arm_dac_arr_LG(i),Threshold_arr_LG(i),Pre_Gain);
i = i+1;
arm_dac=arm_dac+25;
end

 %linear fitting
 
[Arming_fit_LG,~] = Arm_Lfit(Threshold_arr_LG,arm_dac_arr_LG,leg,x_label,y_label,VFAT3_NUMBER,Pre_Gain,Peaking_time);
title('ArmDac vs. Threshold(fC) @ LG ,45 ');
%% 
start_fc = 0.0 ;
stop_fc = 20.0 ;
fc_arr = double(start_fc:step_fc:stop_fc);
fc_size = size(fc_arr,2); 
dac = uint8(round(Lfit_caldac(fc_arr)))
        Pre_Gain = "MG";
       set_preamp(Peaking_time,Pre_Gain);
i=1;
arm_dac = 25;
while(arm_dac<=75)
    arm_dac_arr_MG(i)= arm_dac;
[~,~,~,M_O_mean_Th,~,~,~] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
%scurve_Multichannels  It performs scurve for more than one channel
Threshold_arr_MG(i) = M_O_mean_Th;
fprintf('\n\r arm_dac = %d, Threshold_MG = %f, Pre_Gain = %s',arm_dac_arr_MG(i),Threshold_arr_MG(i),Pre_Gain);
i = i+1;
arm_dac=arm_dac+25;
end

 %linear fitting
[Arming_fit_MG,~] = Arm_Lfit(Threshold_arr_MG,arm_dac_arr_MG,leg,x_label,y_label,VFAT3_NUMBER,Pre_Gain,Peaking_time);
title('ArmDac vs. Threshold(fC) @ MG ,45 ');

%%
start_fc = 0.0 ;
stop_fc = 5.0 ;
fc_arr = double(start_fc:step_fc:stop_fc)
fc_size = size(fc_arr,2) 
dac = uint8(round(Lfit_caldac(fc_arr)))
        Pre_Gain = "HG";
       set_preamp(Peaking_time,Pre_Gain);
i=1;
arm_dac = 25;
while(arm_dac<=100)
    arm_dac_arr_HG(i)= arm_dac;
[~,~,~,M_O_mean_Th,~,~,~] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
%scurve_Multichannels  It performs scurve for more than one channel
Threshold_arr_HG(i) = M_O_mean_Th;
fprintf('\n\r arm_dac = %d, Threshold_HG = %f, Pre_Gain = %s',arm_dac_arr_HG(i),Threshold_arr_HG(i),Pre_Gain);
i = i+1;
arm_dac=arm_dac+25;
end

 %linear fitting
[Arming_fit_MG,~] = Arm_Lfit(Threshold_arr_HG,arm_dac_arr_HG,leg,x_label,y_label,VFAT3_NUMBER,Pre_Gain,Peaking_time);
title('ArmDac vs. Threshold(fC) @ HG ,45');

