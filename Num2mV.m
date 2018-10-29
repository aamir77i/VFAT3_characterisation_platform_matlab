function [mV]= Num2mV(adc,p1,p2)
mV = (1/double(p1))* double(adc) - (double(p2)/double(p1));
end
