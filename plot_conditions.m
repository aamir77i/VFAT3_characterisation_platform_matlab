function plot_conditions(VFAT3_NUMBER,Arming_th,arm_dac,Pre_Gain,Peaking_time)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=80;y0=2.9;
x1=80;y1=2.7;
x2=80;y2=2.6;
%x3=80;y3=-10;
text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);
end

