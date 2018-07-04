function [Arming_fit,arm_dac_arr,Threshold_arr] = arm_dac_fc(step_fc,Lfit_caldac)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Threhold trimming routine based on Trim_fit Algorithm
% stable version 
% last updated on 10 May 2018 

%%
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(1000);
arm_dac = 20;
D1 = uint16(5) ;D2 = uint16(400) ;DELAY = uint8(1);
calpulse = uint8(1);
start_fc = 0.0 ;
stop_fc = 6.0 ;
num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;

fc_arr = double(start_fc:step_fc:stop_fc);
fc_size = size(fc_arr,2);
 
dac = uint8(round(Lfit_caldac(fc_arr)));
i=1;
while(arm_dac<=80)
    arm_dac_arr(i)= arm_dac;
[scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
%scurve_Multichannels  It performs scurve for more than one channel
Threshold_arr(i) = M_O_mean_Th;
i = i+1;
arm_dac=arm_dac+10;
end
%%

%text(20,12,str1  );
%% remove outliers points
%arm_dac_arr2 = arm_dac_arr     (4:end  -  4)
%Threshold_arr2 = Threshold_arr (4:end  -  4) 
%% linear fitting
[Arming_fit,~] = Arm_Lfit(Threshold_arr,arm_dac_arr);

%%

figure();
plot(arm_dac_arr,Threshold_arr,'r--x');
title 'Threshold vs arm dac'
xlabel 'arm dac(global)'
ylabel 'threshold (fC)'

%str1 = strcat("(",Peaking_time," , ", Pre_Gain,")");
%str2 = strcat("( m=",num2str(Arming_fit.p1),",c= ",num2str(Arming_fit.p2),")");
%text(25,4.3,str1 );
%text(25,4,11,str2 );
%dac_val = uint16(Arming_fit(5))
%%
%save ('Arming_fit.mat','Arming_fit')


end

