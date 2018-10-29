function [fc_arr,dac_arr,Lfit_charge] = caldac_to_fC_GUI()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Cal_dac_to_fc  = [202 255 7 0 1 255 ]';
t = tcpip('192.168.1.10',7);
t.InputBufferSize = 1024;
fopen(t);
fwrite(t,Cal_dac_to_fc);
A = uint8(fread(t,2));
B = uint8(fread(t,1024));
fclose(t);

base_val = double(typecast(A, 'uint16'));
data_caldac = typecast(B, 'uint16');
cal_dac= data_caldac(1:2:end);
adccal_dac= data_caldac(2:2:end);
charge = (double(fliplr(adccal_dac(:)))  -  base_val )*.00625;% capacitor =100fF
% figure();
% plot(cal_dac,charge);
% title ' CAL DAC to fC '
% xlabel ' cal_dac';
% ylabel ' mvolts';
 % linear fit
%  x_label = 'charge(fC)';
%  y_label ='cal dac';
[Lfit_caldac,~] = LinearFit_No_Plot(charge,cal_dac);
% x_label = 'cal dac';
%  y_label ='charge (fC)';
[Lfit_charge,~] = LinearFit_No_Plot(cal_dac,charge);% to find min fc_step
Max_Caldac = floor(Lfit_charge(0));
step_fc = abs(Lfit_charge(0) - Lfit_charge(1))% input dac values to get charge value
fc_arr = double(0:step_fc:Max_Caldac)
%fc_size = size(fc_arr,2)
 
dac_arr = uint8(round(Lfit_caldac(fc_arr)))
T= table;
T.fc  = fc_arr';
T.dac = dac_arr;
T
[a]=find(fc_arr>=5 & fc_arr<=10)
end

