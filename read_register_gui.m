function [read_data] = read_register_gui(address)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% sc read
READ = uint8(0);
DATA = uint32(0);

sc  = [202 uint8(0) 1 READ  fliplr(typecast(uint32(address),'uint8')) fliplr(typecast(uint32(DATA),'uint8')) ]'

  
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sc);
A = uint8(fread(t,4));
fclose(t);
read_data = typecast(A, 'uint32');

end

% 
% 
% %% sc read
% READ = uint8(0);
% DATA = uint16(0);
% 
% sc  = [202 0 1 READ 0 0  fliplr(typecast(uint16(address),'uint8')) 0 0 fliplr(typecast(uint16(DATA),'uint8')) ]';
% 
%   
% t = tcpip('192.168.1.10',7);
% fopen(t);
% fwrite(t,sc);
% A = uint8(fread(t,4));
% fclose(t);
% read_data = typecast(A, 'uint32');
% 
% end