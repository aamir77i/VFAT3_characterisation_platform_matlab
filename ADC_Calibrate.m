function [fitresult_adc0,fitresult_adc1] = ADC_Calibrate(start,step,stop)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
adc_command  = [202 0 6 uint8(start) uint8(step) uint8(stop) ]';
t = tcpip('192.168.1.10',7);
t.InputBufferSize = ((double(stop-start)/double(step))+1 )*8
fopen(t);
fwrite(t,adc_command);
%A = uint8(fread(t,2));
B = uint8(fread(t,t.InputBufferSize))
fclose(t);

raw_data = typecast(B, 'uint16');
dac= raw_data(1:4:end);
ext_adc= raw_data(2:4:end)*.0625;
adc0= raw_data(3:4:end);
adc1= raw_data(4:4:end);
T=table;
T.dac=dac;
T.extadc=ext_adc;
T.adc0= adc0;
T.adc1=adc1;
fitresult_adc0=LinearFit_No_Plot(ext_adc,adc0);
fitresult_adc1=LinearFit_No_Plot(ext_adc,adc1);
T
save 'adc_data.mat'
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
end

