function [Result] = ReadADC0()
address= hex2dec('00020000');
adc0 = read_register_gui(address);
Result = Num2mV(adc0,handles.adc0.p1,handles.adc0.p2); 
end