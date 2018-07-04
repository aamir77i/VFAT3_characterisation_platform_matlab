%% polyfit example
clearvars;
x=(0:0.25:3)';
%y=erf(x);
y = [0 0 0 20 40 70 80 90 100 100 100 100 100]'/100;
p = polyfit(x,y,6);
f= polyval(p,x);
T= table(x,y,f,y-f, 'VariableNames',{'X','Y','FIT','FIT_ERROR'})
plot(x,y);
hold on;
plot(x,f);
title('scurve data');
xlabel(' fC ');
ylabel('efficiency');

%% load labview data
load 'scurve.txt';
load 'fC.txt';
channels = size(scurve,2)% no. of columns 
fC_steps = size(scurve,1)% no. of rows
plot(fC,scurve(:,1));
hold on;
x=fC;
y = scurve(:,1);
%% histogram calculation
%histogram(scurve(:,1),10)

%% erf fit example

[xData, yData] = prepareCurveData( x, y );
%A= 50;
%a=5;
%b=0.2;
ft = fittype( '0.5 * erf( (x-a)/(sqrt(2)*b) ) + 0.5 ' ,'dependent',{'y'},'independent',{'x'},'coefficients',{'a','b'});
options = fitoptions;
options.Normal = 'on';
[fitresult, gof] = fit( xData, yData, ft,options);
f_res = fitresult(x); 
plot(fitresult);
T= table(xData,yData,f_res,y-f_res, 'VariableNames',{'X','Y','FIT','FIT_ERROR'})
% Plot fit with data.
figure( 'Name', 'test' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', 'test', 'Location', 'NorthWest' );
% Label axes
xlabel x
ylabel y
grid on
fC_fine = (0:.1:max(fC))';
s_fine  = fitresult(fC_fine);
s_diff  = differentiate(fitresult,fC_fine);
%%

mean_th = wmean(fC_fine,s_diff);
%%
plot(fC_fine,s_fine);
hold on;
%figure;
plot(fC_fine,0.1*s_diff);
[mean_s,Indx] = max(s_diff)
fC_fine(Indx)% mean of single channel
sigma=std(s_fine)
M= mean(s_fine)
scurvexy=[fC_fine, s_fine]
 %% fit code Rafael
 
 %function [coeff,gof,out] = rfit_erf(x,y)
x=fC_fine(:);
y=s_fine(:);
mediany=median(y,1)


amin = min(mediany)
amax = max(mediany)
idxx= find(mediany > (amin  + 0.01*(amax-amin)) & mediany < (amax - 0.01*(amax-amin)))

if isempty(idxx)
    idxx= find(mediany==median(mediany))
end
if length(idxx)>1
    idx2=idxx(end)
    idx1=idxx(1)
else
    idx1=idxx
    idx2=idx1+1
end
asigma =  abs(x(idx1) - x(idx2))/4
amin  = (y(idx1)+ y(idx2)) /2
amean  = (y(idx1)+ y(idx2)) /2
xmean = (x(idx1)+x(idx2))/2 

A0=[ min(y) range(y) x(round(median(idxx))) asigma ]

opts = fitoptions('method','NonlinearLeastSquares', 'MaxFunEvals', 1000, 'TolX', 1e-5);
    opts= fitoptions(opts, 'StartPoint',A0); 
func='a1 + a2.*(1+erf(sign(xx-a3).*abs(xx-a3)/abs(a4)/sqrt(2)))/2';
mymodel = fittype(func,...
        'independent','xx',...
         'options',opts);
[coeff,gof,out] = fit(x(:),y(:),mymodel);

%figure;
%clf;
%hold on;
%plot(x,y,'x');
%plot(coeff);


%A=coeffvalues(coeff);
%conf= confint(coeff,0.95);
%funcstr =['y = ',char(func)];
%funcstr = strrep(funcstr,'./','/');
%funcstr = strrep(funcstr,'.*','*');
%funcstr = strrep(funcstr,'.^','^');
%for i=1 :length(A)
%    if A(i)<0
%        funcstr=strrep(funcstr,sprintf('A(%i)',i), sprintf('(%.3f)',A(i)));
%    else
%        funcstr=strrep(funcstr,sprintf('A(%i)',i), sprintf('%.3f',A(i)));    
%    end
%end
%if length(funcstr)>80 
%    funcstr = [funcstr(1:min(end,80)) , '......'];
%end
%ht=addtext( sprintf('%s\n%s\n%s\n%s\n%s\n%s',...
%    funcstr,...
%    sprintf('%.4f ',A),...
%    sprintf('%.4f ',conf(2,:)-A),...
%    opts.robust,...
%    sprintf('rsquare=%g', gof.rsquare),... 
%    sprintf('rmse=%g', gof.rmse)),... 
%    0);
%set(ht,'interpreter','none');

 
 

