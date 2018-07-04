%% Threhold trimming routine based on minimum threshold setpoint Algorithm
% stable version 
% 
% run1 
% scurve at 0.4fC
% perform trimming at 0.4fC
% run scurve at 0.4 fC again 
% compare the results


% last updated on 31 May 2018 
%%

clearvars;

%load arm_dac_fc_all_gains_vfat22.mat;
%%

Peaking_time = "45"; %15,25,36,45
Pre_Gain =  "MG"  ;% LG,MG,HG 
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(50);
LV1As   = uint16(1000);
D1 = uint16(53) ;D2 = uint16(200) ;DELAY = uint8(1);
calpulse = uint8(1);
 
start_fc = 0.0 ;
stop_fc = 15.0 ;
num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;

%% connect  hard reset chip
sync_chip();
%% read chip id
 chip_id=strcat('vfat3#',num2str(read_register(hex2dec('10003'))))
 VFAT3_NUMBER = chip_id;
%% Adjust IREF 
AdjustIref();

%% Cal_dac to fC 
[Lfit_caldac,Lfit_charge,step_fc]= caldac_to_fC(VFAT3_NUMBER);

%% front end settings

set_preamp(Peaking_time,Pre_Gain);
%%
front_end_default  = [202 255 9 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,front_end_default);
A = uint8(fread(t,4));
fclose(t);
%%
%% ensure trim dac loading to the chip
% for i= 0 : 127
%     write_register(i,Trim_dac_rounded(i+1));
% end
for i=0 : 127
    write_register(i,0);
end

%[Arming_fit,arm_dac_arr,Threshold_arr] = arm_dac_fc(step_fc,Lfit_caldac);
%save ('Arming_fit_100_HG_vfat45.mat','Arming_fit');


%% 
%load 'Arming_fit_100_HG.mat';
fc_arr = double(start_fc:step_fc:stop_fc)
fc_size = size(fc_arr,2)
 
dac = uint8(round(Lfit_caldac(fc_arr)))
%% arm dac calibration routine

fprintf('Starting arm dac calibration routine,please wait');
Arming_th =3.0;

leg = 'fc to arm dac';
x_label = 'fC';
y_label = 'ArmDac';
[Arming_fit,~,~] = fc_arm_dac(step_fc,Lfit_caldac,leg,x_label,y_label,VFAT3_NUMBER,Pre_Gain,Peaking_time);
arm_dac = Arming_fit(Arming_th)


