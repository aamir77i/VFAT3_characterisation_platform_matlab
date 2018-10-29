function  assert_reset()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Adjust IREF 
assert_reset  = [202 221 2 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,assert_reset);
A = uint8(fread(t,4));
fclose(t);


%ADC= double(uint16( 256*uint16(A(4))+ uint16(A(3))))*0.0625;
  %  formatSpec = 'IREF = %d , adc = %5.2f \n';

%fprintf(formatSpec,IREF,ADC);
end

