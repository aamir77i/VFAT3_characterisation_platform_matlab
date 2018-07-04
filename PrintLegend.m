function  PrintLegend(title_string,VFAT3_no ,Arm_dac_fC,Arm_dac_value,Front_end_Gain,Peaking_Time,x,y)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
lgd = legend;
lgd.FontSize = 14;
lgd.Title.String = title_string;
lgd.TextColor = 'red';
lgd.String = (VFAT3_no);

text(x,y,str);
str = ['ArmDac(fC):',num2str(Arm_dac_fC),'fC (',num2str(Arm_dac_fC * 6241.51),'e)'];
%text  = num2str('ArmingTh',Arm_dac_fC,'fC');

end