fprintf('arm dac calibration routine finished');
%%  running scurve before threshold trimming
fprintf('Starting scurve before trimming @ Arming threshold = %f',Arming_th);
[scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 fprintf('completed scurve before trimming @ Arming threshold = %f',Arming_th);

%%
%% calculate noisy channels
fprintf('calculating noisy channels ,please wait');
for i=1:128
    if(mean_enc(i)>(M_O_mean_ENC + (M_O_mean_ENC_std*3)))
        noisy(i)=0;% 0 for noisy channel 
    else noisy(i)=1;% 1 for good channel    
    end
end
figure();

plot(noisy);
axis([1 128 -1 2])
title('noisy channel plot')
xlabel ' # channels'
ylabel  'channel health(1= good ,0 = bad)'
%% mask noisy channels
data= uint16(0);
for i=0 : 127
    if noisy(i+1) == 0 % bad channel
     data=uint16(read_register(i));
     result=bitor(hex2dec('4000'),bitand(data,hex2dec('BFFF'),'uint16'),'uint16')
    write_register(i,result);
    if(i==0 )
        mean_enc(i+1)= mean_enc(i+2);
    elseif i==127 
        mean_enc(i+1)= mean_enc(i);    
    else
       mean_enc(i+1)= (double(mean_enc(i))+ double(mean_enc(i+2)))/2.0;
    end
   end
end
% recalculate mean of mean enc
M_O_mean_ENC = mean(mean_enc(:));
M_O_mean_ENC_std = std(mean_enc(:));

 %% scurve plots
% col= ["red" "green"  "blue" "cyan" "black"];
% figure();
% 
% 
% plot(fc_arr,scurve);
% xlabel Charge(fc);
% ylabel efficiency;





%%
%% threshold plots

% figure;
% 
% 
% plot (mean_th,'r-x'); 
% 
% axis([1 stop_chan 0 6]);
% str = ['\mu: ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th * 6241.51)),'e)' ];
% text(3,M_O_mean_Th+1,str);
% str = ['\sigma:',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
% text(3,M_O_mean_Th +.7,str);
% %title('Mean Threshold (Before trimming)');
% xlabel 'channel number';
% ylabel 'Charge (fC)';
% 
% 
% 
% %threshold histograms
% 
% figure();
% 
% 
% %title('Threshold Histograms(Before trimming)');
% 
% 
% 
% histogram(mean_th,'facecolor',col(1)); 
% axis([start_fc stop_fc 1 50]);
% str = ['\mu: ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th * 6241.51)),'e)' ];
% text(M_O_mean_Th+.7,40,str);
% str = ['\sigma:',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
% text(M_O_mean_Th+.7,38,str);
% 
% xlabel 'charge (fC)';
% ylabel 'Channel count';
% %plot ((1:size(S_mean_th,2)),S_mean_th(i,:)'); 
% 
% 
% 
% 
% 
% 
% 
% %% enc plots
% figure;
% st=1;stp=128;
% 
% plot(mean_enc.* 6241.5093,'r-o');
% 
% axis([st stp 0 1400]);
% str = ['\mu: ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC * 6241.51)),'e)' ];
% text(5,1400,str);
% str = ['\sigma: ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
% text(5,1300,str);
% xlabel 'channel number';
% ylabel 'ENC (fC)';
% grid on;
% grid 'minor';
% 
% 
% %% enc histograms
% figure;
% 
% histogram(mean_enc,'facecolor',col(1));
% axis([0 1 0 50]);
% 
% 
% str = ['\mu: ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC * 6241.51)),'e)' ];
% text(0,40,str);
% str = ['\sigma: ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
% text(0,35,str);
% xlabel 'charge (fC)';
% ylabel 'channel count';
% 
% 


%% calculate weighted minimum of mean thresholds i.e. a channel with minimum threshold 
minimum_val = mean_th(1);
        indx = 1;
for i=1:127
    if(noisy(i)==1)% channel is good
        
        if(mean_th(i+1)< minimum_val)
            minimum_val = mean_th(i+1)
            indx= i+1
        end
            
    end
end


%% starting threshold trimming
  %% SET  ALL  trimming registers TO MAX before running scurves
% for i=0 : 127
%     write_register(i,63);
% end

  %new_diff=double(100.0);
NUM_OF_CHANNELS = 128; %0, 1  
READ    = uint8(0);
WRITE   = uint8(1);
YES     = uint8(1);
NO      = uint8(0);
ADDRESS = uint16(0);
channel = uint16(0);
DATA    = int16(0);


%Threshold= double(zeros(1,NUM_OF_CHANNELS));
%scurve_1_ch = double(zeros(NUM_OF_CHANNELS,fc_size));
channel = 0;

 figure( 'Name', 'Trim_fit' );   

while channel <= (NUM_OF_CHANNELS-1)
ADDRESS = channel;
j=1;
DATA = -30;
    % channel trim loop do trimming while channel is trimmed
%old_diff = double(100.0);
%new_diff = double(100.0);

%ch_trim = NO;
%Threshold(channel+1)= scurve_one_channel(channel,m,c,start_fc,stop_fc,step_fc,fC);
fprintf('\nchannel %d\n',channel);

while DATA <= 30 % individual channel loop inner

Trim_dac(channel+1,j) = DATA;
write_register(ADDRESS,sign_bit_conversion(DATA));
% send this value to vfat3

    while true 
    [~,~,~,Threshold_single_ch,~,~,~] = scurve_all_channel(channel,channel,1,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
                       
        Threshold(channel+1,j)= Threshold_single_ch;
        if (Threshold(channel+1,j)~=0.0)
            break; 
        end
    end
fprintf('Threshold(%d, %d) = %f  Trim_dac(%d, %d) = %f \n', channel,j, Threshold(channel+1,j),channel,j,Trim_dac(channel+1,j));
DATA = DATA + 30;
j=j+1;
end

[Tfit,gof]=Trim_fit(Threshold(channel+1,:),Trim_dac(channel+1,:));% ,Linear fit :: finding fitting coefficients
subplot(11,12,channel+1);
 h = plot( Tfit, Threshold(channel+1,:), Trim_dac(channel+1,: ));
% legend( h, 'Trim fit plot', 'TrimFit', 'Location', 'SouthEast' );
% Label axes
legend('off') 
xlabel 'charge (fC)'
ylabel 'TrimDac'
 
%[Tfit,gof]=Trim_fit(Threshold(channel+1,:),Trim_dac(channel+1,:));% finding fitting coefficients  
Arm_dac(channel+1) = Tfit(Arming_th);%it is desired arm_dac(trim dacs) value but without limits, maz be exceed trim_dac limits
%correct limits for the local arm dacs between -63    to  63 
    if(Arm_dac(channel+1))> 63 
        Trimming_dac(channel+1) = 63;

    elseif(Arm_dac(channel+1))< -63.0 
        Trimming_dac(channel+1) = -63.0;
    else 
        Trimming_dac(channel+1)= Arm_dac(channel+1);
    end
    Trim_dac_rounded = round(Trimming_dac(:));
   write_register(ADDRESS,sign_bit_conversion(round(Trim_dac_rounded(channel+1))));% writing correct trimming value in local channel register


channel = channel +1;

end
%%

figure();
 Trim_dac_rounded = int16(round(Trimming_dac(:)));
subplot(2,1,1);
 p= plot(Trim_dac_rounded,'r-*');
title('Adjusted TrimDac vs. channels plot ');
xlabel('channel');
ylabel('TrimDac');


str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=120;y0=50;
x1=80;y1=y0-10;
x2=80;y2=y0-20;
%x3=80;y3=-10;
text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);
subplot(2,1,2);
histogram(Trim_dac_rounded);
str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=30;y0=20;
x1=30;y1=y0-2;
x2=30;y2=y0-4;
%x3=80;y3=-10;
text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);
title('Adjusted TrimDac Histograms ');
xlabel('TrimDacs bins');
ylabel('# of channels ');

%text(x3,y3,str3);
%text  = num2str('ArmingTh',Arm_dac_fC,'fC');
%PrintLegend('TrimDac vs. channel',VFAT3_NUMBER ,Arming_th,arm_dac,Pre_Gain,Peaking_time,100,0);
%% ensure trim dac loading to the chip
 for i= 0 : 127
    write_register(i,sign_bit_conversion(Trim_dac_rounded(i+1)));% writing correct trimming value in local channel register

 end
%% scurve post trimming @ same armdac at which trimming was perfrmed
[scurve_T,mean_th_T,mean_enc_T,M_O_mean_Th_T,M_O_mean_Th_std_T,M_O_mean_ENC_T,M_O_mean_ENC_std_T] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 %% noisy channels calculation post trimming
fprintf('\n calculating noisy channels post trimming ,please wait\n');
for i=1:128
    if(mean_enc_T(i)>(M_O_mean_ENC_T + (M_O_mean_ENC_std_T*5)))
        noisy_T(i)=0;% 0 for noisy channel 
    else noisy_T(i)=1;% 1 for good channel    
    end
end
figure();

plot(noisy_T);
axis([1 128 0 2])                                                                                                                                                                                                                                                                            
title('noisy channel plot')
xlabel ' # channels'
ylabel  'channel health(1= good ,0 = bad)'

fprintf('\n Noisy channel calculation completed successfully\n');
%% %% scurve plots
fprintf('\n Plotting scurve plots ,please wait\n');
col= ["red" "green"  "blue" "cyan" "black"];
figure();

subplot(2,2,1);
plot(fc_arr,scurve);
title 'Scurve before Trimming'
xlabel Vcal(fc);
ylabel efficiency;
grid on;
grid 'minor';
str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=Arming_th+3;y0=.9;
x1=x0;y1=y0-.05;
x2=x0;y2=y1-.05;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);

ch_arr = 1:128;
[x, y] = meshgrid(ch_arr, fc_arr); % 2d meshgrid
temp = scurve;
for i=1:size(temp,1)
    for j=1: size(temp,2)
    if temp(i,j)== 0
        temp(i,j) = nan;
    end
    end
end
subplot(2,2,2);
z = temp'; % sample data, use your own variable
p = pcolor(x,y,z);
p.EdgeAlpha = 0;
cb = colorbar;
xlabel 'channel # ';
ylabel 'caldac(fC)';
title 'scurve before trimming';
cb.Label.String = 'Ocuppancy(Hits)';
grid on;
grid 'minor';

str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);






subplot(2,2,3);
plot(fc_arr,scurve_T);
title 'Scurve after Trimming'
xlabel Vcal(fc);
ylabel efficiency;
grid on;
grid 'minor';

ch_arr = 1:128;
[x, y] = meshgrid(ch_arr, fc_arr); % 2d meshgrid
temp = scurve_T;
for i=1:size(temp,1)
    for j=1: size(temp,2)
    if temp(i,j)== 0
        temp(i,j) = nan;
    end
    end
end
subplot(2,2,4);
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

str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);




fprintf('\n finished plotting scurve plots\n');
%%


%% threshold plots

figure;

subplot(2,2,1);
plot (mean_th,'r-x'); 

hold on;
axis([1 stop_chan 0.5 6]);
str = ['\mu: ', num2str(round(mean(mean_th),3)),'fC (',num2str(round(mean(mean_th) * 6241.51)),'e)' ];
text(3,mean(mean_th)+2,str);
str = ['\sigma:',num2str(round(std(mean_th),3)),'fC (',num2str(round(std(mean_th)* 6241.51)),'e)'];
text(3,mean(mean_th) +1.2,str);
%title('Mean Threshold (Before trimming)');
title 'Threshold plot(before trimming)'
xlabel 'channel number';
ylabel 'Threshold Extracted(fC)';
P_Three_sigma =  mean(mean_th) + ones(1,128)* 3* std(mean_th) 
N_Three_sigma =  mean(mean_th) - ones(1,128)* 3* std(mean_th) 
plot(P_Three_sigma,'color','blue')
plot(N_Three_sigma, 'color','blue')
%plot_conditions(VFAT3_NUMBER,Arming_th,arm_dac,Pre_Gain,Peaking_time);

% str0 = ['',VFAT3_NUMBER];
% str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
% str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
% x0=80;y0=2.9;
% x1=80;y1=2.7;
% x2=80;y2=2.6;
% %x3=80;y3=-10;
% text(x0,y0,str0);
% text(x1,y1,str1);
% text(x2,y2,str2);

grid on;
grid 'minor';



hold off;

subplot(2,2,3);
plot (mean_th_T,'r-x');
hold on;
axis([1 stop_chan 0.5 5]);
str=date;
text(3,4.8,str);
str = ['\mu: ', num2str(round(M_O_mean_Th_T,3)),'fC (',num2str(round(M_O_mean_Th_T * 6241.51)),'e)' ];
text(3,M_O_mean_Th_T+1,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std_T,3)),'fC (',num2str(round(M_O_mean_Th_std_T* 6241.51)),'e)'];
text(3,M_O_mean_Th_T +.7,str);

