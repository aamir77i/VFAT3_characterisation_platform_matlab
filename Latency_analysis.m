%% Routine to analyze latency for a single channel 
% 
%  
% 
% 
%  
% 


% last updated on 25 June 2018 
%%

clearvars;
%%
%load Arming_fit.mat;


leg     = 'Threshold vs. ArmDac';
x_label =  'Threshold(fC)'; 
y_label =  'ArmDac';

%load Arming_fit.mat;
%VFAT3_NUMBER = 'vfat3#3880';
Peaking_time = "45"; % 15 25 36 45 
Pre_Gain =  "MG"  ;% LG MG HG  
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(20);
LV1As   = uint16(1000);
D1 = uint16(23) ;D2 = uint16(200) ;DELAY = uint8(1);
calpulse = uint8(1);
 
%start_fc = -2.0 2
%stop_fc = 20.0 ;

num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;
%% connect  hard reset chip
sync_chip();
%%
sync_soft();
%%
input_buffer = [202 0 0  0 14 uint8(hex2dec('17')) uint8(hex2dec('17')) uint8(hex2dec('17')) 0 255 0 255 0 255 0 255  uint8(hex2dec('17')) uint8(hex2dec('17')) uint8(hex2dec('17')) ]';
sc_data = []
output_buffer = direct_comm(input_buffer);
%% read chip id
 chip_id=strcat('vfat3#',num2str(read_register(hex2dec('10003'))))
 VFAT3_NUMBER = chip_id;
%% Adjust IREF 
AdjustIref();

%% Cal_dac to fC 
[Lfit_caldac,Lfit_charge,step_fc]= caldac_to_fC(VFAT3_NUMBER);
Max_Caldac = floor(Lfit_charge(0))
%% front end settings
 
set_preamp(Peaking_time,Pre_Gain);
%%
front_end_default  = [202 255 9 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,front_end_default);
A = uint8(fread(t,4));
fclose(t);

%%
% Arming_fit = fc_arm_dac(step_fc,Lfit_caldac,leg,x_label,y_label,VFAT3_NUMBER,Pre_Gain,Peaking_time)
% %save ('Arming_fit_100_HG.mat','Arming_fit');
% %load 'Arming_fit_LG_100.mat';

 %%

 
Max_Caldac = floor(Lfit_charge(0));
start_fc = 0.0 ;
stop_fc = 10;%Max_Caldac;

fc_arr = double(start_fc:step_fc:stop_fc)
fc_size = size(fc_arr,2)
 
dac = uint8(round(Lfit_caldac(fc_arr)))
% [scurve0,mean_th0,mean_enc0,M_O_mean_Th0,M_O_mean_Th_std0,M_O_mean_ENC0,M_O_mean_ENC_std0] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac);

Arming_th=4.0;% start arm_dac from 5.0 and go to some criteria
arm_dac = 30;
%arm_dac = uint8(round(Arming_fit(Arming_th)))
Criteria = 1.0;%fC
i= 1;
%
 
%Arming_th = 2.5;% fC
figure ;
hold on
%for i= 1:10 
%    D1 = uint16(49) +i ;
[scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);

%plot (scurve);
%end
%%
figure;
plot(scurve')

