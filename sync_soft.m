function [A] = sync_soft()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
sync_soft  = [202 0 0  0 3 uint8(hex2dec('17'))  uint8(hex2dec('17')) uint8(hex2dec('17'))]';

 
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sync_soft);
A = fread(t,1);
fclose(t);


if A == 58
    formatSpec = 'received  %x , sync OK \n';
else
    
    
    formatSpec = 'received  %x , sync fail \n';
end

fprintf(formatSpec,A);
end
