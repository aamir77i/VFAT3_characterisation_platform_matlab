function  insert_plot_timestamps(xData,yData,str0,str1,str2,str3)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

xmin =  (min(xData)- (min(xData))/10);
xmax = (max(xData) + (max(xData)/10));%10 % more axis scale
ymin =  (min(yData)- (min(yData))/10);
ymax = (1.1 * max(yData));% 20 % more y scale

axis([xmin   xmax ymin ymax] );


% str0 = ['Chip ID : ',VFAT3_NUMBER];
% str1 = ['',num2str(date)];
% str2 = [ 'Y = p1*X + p2 (p1:',num2str(round(fitresult.p1,2)),',','p2:',num2str(round(fitresult.p2,2)),')'];

x0   = xmin + ((xmax - xmin)* 0.75);%75 percent of x scale  
y0   = ymin + (ymax - ymin)* 0.9;

x1= x0;
y1= ymin + (ymax - ymin)* 0.85;

x2= x0;
y2= ymin + (ymax - ymin)* 0.80;

x3= x0;
y3= ymin + (ymax - ymin)* 0.75;

text(double(x0),double(y0),str0);
text(double(x1),double(y1),str1);
text(double(x2),double(y2),str2);
text(double(x3),double(y3),str3);
end

