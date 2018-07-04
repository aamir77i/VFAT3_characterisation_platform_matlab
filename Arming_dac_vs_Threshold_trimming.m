%% Threhold trimming routine based on Trim_fit Algorithm
% stable version 
% last updated on 10 May 2018 
%%

clearvars;
%% sync the chip
sync  = [202 0 2 ]';

 
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sync);
A = fread(t,1);
fclose(t);


if A == 58
    formatSpec = 'received  %x , sync OK \n';
else
    
    
    formatSpec = 'received  %x , sync fail \n';
end

fprintf(formatSpec,A);

%% Adjust IREF 
Adjust_IREF  = [202 0 5 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,Adjust_IREF);
A = uint8(fread(t,4));
fclose(t);

IREF=A(1);
ADC= double(uint16( 256*uint16(A(4))+ uint16(A(3))))*0.0625;
    formatSpec = 'IREF = %d , adc = %5.2f \n';

fprintf(formatSpec,IREF,ADC);

%% Cal_dac to fC 
Cal_dac_to_fc  = [202 255 7 0 1 255 ]';
t = tcpip('192.168.1.10',7);
t.InputBufferSize = 1024;
fopen(t);
fwrite(t,Cal_dac_to_fc);
A = uint8(fread(t,2));
B = uint8(fread(t,1024));
fclose(t);
%%
base_val = double(typecast(A, 'uint16'));
data_caldac = typecast(B, 'uint16');
cal_dac= data_caldac(1:2:end);
adccal_dac= data_caldac(2:2:end);
charge = (double(fliplr(adccal_dac(:)))  -  base_val )*.00625;% capacitor =100fF
figure();
plot(cal_dac,charge);
title ' CAL DAC to fC '
xlabel ' cal_dac';
ylabel ' mvolts';
%% linear fit
[Lfit_caldac,gof_caldac] = LinearFit(charge,cal_dac);
[Lfit_charge,gof_charge] = LinearFit(cal_dac,charge);% to find min fc_step

step_fc = abs(Lfit_charge(0) - Lfit_charge(1))% input dac values to get charge value
%m = Lfit_charge.p1;
%c = Lfit_charge.p2;
%Lfit_charge(2)

 %temp_dac = uint8(round(Lfit_caldac(4)));

%% do scurve for all channels
   % clear all trimming registers
for i=0 : 127
    write_register(i,0);
end
%%
Peaking_time = "100"; 
Pre_Gain =  "HG"  ;%"Medium" , " High" 
set_preamp(Peaking_time,Pre_Gain);
%%
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(10);
arm_dac = 25;
D1 = uint16(5) ;D2 = uint16(500) ;DELAY = uint8(10);
start_fc = 0.5 ;
stop_fc = 20.0 ;
num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;

fc_arr = double(start_fc:step_fc:stop_fc);
fc_size = size(fc_arr,2);
 
dac = uint8(round(Lfit_caldac(fc_arr)));
i=1;
while(arm_dac<=100)
    arm_dac_arr(i)= arm_dac;
[scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac);
%scurve_Multichannels  It performs scurve for more than one channel
Threshold_arr(i) = M_O_mean_Th;
i = i+1;
arm_dac=arm_dac+25;
end
%%

%text(20,12,str1  );
%% remove outliers points
%arm_dac_arr2 = arm_dac_arr     (4:end  -  4)
%Threshold_arr2 = Threshold_arr (4:end  -  4) 
%% linear fitting
[Arming_fit,~] = LinearFit(Threshold_arr,arm_dac_arr);

%%

figure();
plot(arm_dac_arr,Threshold_arr,'r--x');
title 'Threshold vs arm dac'
xlabel 'arm dac(global)'
ylabel 'threshold (fC)'

str1 = strcat("(",Peaking_time," , ", Pre_Gain,")");
str2 = strcat("( m=",num2str(Arming_fit.p1),",c= ",num2str(Arming_fit.p2),")");
text(25,4.3,str1 );
text(25,4,11,str2 );
dac_val = uint16(Arming_fit(5))
%%
save ('Arming_fit.mat','Arming_fit')

