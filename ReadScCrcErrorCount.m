function [crc_error_count]=ReadScCrcErrorCount(ResetCount)

%%
ResetCount=0;
if ResetCount == 1 
    ResetCount= uint8(hex2dec('cc'));
else     

    ResetCount =0;
end

sc  = [202 uint8(hex2dec('dd')) 3  uint8(ResetCount) ]';

  
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sc);
A = uint8(fread(t,4));
fclose(t);
crc_error_count = typecast(A, 'uint32');
%%
end