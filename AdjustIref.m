function [IREF] =  AdjustIref()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Adjust IREF 
Adjust_IREF  = [202 0 5 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,Adjust_IREF);
A = uint8(fread(t,4));
fclose(t);

IREF=A(1);
%ADC= double(uint16( 256*uint16(A(4))+ uint16(A(3))))*0.0625;
  %  formatSpec = 'IREF = %d , adc = %5.2f \n';

%fprintf(formatSpec,IREF,ADC);
end

