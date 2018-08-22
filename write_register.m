function [read_data] = write_register(address,data,sc_hw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% sc read
WRITE = uint8(1);


sc  = [202 uint8(sc_hw) 1 WRITE fliplr(typecast(uint32(address),'uint8')) fliplr(typecast(uint32(data),'uint8')) ]';

  
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sc);
A = uint8(fread(t,4));
fclose(t);
read_data = typecast(A, 'uint32');

end

