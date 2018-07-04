function [fitresult, gof] = createFit_trimdac(yy, xx)
%CREATEFIT2(YY,XX)
%  Create a fit.
%
%  Data for 'Trim_fit' fit:
%      X Input : yy
%      Y Output: xx
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 05-May-2018 22:15:49


%% Fit: 'Trim_fit'.
[xData, yData] = prepareCurveData( yy, xx );

% Set up fittype and options.
ft = fittype( 'poly2' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
%%figure( 'Name', 'Trim_fit' );
%%h = plot( fitresult, xData, yData );
%%legend( h, 'xx vs. yy', 'Trim_fit', 'Location', 'NorthEast' );
% Label axes
%%xlabel yy
%%ylabel xx
grid on


