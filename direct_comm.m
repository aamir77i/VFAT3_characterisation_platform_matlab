function [output_data] = direct_comm(input_data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%sync_soft  = [202 0 0  0 3 uint8(hex2dec('17'))  uint8(hex2dec('17')) uint8(hex2dec('17'))]';

 
t = tcpip('192.168.1.10',7);
t.InputBufferSize = 4096;
t.Timeout = 1;
fopen(t);
fwrite(t,input_data);
output_data = fread(t,1024);
fclose(t);
end