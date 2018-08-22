function [Lfit_caldac,Lfit_charge,step_fc,cal_dac,charge,A,B] = caldac_to_fC(VFAT3_NUMBER)
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
 x_label = 'charge(fC)';
 y_label ='cal dac';
[Lfit_caldac,gof_caldac] = LinearFit(charge,cal_dac,VFAT3_NUMBER,x_label,y_label);
x_label = 'cal dac';
 y_label ='charge (fC)';
[Lfit_charge,gof_charge] = LinearFit(cal_dac,charge,VFAT3_NUMBER,x_label,y_label);% to find min fc_step

step_fc = abs(Lfit_charge(0) - Lfit_charge(1));% input dac values to get charge value
end

