function [read_data] = write_register_gui(address,data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% sc read
address = uint32(hex2dec('85'));
data    = uint32(hex2dec('aa'));
WRITE = uint8(1);


sc  = [202 uint8(0) 1 WRITE fliplr(typecast(uint32(address),'uint8')) fliplr(typecast(uint32(data),'uint8')) ]'

  
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sc);
A = uint8(fread(t,12));
fclose(t);
read_data = typecast(A, 'uint32');

end