str = ['Trimming Factor:\sigma(before)/\sigma(after)',num2str(round(M_O_mean_Th_std/M_O_mean_Th_std_T,3),3)];
text(3,M_O_mean_Th_T +.3,str);
title('Threshold plot  (Post trimming)');
xlabel 'channel number';
ylabel 'Threshold Extracted(fC)';
P_Three_sigma =  M_O_mean_Th_T + ones(1,128)* 3* M_O_mean_Th_std_T ;
N_Three_sigma =  M_O_mean_Th_T - ones(1,128)* 3* M_O_mean_Th_std_T ;
plot(P_Three_sigma,'color','blue')
plot(N_Three_sigma, 'color','blue')
grid on;
grid 'minor';
% threshold histograms

%figure();


%title('Threshold Histograms(Before trimming)');


subplot(2,2,2);
histogram(mean_th,15,'facecolor',col(1)); 
axis([start_fc stop_fc 1 50]);
str=date;
text(6,50-2,str);
str = ['\mu: ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th * 6241.51)),'e)' ];
text(M_O_mean_Th+.7,38,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
text(M_O_mean_Th+.7,35,str);

xlabel 'Thresholds extracted (fC)';
ylabel 'Channel count';
title 'Mean Tresholds histogram (before)'
grid on;
grid 'minor';

subplot(2,2,4);
histogram(mean_th_T,'facecolor',col(1)); 
axis([start_fc stop_fc 1 50]);
str = ['\mu: ', num2str(round(M_O_mean_Th_T,3)),'fC (',num2str(round(M_O_mean_Th_T * 6241.51)),'e)' ];
text(M_O_mean_Th_T+.7,38,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std_T,3)),'fC (',num2str(round(M_O_mean_Th_std_T* 6241.51)),'e)'];
text(M_O_mean_Th_T+.7,35,str);

