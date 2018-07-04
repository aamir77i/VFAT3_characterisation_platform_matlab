function scurveplot2d(ch_arr, fc_arr,scurve)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[x, y] = meshgrid(ch_arr, fc_arr); % 2d meshgrid
temp = scurve;
for i=1:size(temp,1)
    for j=1: size(temp,2)
    if temp(i,j)== 0
        temp(i,j) = nan;
    end
    end
end
%subplot(6,2,2);
z = temp'; % sample data, use your own variable
p = pcolor(x,y,z);
p.EdgeAlpha = 0;
cb = colorbar;
xlabel 'channel # ';
ylabel 'Vcal(fC)';
title 'scurve After trimming';
cb.Label.String = 'Ocuppancy(Hits)';
grid on;
grid 'minor';

end

