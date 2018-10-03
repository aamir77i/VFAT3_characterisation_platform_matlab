function [A] = sync_chip_dpa()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
sync  = [202 0 2 ]';

 
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sync);
A = fread(t,4);
fclose(t);


if A(1) == 58
    formatSpec = 'received  %x , sync OK \n';
else
    
    
    formatSpec = 'received  %x , sync fail \n';
end

fprintf(formatSpec,A(1));
end

