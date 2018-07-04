function [read_data] = write_register(address,data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% sc read
WRITE = uint8(1);

DATA = data;
sc  = [202 0 1 WRITE 0 0  fliplr(typecast(uint16(address),'uint8')) 0 0 fliplr(typecast(uint16(DATA),'uint8')) ]';

  
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sc);
A = uint8(fread(t,4));
fclose(t);
read_data = typecast(A, 'uint32');

end

