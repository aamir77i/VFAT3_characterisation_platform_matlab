clearvars;
%%
%load Arming_fit.mat;


leg     = 'Threshold vs. ArmDac';
x_label =  'Threshold(fC)'; 
y_label =  'ArmDac';

%load Arming_fit.mat;
%VFAT3_NUMBER = 'vfat3#3880';
Peaking_time = "45"; % 15 25 36 45 
Pre_Gain =  "HG"  ;% LG MG HG  
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(1000);
D1 = uint16(5) ;D2 = uint16(400) ;DELAY = uint8(1);
calpulse = uint8(1);
 
%start_fc = -2.0 2
%stop_fc = 20.0 ;

num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;
%% connect  hard reset chip
sync_chip();
%% read chip id
 chip_id=strcat('vfat3-',num2str(read_register(hex2dec('10003'),0)))
 VFAT3_NUMBER = chip_id;
 
 
 %%
 clearvars;
 
 address = uint32(hex2dec('10002'));
 
 for i=1:256
 data = uint32(i-1);
 
 
 %%
 write_register(address,data,0);
%%
result(i)= read_register(address,0);

 end
