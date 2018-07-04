%% Threhold trimming routine based on Trim_fit Algorithm
% stable version 
% 
% run3 
% scurve at 5,4,3,2,1 fC
% perform trimming at 3.0fC
% run scurve at 5,4,3 ,2,1 fC again 
% compare the results


% last updated on 10 May 2018 
%%

clearvars;
%%



VFAT3_NUMBER = 'vfat3#2941';
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



%% front end settings
Peaking_time = "100"; 
Pre_Gain =  "HG"  ;%"Medium" , " High" 
set_preamp(Peaking_time,Pre_Gain);
%%
front_end_default  = [202 255 9 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,front_end_default);
fclose(t);

%%

