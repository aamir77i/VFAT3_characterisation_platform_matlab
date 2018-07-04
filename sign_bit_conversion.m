function [Arm_dac] = sign_bit_conversion(din)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%
datain= int16(din);
if(din <0)
temp = bitset(abs(datain),7);
else 
temp = datain;
end
Arm_dac = temp;

