function  read_dpa_taps()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
assert_reset();
%%
a=sync_chip()
%% Adjust IREF 
dpa_taps  = [202 221 1 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,dpa_taps);
A = uint8(fread(t,8));
fclose(t);

A= typecast(A,'uint32')
mtap = A(1);
stap = A(2);
fprintf('mtap = %d\nstap = %d\r\n',mtap,stap);
%ADC= double(uint16( 256*uint16(A(4))+ uint16(A(3))))*0.0625;
  %  formatSpec = 'IREF = %d , adc = %5.2f \n';

%fprintf(formatSpec,IREF,ADC);
end

