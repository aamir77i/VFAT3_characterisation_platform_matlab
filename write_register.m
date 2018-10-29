function [crc_error,transaction_error,read_data] = write_register(address,data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% sc read
WRITE = uint8(1);


sc  = [202 uint8(0) 1 WRITE fliplr(typecast(uint32(address),'uint8')) fliplr(typecast(uint32(data),'uint8')) ]';

  
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sc);
A = uint8(fread(t,12));
fclose(t);
data_in = typecast(A, 'uint32');

transaction_error  = bitand(data_in(2),hex2dec('00000001') ,'uint32');
crc                = typecast(data_in(3),'uint16');      
crc_error          = (crc(1) ~= crc(2));
read_data          = data_in(1);
end



