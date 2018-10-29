function [data_out] = TX_FCC(data_in,input_data_len)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%%
%data_in = ones(1,12)*hex2dec('17')
%input_data_len = 5;
%%
WORD_SIZE =4;
data_in= uint8(data_in);
LEN = uint16(size(data_in,2))
LEN= fliplr((typecast(LEN,'uint8')));
 
FCC  = [202 0 0  LEN data_in ]';
%%
 
t = tcpip('192.168.1.10',7);
t.OutputBufferSize = size(FCC,1);
t.InputBufferSize = input_data_len;%*2*WORD_SIZE;
t.TimeOut =5;
fopen(t);


fwrite(t,FCC);

A = uint8(fread(t));
fclose(t);
%%
data_out = typecast(A,'uint32'); 


end