xlabel 'Thresholds extracted(fC)';
ylabel 'Channel count';
title 'Thresholds histogram (After)'
grid on;
grid 'minor';
str = ['Trimming Factor:\sigma(before)/\sigma(after) = ',num2str(round(M_O_mean_Th_std/M_O_mean_Th_std_T,3),3)];
text(3,30,str);

%plot ((1:size(S_mean_th,2)),S_mean_th(i,:)'); 


%  %% enc plots
% figure;
% st=1;stp=128;
% 
% plot(mean_enc.* 6241.5093,'r-o');
% 
% axis([st stp 0 1400]);
% str = ['\mu: ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC * 6241.51)),'e)' ];
% text(5,1400,str);
% str = ['\sigma: ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
% text(5,1300,str);
% xlabel 'channel number';
% ylabel 'ENC (fC)';
% grid on;
% grid 'minor';


%% enc plots
y = mean_enc(:) ;
NUMBER     = M_O_mean_ENC; 
NUMBER_STD = M_O_mean_ENC_std ;
figure;

subplot(2,2,1);
plot (y,'r-x');
title 'ENC before trimming'
hold on;
axis([1 stop_chan 0 .3 ]);
str = ['\mu: ', num2str(round(NUMBER,3)),'fC (',num2str(round(NUMBER * 6241.51)),'e)' ];
text(3,NUMBER + .13,str);
str = ['\sigma:',num2str(round(NUMBER_STD,3)),'fC (',num2str(round(NUMBER_STD* 6241.51)),'e)'];
text(3,NUMBER +.1,str);
%title('Mean Threshold (Before trimming)');
title 'ENC plot before trimming'
xlabel 'channel number';
ylabel 'ENC Extracted (fC)';
P_Three_sigma =  NUMBER + ones(1,128)* 3* NUMBER_STD ;
N_Three_sigma =  NUMBER - ones(1,128)* 3* NUMBER_STD ;
plot(P_Three_sigma,'color','blue')
plot(N_Three_sigma, 'color','blue')
grid on;
grid 'minor';
hold off;

subplot(2,2,3);
y = mean_enc_T(:) ;
NUMBER     = M_O_mean_ENC_T ;
NUMBER_STD = M_O_mean_ENC_std_T ;
plot (y,'r-x'); 
title 'ENC after trimming'
hold on;
axis([1 stop_chan 0 .3 ]);
str = ['\mu: ', num2str(round(NUMBER,3)),'fC (',num2str(round(NUMBER * 6241.51)),'e)' ];
text(3,NUMBER + .13,str);
str = ['\sigma:',num2str(round(NUMBER_STD,3)),'fC (',num2str(round(NUMBER_STD* 6241.51)),'e)'];
text(3,NUMBER +.1,str);
%title('Mean Threshold (Before trimming)');
xlabel 'channel number';
ylabel 'ENC Extracted(fC)';
P_Three_sigma =  NUMBER + ones(1,128)* 3* NUMBER_STD ;
N_Three_sigma =  NUMBER - ones(1,128)* 3* NUMBER_STD ;
plot(P_Three_sigma,'color','blue')
plot(N_Three_sigma, 'color','blue')
grid on;
grid 'minor';
hold off;

% enc histograms

subplot(2,2,2);
histogram(mean_enc,'facecolor',col(1));
axis([0 1 0 50]);


str = ['\mu: ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC * 6241.51)),'e)' ];
text(0,40,str);
str = ['\sigma: ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
text(0,35,str);
xlabel 'ENC Extracted(fC)';
ylabel 'channel count';
title 'ENC Histogram before trimming'
subplot(2,2,4);
histogram(mean_enc_T,'facecolor',col(1));
axis([0 1 0 50]);


str = ['\mu: ', num2str(round(M_O_mean_ENC_T,3)),'fC (',num2str(round(M_O_mean_ENC_T * 6241.51)),'e)' ];
text(0,40,str);
str = ['\sigma: ',num2str(round(M_O_mean_ENC_std_T,3)),'fC (',num2str(round(M_O_mean_ENC_std_T* 6241.51)),'e)'];
text(0,35,str);
xlabel 'ENC Extracted(fC)';
ylabel 'channel count';
title 'ENC Histogram After trimming'
%% scurve at 1fc, 2, 3,4,5 fC
fprintf('\n Plotting scurve plots ,please wait\n');
Arming_th = 1.0;
arm_dac = Arming_fit(Arming_th);
 
[scurve_T1,mean_th_T1,mean_enc_T1,M_O_mean_Th_T1,M_O_mean_Th_std_T1,M_O_mean_ENC_T1,M_O_mean_ENC_std_T1] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 
% scurve at 2fc
Arming_th = 2.0;
arm_dac = Arming_fit(Arming_th);
 
[scurve_T2,mean_th_T2,mean_enc_T2,M_O_mean_Th_T2,M_O_mean_Th_std_T2,M_O_mean_ENC_T2,M_O_mean_ENC_std_T2] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 
% scurve at 3fc
Arming_th = 3.0;
arm_dac = Arming_fit(Arming_th);
 
[scurve_T3,mean_th_T3,mean_enc_T3,M_O_mean_Th_T3,M_O_mean_Th_std_T3,M_O_mean_ENC_T3,M_O_mean_ENC_std_T3] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 % scurve at 2fc
Arming_th = 4.0;
arm_dac = Arming_fit(Arming_th);
 
[scurve_T4,mean_th_T4,mean_enc_T4,M_O_mean_Th_T4,M_O_mean_Th_std_T4,M_O_mean_ENC_T4,M_O_mean_ENC_std_T4] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 % scurve at 2fc
Arming_th = 5.0;
arm_dac = Arming_fit(Arming_th);
 
[scurve_T5,mean_th_T5,mean_enc_T5,M_O_mean_Th_T5,M_O_mean_Th_std_T5,M_O_mean_ENC_T5,M_O_mean_ENC_std_T5] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 
fprintf('\n finished plotting scurve plots at 1,2,3,4,5fC\n');

%% %% scurve plots
fprintf('\n Plotting scurve plots ,please wait\n');
col= ["red" "green"  "blue" "cyan" "black"];
figure();

subplot(6,2,1);
plot(fc_arr,scurve);
title 'Scurve before Trimming'
xlabel Charge(fc);
ylabel efficiency;
grid 'minor'

subplot(6,2,3);
plot(fc_arr,scurve_T1);% 1fc
title 'Scurve after Trimming'
xlabel Charge(fc);
ylabel efficiency;
grid 'minor'

subplot(6,2,5);
plot(fc_arr,scurve_T2);
title 'Scurve after Trimming'
xlabel Charge(fc);
ylabel efficiency;
grid 'minor'

subplot(6,2,7);
plot(fc_arr,scurve_T3);% at 3fc trimming reference
title 'Scurve after Trimming'
xlabel Charge(fc);
ylabel efficiency;
grid 'minor'

subplot(6,2,9);
plot(fc_arr,scurve_T4);% at 3fc trimming reference
title 'Scurve after Trimming'
xlabel Charge(fc);
ylabel efficiency;
grid 'minor'
fprintf('\n finished plotting scurve plots\n');




subplot(6,2,11);
plot(fc_arr,scurve_T5);% at 3fc trimming reference
title 'Scurve after Trimming'
xlabel Charge(fc);
ylabel efficiency;
grid 'minor'


% scurve 2d
subplot(6,2,2)
scurveplot2d(ch_arr, fc_arr,scurve)
str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);


subplot(6,2,4)
scurveplot2d(ch_arr, fc_arr,scurve_T1)
str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);



subplot(6,2,6)
scurveplot2d(ch_arr, fc_arr,scurve_T2)
str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);

subplot(6,2,8)
scurveplot2d(ch_arr, fc_arr,scurve_T3)
str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);

subplot(6,2,10)
scurveplot2d(ch_arr, fc_arr,scurve_T4)
str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);

subplot(6,2,12)
scurveplot2d(ch_arr, fc_arr,scurve_T5)
str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (*',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);



