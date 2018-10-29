ch_arr = 1:12;
grid on;
grid 'minor';
%Voltage2=Voltage/1.5;
figure();
[x, y] = meshgrid(ch_arr, Voltage); % 2d meshgrid
% temp = scurve;
% for i=1:size(temp,1)
%     for j=1: size(temp,2)
%     if temp(i,j)== 0
%         temp(i,j) = nan;
%     end
%     end
% end
temp(1,:)=vfat1;
temp(2,:)=vfat2;
temp(3,:)=Vfat4258;
temp(4,:)=Vfat4257;
temp(5,:)=Vfat2900;
temp(6,:)=Vfat4933;
temp(7,:)=Vfat2899;
temp(8,:)=Vfat4934;
temp(9,:)=Vfat2901;
temp(10,:)=Vfat2897;
temp(11,:)=Vfat3787;
temp(12,:)=Vfat2898;

%subplot(3,2,1);
z = temp'; % sample data, use your own variable
p = pcolor(x,y,z);
p.EdgeAlpha = 0;
cb = colorbar;
xlabel 'vfat # ';
ylabel 'Supply Voltage(V)';
title 'Correct ChipID reads(1000) vs. Supply Voltage plot(12 VFATS)';
cb.Label.String = 'Voltage(V)';
grid on;
grid 'minor';
