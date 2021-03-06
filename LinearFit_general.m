function [fitresult, gof] = LinearFit_general(x, y,VFAT3_NUMBER,Title,legend_title,x_label,y_label,handles_axes)
%CREATEFIT2(CHARGE,CAL_DAC)
%  Create a fit.
%
%  Data for 'LinearFit' fit:
%      X Input : charge
%      Y Output: cal_dac
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 10-May-2018 18:08:14


%% Fit: 'LinearFit'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Robust = 'Bisquare';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
axes(handles_axes);
cla;
% Plot fit with data.
%figure( 'Name', 'LinearFit' );
h = plot( fitresult, xData, yData );
legend( h, legend_title, 'LinearFit', 'Location', 'NorthEast' );
% Label axes
xlabel (x_label);
ylabel (y_label);
title(Title) ;
xmin =  (min(xData)- (min(xData))/10);
xmax = (max(xData) + (max(xData)/10));%10 % more axis scale
ymin =  (min(yData)- (min(yData))/10);
ymax = (1.1 * max(yData));% 20 % more y scale

axis([xmin   xmax ymin ymax] );


str0 = ['Chip ID : ',VFAT3_NUMBER];
str1 = ['',num2str(date)];
str2 = [ 'Y = p1*X + p2 (p1:',num2str(round(fitresult.p1,2)),',','p2:',num2str(round(fitresult.p2,2)),')'];

x0   = xmin + ((xmax - xmin)* 0.08);%8 percent of x scale  
y0   = ymin + (ymax - ymin)* 0.9;

x1= x0;
y1= ymin + (ymax - ymin)* 0.85;

x2= x0;
y2= ymin + (ymax - ymin)* 0.80;


text(double(x0),double(y0),str0);
text(double(x1),double(y1),str1);
text(double(x2),double(y2),str2);
grid on
%str0 = ['',VFAT3_NUMBER];
%str1 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];




