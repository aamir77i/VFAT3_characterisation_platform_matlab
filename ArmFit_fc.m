function [fitresult, gof] = ArmFit_fc(arm_dac,Threshold,leg,x_label,y_label,VFAT3_NUMBER,Pre_Gain,Peaking_time);
%CREATEFIT2(ARM_DAC_ARR_HG,THRESHOLD_ARR_HG)
%  Create a fit.
%
%  Data for 'ArmFit_fc' fit:
%      X Input : arm_dac_arr_HG
%      Y Output: Threshold_arr_HG
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 04-Jun-2018 20:03:05


%% Fit: 'ArmFit_fc'.
[xData, yData] = prepareCurveData( arm_dac, Threshold );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'ArmFit_fc' );
h = plot( fitresult, xData, yData );
legend( h, leg, 'ArmFit_fc', 'Location', 'SouthEast' );
% Label axes
xlabel(x_label)
ylabel (y_label)
grid on
str0 = ['',VFAT3_NUMBER];
str1 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
str2 = [ '(p1:',num2str(round(fitresult.p1,2)),',','p2:',num2str(round(fitresult.p2,2)),')'];
x0=min(xData)+ 1;y0=max(yData)- 1;
x1=x0 ;y1=y0 - 1;
x2=x0; y2=y1 - 1;
text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);


