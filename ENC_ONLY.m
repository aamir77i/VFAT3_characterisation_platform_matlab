%% Threhold trimming routine based on Trim_fit Algorithm
% stable version 
% 
% run3 
% scurve at 5,4,3,2,1 fC
% perform trimming at 3.0fC
% run scurve at 5,4,3 ,2,1 fC again 
% compare the results


% last updated on 10 May 2018 
%%

clearvars;
%%
%load Arming_fit.mat;


leg     = 'Threshold vs. ArmDac';
x_label =  'Threshold(fC)'; 
y_label =  'ArmDac';

%load Arming_fit.mat;
VFAT3_NUMBER = 'vfat3#22';
Peaking_time = "45"; % 15 25 36 45 
Pre_Gain =  "MG"  ;% LG MG HG  
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(1000);
D1 = uint16(5) ;D2 = uint16(400) ;DELAY = uint8(1);
calpulse = uint8(1);
 
%start_fc = -2.0 2
%stop_fc = 20.0 ;

num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;
%% connect  hard reset chip
sync_chip();
%% Adjust IREF 
AdjustIref();

%% Cal_dac to fC 
[Lfit_caldac,Lfit_charge,step_fc]= caldac_to_fC(VFAT3_NUMBER);
Max_Caldac = floor(Lfit_charge(0))
%% front end settings
 
set_preamp(Peaking_time,Pre_Gain);
%%
front_end_default  = [202 255 9 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,front_end_default);
fclose(t);
%%
Arming_fit = fc_arm_dac(step_fc,Lfit_caldac,leg,x_label,y_label,VFAT3_NUMBER,Pre_Gain,Peaking_time)
%save ('Arming_fit_100_HG.mat','Arming_fit');
%load 'Arming_fit_LG_100.mat';
%% clear all trimming registers before running scurves
for i=0 : 127
    write_register(i,0);
end
 %%

 
Max_Caldac = floor(Lfit_charge(0));
start_fc = 0.0 ;
stop_fc = 10;%Max_Caldac;

fc_arr = double(start_fc:step_fc:stop_fc)
fc_size = size(fc_arr,2)
 
dac = uint8(round(Lfit_caldac(fc_arr)))
% [scurve0,mean_th0,mean_enc0,M_O_mean_Th0,M_O_mean_Th_std0,M_O_mean_ENC0,M_O_mean_ENC_std0] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac);

Arming_th=2.0;% start arm_dac from 5.0 and go to some criteria
arm_dac = uint8(round(Arming_fit(Arming_th)))
Criteria = 1.0;%fC
i= 1;
%
 
%Arming_th = 2.5;% fC

[scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 %%
% S_scurve_B(1,:,:)        = scurve;
% S_mean_th_B(1,:)         = mean_th;
% S_mean_enc_B(1,:)        = mean_enc;
% S_M_O_mean_th_B(1)       = M_O_mean_Th;
% S_M_O_mean_Th_std_B(1)   = M_O_mean_Th_std;
% S_M_O_mean_ENC_B(1)      = M_O_mean_ENC;
% S_M_O_mean_ENC_std_B(1)  = M_O_mean_ENC_std;
% S_Arming_Th_B(1)         = Arming_th; 


   




%% scurve plots
col= ["red" "green"  "blue" "cyan" "black"];
figure();


plot(fc_arr,scurve,'color',col(1));
title 'scurve plot'
xlabel Charge(fc);
ylabel efficiency;

str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=Arming_th+3;y0=.9;
x1=x0;y1=y0-.05;
x2=x0;y2=y1-.05;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);
%%
figure();
ch_arr = 1:128;
[x, y] = meshgrid(ch_arr, fc_arr); % 2d meshgrid
temp = scurve;
%temp(:,1:3)=nan;
z = temp'; % sample data, use your own variable
p = pcolor(x,y,z);
p.EdgeAlpha = 0;
cb = colorbar;
xlabel 'channel # ';
ylabel 'caldac(fC)';
title 'scurve plot vfat3 128 channels';
cb.Label.String = 'Ocuppancy(Hits)';

str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);

%% threshold plots

figure;

subplot(2,1,1);
plot (mean_th,'r-x'); 

axis([1 stop_chan 0 6]);
str = ['\mu: ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th * 6241.51)),'e)' ];
text(3,M_O_mean_Th+3,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
text(3,M_O_mean_Th +2.7,str);

str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=80;y0=M_O_mean_Th + 3;
x1=x0;y1=y0-.3;
x2=x0;y2=y1-.3;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);
%title('Mean Threshold (Before trimming)');
xlabel 'channel number';
ylabel 'Charge (fC)';
title 'Threshold Plot(All channels)'



% threshold histograms

subplot(2,1,2);


%title('Threshold Histograms(Before trimming)');



histogram(mean_th,'facecolor',col(1)); 
axis([start_fc stop_fc 1 50]);
str = ['\mu: ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th * 6241.51)),'e)' ];
text(M_O_mean_Th+.7,40,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
text(M_O_mean_Th+.7,38,str);

str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=M_O_mean_Th +4;y0=40;
x1=x0;y1=y0-2;
x2=x0;y2=y1-2;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);


xlabel 'charge (fC)';
ylabel 'Channel count';
title 'Threshold All channels histograms'
%plot ((1:size(S_mean_th,2)),S_mean_th(i,:)'); 







%% enc plots
figure;
st=1;stp=128;
subplot(2,1,1);
plot(mean_enc,'r-o');

axis([st stp (M_O_mean_ENC - .1) (M_O_mean_ENC +.1)]);
str = ['\mu: ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC * 6241.51)),'e)' ];
text(5,.28,str);
str = ['\sigma: ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
text(5,.27,str);

str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=80;y0=.28;
x1=x0;y1=y0-.008;
x2=x0;y2=y1-.008;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);


xlabel 'channel number';
ylabel 'ENC (fC)';
title 'ENC plot '
grid on;
grid 'minor';


% enc histograms

subplot(2,1,2);
histogram(mean_enc,'facecolor',col(1));
axis([0 1 0 50]);


str = ['\mu: ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC * 6241.51)),'e)' ];
text(0,40,str);
str = ['\sigma: ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
text(0,35,str);


str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=.6;y0=40;
x1=x0;y1=y0-2.5;
x2=x0;y2=y1-2.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);
xlabel 'charge (fC)';
ylabel 'channel count';
title 'ENC Histogram '

