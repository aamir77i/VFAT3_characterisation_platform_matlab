function [read_data] = read_register_multiple(address,NUM_OF_READS)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% sc read
READ = uint8(0);
%NUM_OF_READS = uint32(0);

sc  = [202 255 1 fliplr(typecast(uint32(address),'uint8')) fliplr(typecast(uint32(NUM_OF_READS),'uint8')) ]'

  
t = tcpip('192.168.1.10',7);
t.InputBufferSize= 4096;
fopen(t);

fwrite(t,sc);
for i=1:NUM_OF_READS
A(:,i) = uint8(fread(t,4000));

end
temp=typecast(A, 'uint32');
read_data = reshape(temp,[1,4000]);
fclose(t);


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