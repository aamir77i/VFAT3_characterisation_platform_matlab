function DAC_SCAN(DAC_no,start,step,stop)
%%
clearvars;

%%
DAC_no= 6
start =0
step=10
stop= 255
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%Request:   ------CA 00 09  START STEP STOP Mon_sel_msb Mon_sel,Mon_sel, Mon_sel_lsb


DAC_SCAN_Command  = [202 0 9 uint8(start) uint8(step) uint8(stop) 0 0 0 uint8(DAC_no)]'

t = tcpip('192.168.1.10',7);
t.InputBufferSize = ((double(stop-start)/double(step))+1 )*6
fopen(t);
fwrite(t,DAC_SCAN_Command);
%A = uint8(fread(t,2));
%Response :Dac_lsb,dac_msb, adc0_lsb,adc0_msb, adc1_lsb,adc1_msb,
%Dac_lsb,dac_msb, adc0_lsb,adc0_msb,adc1_lsb,adc1_msb,,,,,, so on

B = uint8(fread(t,t.InputBufferSize))
fclose(t);

raw_data = typecast(B, 'uint16');
dac= raw_data(1:3:end);
adc0= raw_data(2:3:end);
adc1= raw_data(3:3:end);

T=table;
T.dac=dac;
T.adc0=adc0;
%T.adc1= adc1;

p1= .523
p2= 161

T.adc0mV = (1/double(p1))* double(adc0) - (double(p2)/double(p1));
T.adc0uA = T.adc0mV/20;
%fitresult_DAC=LinearFit_No_Plot(DAC,adc0);
%fitresult_adc1=LinearFit_No_Plot(ext_adc,adc1);
T
%save 'adc_data.mat'
%charge = (double(fliplr(adccal_dac(:)))  -  base_val )*.00625;% capacitor =100fF
% figure();
% plot(cal_dac,charge);
% title ' CAL DAC to fC '
% xlabel ' cal_dac';
% ylabel ' mvolts';
 % linear fit
%  x_label = 'charge(fC)';
%  y_label ='cal dac';
% [Lfit_caldac,gof_caldac] = LinearFit(charge,cal_dac,VFAT3_NUMBER,x_label,y_label);
% x_label = 'cal dac';
%  y_label ='charge (fC)';
% [Lfit_charge,gof_charge] = LinearFit(cal_dac,charge,VFAT3_NUMBER,x_label,y_label);% to find min fc_step
% 
% step_fc = abs(Lfit_charge(0) - Lfit_charge(1));% input dac values to get charge value
figure
plot(T.dac,T.adc0mV)
fit=LinearFit_No_Plot(T.dac,T.adc0mV )
fit(150)
end

