%% scurve Analysis for vfat3



clearvars;
%% load labview data
load 'f:\labview\data\scurve.txt';
load 'f:\labview\data\fC.txt';
channels = size(scurve,2)% no. of columns 
fC_steps = size(scurve,1)% no. of rows
hold on

for i  = 1 : 1 : channels
    plot(fC,scurve(:,i));
    hold on
end
title('scurve before threshold trimming');
xlabel('fC');
ylabel('Hit Efficiency');
 %% error function fit
hold off; 
x=fC;
 for i  = 1 : 1 : channels
y = scurve(:,i);

[xData, yData] = prepareCurveData( x, y );
ft = fittype( '0.5 * erf( (x-a)/(sqrt(2)*b) ) + 0.5 ' ,'dependent',{'y'},'independent',{'x'},'coefficients',{'a','b'});
options = fitoptions;
options.Normal = 'on';
[fitresult, gof] = fit( xData, yData, ft,options);
f_res = fitresult(x); 
%%plot(fitresult);
%T= table(xData,yData,f_res,y-f_res, 'VariableNames',{'X','Y','FIT','FIT_ERROR'})
% Plot fit with data.
%figure( 'Name', 'test' );
%h = plot( fitresult, xData, yData );
%legend( h, 'y vs. x', 'test', 'Location', 'NorthWest' );
% Label axes
%xlabel x
%ylabel y
%grid on
 
fC_fine = (0:.1:max(fC))';    % generate fC array with 0.1fc resolution , we can generate as much as we like
s_fine(:,i)  = fitresult(fC_fine); %
s_diff(:,i)  = differentiate(fitresult,fC_fine);
%%
%w= s_diff;
%x=fC_fine;
%dim = min(find(size(x)~=1));
%y = sum(w.*x,dim)./sum(w,dim);
mean_th(i) = wmean(fC_fine,s_diff(:,i));
mean_enc(i) = std(fC_fine,s_diff(:,i));
 end
%%
%plot(fC_fine,s_fine(:,channel));
%hold on;
%figure;
%plot(fC_fine,0.1*s_diff(:,channel));

 
 %%
 M_O_mean_Th  = mean(mean_th(:));
 M_O_mean_Th_std = std(mean_th(:));
M_O_mean_ENC = mean(mean_enc(:));
M_O_mean_ENC_std = std(mean_enc(:));
 figure();
 title('Mean Threshold and enc plots');
 subplot(2,2,1);
plot(mean_th);
title(' Thresholds(fC) All channels');
ylabel('Th(fC)');
xlabel('# of channels');
axis([1 128 2 8]);
%axis([-10 10 0 inf])
subplot(2,2,2);
plot(mean_enc);
title(' ENC(fC) All channels');
ylabel('ENC(fC)');
xlabel('# of channels');
axis([1 128 0 .5]);

subplot(2,2,3);
hist_mean_th = histogram(mean_th,20);
title(' Mean thresholds (Histogram )');
xlabel('Th(fC)');
ylabel('channel count');
axis([3 7 1 50]);

str = ['Mean ', num2str(M_O_mean_Th)];
text(3.3,47,str);
str = ['std     ',num2str(M_O_mean_Th_std)];
text(3.3,42,str)


subplot(2,2,4);
hist_mean_enc = histogram(mean_enc,20);
title(' Mean ENC(Histogram )');
xlabel('ENC(fC)');
ylabel('channel count');
axis([0 .5 1 50]);
str = ['Mean ', num2str(M_O_mean_ENC),'fC (',num2str(M_O_mean_ENC* 6241.51),'e)' ];
text(0.1,47,str);
str = ['std     ',num2str(M_O_mean_ENC_std),'fC (',num2str(M_O_mean_ENC_std* 6241.51),'e)'];
text(.1,42,str)
%%

%hist_all = [hist_mean_enc hist_mean_th];
figure();
histogram(mean_enc,20);
hold on ;
histogram(mean_th,20);
axis([0 7 0 130]);
xlabel('Charge(fC)');
ylabel('channel count');
