function [milliVolts] =  Read_Internal_temp()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Adjust IREF 
command  = [202 255 12 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,command);
A = uint8(fread(t,2));
fclose(t);

milliVolts= (256*double(A(2))+ double(A(1)))*0.0625
%milliVolts= double(uint16( 256*uint16(A(2))+ uint16(A(1))))*0.0625
   
end