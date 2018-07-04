function [A] = sync_chip()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
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
end

