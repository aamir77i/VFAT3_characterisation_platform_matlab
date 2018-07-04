function [fitresult, gof] = LinearFit(x, y,VFAT3_NUMBER,x_label,y_label)
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

% Plot fit with data.
figure( 'Name', 'LinearFit' );
h = plot( fitresult, xData, yData );
legend( h, 'dac vs. charge', 'LinearFit', 'Location', 'NorthEast' );
% Label axes
xlabel (x_label)
ylabel (y_label)
grid on
str0 = ['',VFAT3_NUMBER];
%str1 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
str2 = [ 'Y = p1*X + p2 (p1:',num2str(round(fitresult.p1,2)),',','p2:',num2str(round(fitresult.p2,2)),')'];
x0=min(xData)+ .1;y0=max(yData)- 1;
x1=x0 ;y1=y0 - 2;
x2=x0; y2=y1 - 2;
text(x0,y0,str0);
%text(x1,y1,str1);
text(x2,y2,str2);
