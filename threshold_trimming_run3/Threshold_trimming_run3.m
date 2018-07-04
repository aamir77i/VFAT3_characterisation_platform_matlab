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
load Arming_fit.mat;
%% sync the chip
sync  = [202 0 2 ]';

 
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,sync);
A = fread(t,1);
fclose(t);


if A == 58
    formatSpec = 'received  %x , sync OK \n';
else
    
    
    formatSpec = 'received  %x , sync fail \n';
end

fprintf(formatSpec,A);

%% Adjust IREF 
Adjust_IREF  = [202 0 5 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,Adjust_IREF);
A = uint8(fread(t,4));
fclose(t);

IREF=A(1);
ADC= double(uint16( 256*uint16(A(4))+ uint16(A(3))))*0.0625;
    formatSpec = 'IREF = %d , adc = %5.2f \n';

fprintf(formatSpec,IREF,ADC);

%% Cal_dac to fC 
Cal_dac_to_fc  = [202 255 7 0 1 255 ]';
t = tcpip('192.168.1.10',7);
t.InputBufferSize = 1024;
fopen(t);
fwrite(t,Cal_dac_to_fc);
A = uint8(fread(t,2));
B = uint8(fread(t,1024));
fclose(t);
%%
base_val = double(typecast(A, 'uint16'));
data_caldac = typecast(B, 'uint16');
cal_dac= data_caldac(1:2:end);
adccal_dac= data_caldac(2:2:end);
charge = (double(fliplr(adccal_dac(:)))  -  base_val )*.00625;% capacitor =100fF
figure();
plot(cal_dac,charge);
title ' CAL DAC to fC '
xlabel ' cal_dac';
ylabel ' mvolts';
 % linear fit
[Lfit_caldac,gof_caldac] = LinearFit(charge,cal_dac);
[Lfit_charge,gof_charge] = LinearFit(cal_dac,charge);% to find min fc_step

step_fc = abs(Lfit_charge(0) - Lfit_charge(1))% input dac values to get charge value

%% do scurve for all channels BEFORE TRIMMING
   % clear all trimming registers before running scurves
for i=0 : 127
    write_register(i,0);
end
 
%% front end settings
Peaking_time = "100"; 
Pre_Gain =  "MG"  ;%"Medium" , " High" 
set_preamp(Peaking_time,Pre_Gain);
%%
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(100);


%Arming_th = 2.5;% fC
%arm_dac = uint8(round(Arming_fit(Arming_th)))

D1 = uint16(5) ;D2 = uint16(500) ;DELAY = uint8(20);
start_fc = 0.0 ;
stop_fc = 7.0 ;
num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;

fc_arr = double(start_fc:step_fc:stop_fc)
fc_size = size(fc_arr,2);
 
dac = uint8(round(Lfit_caldac(fc_arr)));
% [scurve0,mean_th0,mean_enc0,M_O_mean_Th0,M_O_mean_Th_std0,M_O_mean_ENC0,M_O_mean_ENC_std0] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac);

Arming_th=5.0;% start arm_dac from 5.0 and go to some criteria
Criteria = 1.0;%fC
i= 1;
while Arming_th >=Criteria 
%Arming_th = 2.5;% fC
arm_dac = uint8(round(Arming_fit(Arming_th)));
[scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac);

S_scurve_B(i,:,:)        = scurve;
S_mean_th_B(i,:)         = mean_th;
S_mean_enc_B(i,:)        = mean_enc;
S_M_O_mean_th_B(i)       = M_O_mean_Th;
S_M_O_mean_Th_std_B(i)   = M_O_mean_Th_std;
S_M_O_mean_ENC_B(i)      = M_O_mean_ENC;
S_M_O_mean_ENC_std_B(i)  = M_O_mean_ENC_std;
S_Arming_Th_B(i)         = Arming_th; 

Arming_th                = Arming_th-1.0;
i=i+1;
end


%% starting threshold trimming


  %new_diff=double(100.0);
NUM_OF_CHANNELS = 128; %0, 1  
READ    = uint8(0);
WRITE   = uint8(1);
YES     = uint8(1);
NO      = uint8(0);
ADDRESS = uint16(0);
channel = uint16(0);
DATA    = int16(0);

Arming_th = 3.0;% perform trimming at 3fC 
arm_dac = uint8(round(Arming_fit(Arming_th)));
%Threshold= double(zeros(1,NUM_OF_CHANNELS));
%scurve_1_ch = double(zeros(NUM_OF_CHANNELS,fc_size));
channel = 0;


while channel <= (NUM_OF_CHANNELS-1)
ADDRESS = channel;
j=1;
DATA = -40;
    % channel trim loop do trimming while channel is trimmed
%old_diff = double(100.0);
%new_diff = double(100.0);

%ch_trim = NO;
%Threshold(channel+1)= scurve_one_channel(channel,m,c,start_fc,stop_fc,step_fc,fC);
fprintf('\nchannel %d\n',channel);
while DATA <= 40 % individual channel loop inner

Trim_dac(channel+1,j) = DATA;
write_register(ADDRESS,sign_bit_conversion(DATA));
% send this value to vfat3

    while true 
    [scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(channel,channel,1,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac);
                       
        Threshold(channel+1,j)= M_O_mean_Th;
        if (Threshold(channel+1,j)~=0.0)
            break; 
        end
    end
fprintf('Threshold(%d, %d) = %f  Trim_dac(%d, %d) = %f \n', channel,j, Threshold(channel+1,j),channel,j,Trim_dac(channel+1,j));
DATA = DATA + 10;
j=j+1;
end
[Tfit,gof]=Trim_fit(Threshold(channel+1,:),Trim_dac(channel+1,:));% finding fitting coefficients  
Arm_dac(channel+1) = Tfit(Arming_th);%it is desired arm_dac value but without limits, maz be exceed trim_dac limits
%correct limits for the local arm dacs between -63    to  63 
    if(Arm_dac(channel+1))> 63 
        Trimming_dac(channel+1) = 63;

    elseif(Arm_dac(channel+1))< -63.0 
        Trimming_dac(channel+1) = -63.0;
    else 
        Trimming_dac(channel+1)= Arm_dac(channel+1);
    end
write_register(ADDRESS,sign_bit_conversion(round(Trimming_dac(channel+1))));% writing correct trimming value in local channel register


channel = channel +1;

end

Trim_dac_rounded = round(Trimming_dac(:));
figure();
plot(Trim_dac_rounded);
title('TrimDac vs. channel ');
xlabel('channel');
ylabel('TrimDac');



%% repeat scurves again after trimming of dacs

start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(100);
Arming_th=5.0;% start arm_dac from 5.0 and go to some criteria
Criteria = 1.0;%fC
i= 1;
while Arming_th >=Criteria 
%Arming_th = 2.5;% fC
arm_dac = uint8(round(Arming_fit(Arming_th)));
D1 = uint16(5) ;D2 = uint16(500) ;DELAY = uint8(20);
%start_fc = 0.0 ;
%stop_fc = 7.0 ;
%num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;
fc_arr = double(start_fc:step_fc:stop_fc);% charge values
fc_size = size(fc_arr,2);
dac = uint8(round(Lfit_caldac(fc_arr)));% corresponding dac values
[scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac);

S_scurve(i,:,:)          = scurve;
S_mean_th(i,:)         = mean_th;
S_mean_enc(i,:)        = mean_enc;
S_M_O_mean_th(i)     = M_O_mean_Th;
S_M_O_mean_Th_std(i) = M_O_mean_Th_std;
S_M_O_mean_ENC(i)    = M_O_mean_ENC;
S_M_O_mean_ENC_std(i)= M_O_mean_ENC_std;
S_Arming_Th(i) = Arming_th; 

Arming_th = Arming_th-1.0;
i=i+1;
end
%% scurve plots
col= ["red" "green"  "blue" "cyan" "black"]
figure();
subplot(2,1,1);
hold on;

for i = 1:size(S_scurve_B,1)
   
plot(fc_arr,reshape(S_scurve_B(i,:,:),size(S_scurve_B,2),size(S_scurve_B,3)),'color',col(size(S_scurve_B,1)+1-i));    
%scurve_1(:) = reshape(S_scurve(i,:,:),128,31); 
end
title('SCURVES Plots (BEFORE TRIMMING)');
xlabel Charge(fc);
ylabel efficiency;
hold off;
subplot(2,1,2);
hold on;
for i = 1:size(S_scurve,1)
plot(fc_arr,reshape(S_scurve(i,:,:),size(S_scurve,2),size(S_scurve,3)),'color',col(size(S_scurve_B,1)+1-i));   
%scurve_1(:) = reshape(S_scurve(i,:,:),128,31); 
end
title('SCURVES Plots (AFTER TRIMMING)');
xlabel Charge(fc);
ylabel efficiency;




%%
%% threshold plots

figure;
subplot(2,1,1);
hold on;
for i = 1:size(S_mean_th_B,1)

plot ((1:size(S_mean_th_B,2)),S_mean_th_B(i,:)','color',col(size(S_scurve_B,1)+1-i)); 
axis([1 stop_chan 0 6]);
str = ['\mu: ', num2str(round(S_M_O_mean_th_B(i),3)),'fC (',num2str(round(S_M_O_mean_th_B(i) * 6241.51)),'e)' ];
text(1,S_M_O_mean_th_B(i)+.6,str);
str = ['\sigma:',num2str(round(S_M_O_mean_Th_std_B(i),3)),'fC (',num2str(round(S_M_O_mean_Th_std_B(i)* 6241.51)),'e)'];
text(1,S_M_O_mean_th_B(i)+.3,str);
title('Mean Threshold (Before trimming)');
xlabel 'channel number';
ylabel 'Threshold (fC)';
end
hold off;

subplot(2,1,2);
hold on;
for i = 1:size(S_mean_th,1)

plot ((1:size(S_mean_th,2)),S_mean_th(i,:)','color',col(size(S_scurve_B,1)+1-i)); 
axis([1 stop_chan 0 6]);
str = ['\mu: ', num2str(round(S_M_O_mean_th(i),3)),'fC (',num2str(round(S_M_O_mean_th(i) * 6241.51)),'e)' ];
text(1,S_M_O_mean_th(i)+.6,str);
str = ['\sigma:',num2str(round(S_M_O_mean_Th_std(i),3)),'fC (',num2str(round(S_M_O_mean_Th_std(i)* 6241.51)),'e)'];
text(1,S_M_O_mean_th(i)+.3,str);
title('Mean Threshold (After trimming)');
xlabel 'channel number';
ylabel 'Threshold (fC)';
end
hold off;

%% threshold histograms

figure();
subplot(2,1,1);
axis([start_fc stop_fc 1 50]);
title('Threshold Histograms(Before trimming)');
xlabel 'charge (fC)';
ylabel 'Channel count';
hold on;
for i = 1:size(S_mean_th_B,1)
%subplot(size(S_mean_th,1),1,i);
histogram(S_mean_th_B(i,:)',20,'facecolor',col(size(S_scurve_B,1)+1-i)); 

str = ['\mu: ', num2str(round(S_M_O_mean_th_B(i),3)),'fC (',num2str(round(S_M_O_mean_th_B(i) * 6241.51)),'e)' ];
text(S_M_O_mean_th_B(i)-.3,35,str);
str = ['\sigma:',num2str(round(S_M_O_mean_Th_std_B(i),3)),'fC (',num2str(round(S_M_O_mean_Th_std_B(i)* 6241.51)),'e)'];
text(S_M_O_mean_th_B(i)-.3,31,str);


%plot ((1:size(S_mean_th,2)),S_mean_th(i,:)'); 
end
histogram(S_mean_enc_B(2,:),'facecolor',col(2));% merging enc histogram 
x2 = S_M_O_mean_ENC_B(2);
y2 = -1;
txt2 = '\uparrow MeanENC(fC)';
text(x2,y2,txt2)
hold off;
hold off;

subplot(2,1,2);
axis([start_fc stop_fc 1 50]);
title('Threshold Histograms(After trimming)');
xlabel 'charge (fC)';
ylabel 'Channel count';
hold on;
for i = 1:size(S_mean_th,1)
%subplot(size(S_mean_th,1),1,i);
histogram(S_mean_th(i,:)',20,'facecolor',col(size(S_scurve_B,1)+1-i)); 

str = ['\mu: ', num2str(round(S_M_O_mean_th(i),3)),'fC (',num2str(round(S_M_O_mean_th(i) * 6241.51)),'e)' ];
text(S_M_O_mean_th(i)-.3,35,str);
str = ['\sigma:',num2str(round(S_M_O_mean_Th_std(i),3)),'fC (',num2str(round(S_M_O_mean_Th_std(i)* 6241.51)),'e)'];
text(S_M_O_mean_th(i)-.3,31,str);


%plot ((1:size(S_mean_th,2)),S_mean_th(i,:)'); 
end
histogram(S_mean_enc(2,:),'facecolor',col(2));% merging enc histogram 
x2 = S_M_O_mean_ENC(2);
y2 = -1;
txt2 = '\uparrow MeanENC(fC)';
text(x2,y2,txt2)
hold off;






%% ARMING COMPARATOR VS. ENC PLOT
figure();
p = plot(S_Arming_Th,S_M_O_mean_ENC,'r--*',S_Arming_Th,S_M_O_mean_ENC_B,'b-o');
%p(1).LineWidth =2;
axis([0 max(S_Arming_Th)+1 0 .7]);
grid on;
title 'Arming Threshold vs. Mean ENC All Channels'
xlabel 'Arming Threshold(fC)';
ylabel 'Mean ENC (fC)';
legend('After Trimming ','beforeTrimming')

%% enc plots
figure;
for i = 1:size(S_mean_enc_B,1)
subplot(size(S_mean_enc_B,1),2,i*2 -1);
plot(S_mean_enc_B(i,:),'color',col(i));
axis([1 stop_chan 0 1]);
if i==1 
    title('ENC plots before trimming');
end
str = ['ArmTh: ', num2str(round(S_Arming_Th_B(i),3)),'fC (',num2str(round(S_Arming_Th_B(i) * 6241.51)),'e)' ];
text(5,.9,str);
str = ['\mu: ', num2str(round(S_M_O_mean_ENC_B(i),3)),'fC (',num2str(round(S_M_O_mean_ENC_B(i) * 6241.51)),'e)' ];
text(5,.7,str);
str = ['\sigma: ',num2str(round(S_M_O_mean_ENC_std_B(i),3)),'fC (',num2str(round(S_M_O_mean_ENC_std_B(i)* 6241.51)),'e)'];
text(5,.5,str);
xlabel 'channel number';
ylabel 'ENC (fC)';
end

for i = 1:size(S_mean_enc,1)
subplot(size(S_mean_enc,1),2,i*2);
plot(S_mean_enc(i,:),'color',col(i));
axis([1 stop_chan 0 1]);
if i==1 
    title('ENC plots after trimming');
end
str = ['ArmTh: ', num2str(round(S_Arming_Th(i),3)),'fC (',num2str(round(S_Arming_Th(i) * 6241.51)),'e)' ];
text(5,.9,str);
str = ['\mu: ', num2str(round(S_M_O_mean_ENC(i),3)),'fC (',num2str(round(S_M_O_mean_ENC(i) * 6241.51)),'e)' ];
text(5,.7,str);
str = ['\sigma: ',num2str(round(S_M_O_mean_ENC_std(i),3)),'fC (',num2str(round(S_M_O_mean_ENC_std(i)* 6241.51)),'e)'];
text(5,.5,str);
xlabel 'channel number';
ylabel 'ENC (fC)';
end


%% enc histograms
figure;
for i = 1:size(S_mean_enc_B,1)
subplot(size(S_mean_enc_B,1),2,i*2 -1);
histogram(S_mean_enc_B(i,:),'facecolor',col(i));
axis([0 1 0 50]);
if i==1 
    title('ENC histogram plots before trimming');
end
str = ['ArmTh: ', num2str(round(S_Arming_Th_B(i),3)),'fC (',num2str(round(S_Arming_Th_B(i) * 6241.51)),'e)' ];
text(0,45,str);
str = ['\mu: ', num2str(round(S_M_O_mean_ENC_B(i),3)),'fC (',num2str(round(S_M_O_mean_ENC_B(i) * 6241.51)),'e)' ];
text(0,40,str);
str = ['\sigma: ',num2str(round(S_M_O_mean_ENC_std_B(i),3)),'fC (',num2str(round(S_M_O_mean_ENC_std_B(i)* 6241.51)),'e)'];
text(0,35,str);
xlabel 'charge (fC)';
ylabel 'channel count';
end

% after trimming 
for i = 1:size(S_mean_enc,1)
subplot(size(S_mean_enc,1),2,i*2);
histogram(S_mean_enc(i,:),'facecolor',col(i));
axis([0 1 0 50]);
if i==1 
    title('ENC plots after trimming');
end
str = ['ArmTh: ', num2str(round(S_Arming_Th(i),3)),'fC (',num2str(round(S_Arming_Th(i) * 6241.51)),'e)' ];
text(0,45,str);
str = ['\mu: ', num2str(round(S_M_O_mean_ENC(i),3)),'fC (',num2str(round(S_M_O_mean_ENC(i) * 6241.51)),'e)' ];
text(0,40,str);
str = ['\sigma: ',num2str(round(S_M_O_mean_ENC_std(i),3)),'fC (',num2str(round(S_M_O_mean_ENC_std(i)* 6241.51)),'e)'];
text(0,35,str);
xlabel 'charge (fC)';
ylabel 'channel count';
end

%%
save threshold_trimming_run3

%%
% %% Threshold plots 
% figure();
%  title('Mean Threshold and enc plots');
%  subplot(2,2,1);
% plot(mean_th);
% title(' Thresholds(fC) All channels(BEFORE)');
% ylabel('Th(fC)');
% xlabel('# of channels');
% axis([1 stop_chan double(M_O_mean_Th - (6.0 * M_O_mean_Th_std)) double(M_O_mean_Th +(6.0* M_O_mean_Th_std))]);
% %axis([-10 10 0 inf])
% subplot(2,2,2);
% plot(mean_th_T);
% title(' Threshold(fC) All channels (AFTER)');
% ylabel('Th(fC)');
% xlabel('# of channels');
% axis([1 stop_chan double(M_O_mean_Th_T - (6.0* M_O_mean_Th_std_T)) double(M_O_mean_Th_T + (6.0* M_O_mean_Th_std_T))]);
% 
% subplot(2,2,3);
% hist_mean_th = histogram(mean_th,20);
% 
% title(' Mean thresholds (Histogram ) (BEFORE)');
% xlabel('Th(fC)');
% ylabel('channel count');
% axis([1 stop_fc 1 50]);
% 
% str = ['Mean ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th* 6241.51)),'e)'];
% text(3.3,47,str);
% str = ['std     ',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
% text(3.3,42,str)
% 
% 
% subplot(2,2,4);
% hist_mean_enc = histogram(mean_th_T,20);
% title(' Mean Threshold(Histogram )(AFTER)');
% xlabel('Threshold(fC)');
% ylabel('channel count');
% axis([1 stop_fc 1 50]);
% str = ['Mean ', num2str(round(M_O_mean_Th_T,3)),'fC (',num2str(round(M_O_mean_Th_T * 6241.51)),'e)' ];
% text(4,47,str);
% str = ['std     ',num2str(round(M_O_mean_Th_std_T,3)),'fC (',num2str(round(M_O_mean_Th_std_T* 6241.51)),'e)'];
% text(4,42,str);
%%
%  % ENC plots
% 
%  figure();
%  title('Mean enc plots');
%  subplot(2,2,1);
% plot(mean_enc);
% title(' ENC(fC) All channels(BEFORE)');
% ylabel('ENC(fC)');
% xlabel('# of channels');
% axis([1 128 0 .5]);
% %axis([-10 10 0 inf])
% subplot(2,2,2);
% plot(mean_enc_T);
% title(' ENC(fC) All channels (AFTER)');
% ylabel('ENC(fC)');
% xlabel('# of channels');
% axis([1 128 0 .5]);
% 
% subplot(2,2,3);
% histogram(mean_enc,20);
% title(' Mean ENC (Histogram ) (BEFORE)');
% xlabel('ENC(fC)');
% ylabel('channel count');
% axis([0 .5 0 60]);
% 
% str = ['Mean ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC* 6241.51)),'e)'];
% text(.1,47,str);
% str = ['std     ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
% text(.1,42,str)
% 
% 
% subplot(2,2,4);
% histogram(mean_enc_T,20);
% title(' Mean ENC(Histogram )(AFTER)');
% xlabel('ENC(fC)');
% ylabel('channel count');
% axis([0 .5 0 60]);
% str = ['Mean ', num2str(round(M_O_mean_ENC_T,3)),'fC (',num2str(round(M_O_mean_ENC_T * 6241.51)),'e)' ];
% text(.1,47,str);
% str = ['std     ',num2str(round(M_O_mean_ENC_std_T,3)),'fC (',num2str(round(M_O_mean_ENC_std_T* 6241.51)),'e)'];
% text(.1,42,str);
% 
%  % combined distributions
% %hist_all = [hist_mean_enc hist_mean_th];
% figure('position',[200 200 1200 800]);
% subplot(2,1,1);
% histogram(mean_enc);
% hold on ;
% histogram(mean_th);
% axis([0 5 0 50]);
% title('Combined Distribution Plot(BEFORE Trimming)');
% xlabel('Charge_{fC}');
% ylabel('channel count');
% 
% x1 = M_O_mean_Th;
% y1 = -5;
% txt1 = '\uparrow MeanTh_{fC}';
% text(x1,y1,txt1)
% x2 = M_O_mean_ENC;
% y2 = -5;
% txt2 = '\uparrow MeanENC(fC)';
% text(x2,y2,txt2)
% 
% 
% txt_x = 0.5;
% txt_y = 20;
% str = ['MeanENC :   ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC* 6241.51)),'e)'];
% text(txt_x,30,str);
% str = ['std          :   ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
% text(txt_x,txt_y-2,str)
% 
% txt_x = 3;
% txt_y = 20;
% str = ['MeanTh :   ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th* 6241.51)),'e)'];
% text(txt_x,txt_y,str);
% str = ['std          :   ',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
% text(txt_x,txt_y-2,str)

 % combined after trimming

% subplot(2,1,2);
% histogram(mean_enc_T);
% hold on ;
% histogram(mean_th_T);
% axis([0 5 0 30]);
% title('Combined Distribution Plot (AFTER Trimming)');
% xlabel('Charge_{fC}');
% ylabel('channel count');
% 
% x1 = M_O_mean_Th_T;
% y1 = -5;
% txt1 = '\uparrow MeanTh_{fC}';
% text(x1,y1,txt1)
% x2 = M_O_mean_ENC_T;
% y2 = -5;
% txt2 = '\uparrow MeanENC(fC)';
% text(x2,y2,txt2)
% 
% txt_x = 0;
% txt_y = 20;
% str = ['MeanENC :   ', num2str(round(M_O_mean_ENC_T,3)),'fC (',num2str(round(M_O_mean_ENC_T* 6241.51)),'e)'];
% text(txt_x,txt_y,str);
% str = ['std          :   ',num2str(round(M_O_mean_ENC_std_T,3)),'fC (',num2str(round(M_O_mean_ENC_std_T* 6241.51)),'e)'];
% text(0,txt_y-2 ,str)
% 
% str = ['MeanTh :   ', num2str(round(M_O_mean_Th_T,3)),'fC (',num2str(round(M_O_mean_Th_T* 6241.51)),'e)'];
% text(txt_x+3,txt_y,str);
% str = ['std          :   ',num2str(round(M_O_mean_Th_std_T,3)),'fC (',num2str(round(M_O_mean_Th_std_T* 6241.51)),'e)'];
% text(txt_x+3,txt_y-2,str)


%%
% for loop=1 :128
% if(Arm_dac(loop))> 63 
%     Arm_dac(loop) = 63;
% end
% if(Arm_dac(loop))< -63.0 
%     Arm_dac(loop) = -63.0;
% end
% 
% write_register(loop-1,sign_bit_conversion(round(Arm_dac(loop))));
% end


% %% repeat scurves again by reeducing  threshold value
% 
% 
%    % clear all trimming registers
% 
% start_chan_T2 = start_chan ; stop_chan_T2 = stop_chan ; step_chan_T2 = step_chan ;
% Latency_T2 = uint16(0);
% LV1As_T2   = uint16(LV1As);
% arm_dac_T2 = arm_dac - 15 ;
% D1_T2 = uint16(5) ;D2_T2 = uint16(500) ;DELAY_T2 = uint8(DELAY);
% start_fc_T2 = start_fc ;
% stop_fc_T2 = stop_fc ;
% step_fc_T2 = step_fc ;
% fc_size_T2 = fc_size;
% dac_T2 = dac;
% fc_arr_T2 = fc_arr;
% 
% num_of_channels_T2 = num_of_channels;
% 
%  % run scurve all channels
% tx_data_T2=uint8([202 255 8 start_chan_T2 stop_chan_T2 step_chan_T2 0 0 0 fliplr(typecast(Latency_T2,'uint8')) fliplr(typecast(LV1As_T2,'uint8')) arm_dac_T2 DELAY_T2  fliplr(typecast(D1_T2,'uint8')) fliplr(typecast(D2_T2,'uint8')) fc_size_T2 dac_T2(:)'])';
% fprintf('%x \n',tx_data_T2(:,:))
%  
% scurve_uint16_T2 = uint16(zeros(num_of_channels_T2,fc_size_T2));
% t = tcpip('192.168.1.10',7);
% 
% fopen(t);
% fwrite(t,tx_data_T2);
% for i=1: num_of_channels_T2 
% 
%     scurve_uint16_T2(i,:) = typecast(uint8(fread(t,double(fc_size_T2*2))),'uint16' );
%    %scurve(i,:) = typecast( S_ch_8, 'uint16');
% end
% 
% fclose(t);




    
% %% load labview data
% %load 'f:\labview\data\scurve.txt';
% %load 'f:\labview\data\fC.txt';
% scurve_T2=double(double(scurve_uint16_T2)./double(LV1As_T2));
% channels_T2 = size(scurve_T2,1)    % no. of columns 
% fC_steps_T2 = fc_size_T2;           % no. of rows
% fC_T2  = fc_arr_T2;
% hold on
% 
% %for i  = 1 : 1 : channels
% figure();
%     plot(fC_T2,scurve_T2(:,:));
%  %   hold on
% %end
% title('scurve After threshold trimming 2nd');
% xlabel('fC');
% ylabel('Hit Efficiency');
%  %% error function fit
% hold off; 
% x_T2=fC_T2;
%  for i  = 1 : 1 : channels_T2
% y_T2 = scurve_T2(i,:);
% 
% [fitresult_T2,gof_T2]=createFit1(x_T2,y_T2);
% 
% fC_fine_T2 = (0:.01:max(fC_T2))';    % generate fC array with 0.1fc resolution , we can generate as much as we like
% s_fine_T2(:,i)  = fitresult_T2(fC_fine_T2); %get fitted data w.r.t injected fC array
% %s_diff(:,i)  = differentiate(s_fine(:,i),fC_fine);
% s_diff_T2(:,i)  = differentiate(fitresult_T2,fC_fine_T2);
% 
% %w= s_diff;
% %x=fC_fine;
% %dim = min(find(size(x)~=1));
% %y = sum(w.*x,dim)./sum(w,dim);
% mean_th_T2(i) = wmean(fC_fine_T2,s_diff_T2(:,i));
% mean_enc_T2(i) = std(fC_fine_T2,s_diff_T2(:,i));
%  end
%  
%  %% exception handling of mean enc mean th
% % NAN_mean_th= isnan(mean_th);
%  
%  
%  %%
% 
%  
%  %%
%  M_O_mean_Th_T2  = mean(mean_th_T2(:));
%  M_O_mean_Th_std_T2 = std(mean_th_T2(:));
% M_O_mean_ENC_T2 = mean(mean_enc_T2(:));
% M_O_mean_ENC_std_T2 = std(mean_enc_T2(:));
% 
% %%
% %%
% 
% 
% 
% 
% % Threshold plots  for second scurves
% figure();
%  title('Mean Threshold and enc plots 2');
%  subplot(2,2,1);
% plot(mean_th);
% title(' Thresholds(fC) All channels(BEFORE)');
% ylabel('Th(fC)');
% xlabel('# of channels');
% axis([1 stop_chan double(M_O_mean_Th - (6.0 * M_O_mean_Th_std)) double(M_O_mean_Th +(6.0* M_O_mean_Th_std))]);
% %axis([-10 10 0 inf])
% subplot(2,2,2);
% plot(mean_th_T2);
% title(' Threshold(fC) All channels (AFTER)2');
% ylabel('Th(fC)');
% xlabel('# of channels');
% axis([1 stop_chan double(M_O_mean_Th_T2 - (6.0* M_O_mean_Th_std_T2)) double(M_O_mean_Th_T2 + (6.0* M_O_mean_Th_std_T2))]);
% 
% subplot(2,2,3);
% hist_mean_th = histogram(mean_th,20);
% 
% title(' Mean thresholds (Histogram ) (BEFORE)');
% xlabel('Th(fC)');
% ylabel('channel count');
% axis([1 stop_fc 1 50]);
% 
% str = ['Mean ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th* 6241.51)),'e)'];
% text(3.3,47,str);
% str = ['std     ',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
% text(3.3,42,str)
% 
% 
% subplot(2,2,4);
% hist_mean_enc = histogram(mean_th_T2,20);
% title(' Mean Threshold(Histogram )(AFTER)2');
% xlabel('Threshold(fC)');
% ylabel('channel count');
% axis([1 stop_fc 1 50]);
% str = ['Mean ', num2str(round(M_O_mean_Th_T2,3)),'fC (',num2str(round(M_O_mean_Th_T2 * 6241.51)),'e)' ];
% text(4,47,str);
% str = ['std     ',num2str(round(M_O_mean_Th_std_T2,3)),'fC (',num2str(round(M_O_mean_Th_std_T2* 6241.51)),'e)'];
% text(4,42,str);
% 
%  % ENC plots
% 
%  figure();
%  title('Mean enc plots');
%  subplot(2,2,1);
% plot(mean_enc);
% title(' ENC(fC) All channels(BEFORE)');
% ylabel('ENC(fC)');
% xlabel('# of channels');
% axis([1 128 0 .5]);
% %axis([-10 10 0 inf])
% subplot(2,2,2);
% plot(mean_enc_T2);
% title(' ENC(fC) All channels (AFTER)2');
% ylabel('ENC(fC)');
% xlabel('# of channels');
% axis([1 128 0 .5]);
% 
% subplot(2,2,3);
% histogram(mean_enc,20);
% title(' Mean ENC (Histogram ) (BEFORE)');
% xlabel('ENC(fC)');
% ylabel('channel count');
% axis([0 .5 0 60]);
% 
% str = ['Mean ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC* 6241.51)),'e)'];
% text(.1,47,str);
% str = ['std     ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
% text(.1,42,str)
% 
% 
% subplot(2,2,4);
% histogram(mean_enc_T2,20);
% title(' Mean ENC(Histogram )(AFTER)2');
% xlabel('ENC(fC)');
% ylabel('channel count');
% axis([0 .5 0 60]);
% str = ['Mean ', num2str(round(M_O_mean_ENC_T2,3)),'fC (',num2str(round(M_O_mean_ENC_T2 * 6241.51)),'e)' ];
% text(.1,47,str);
% str = ['std     ',num2str(round(M_O_mean_ENC_std_T2,3)),'fC (',num2str(round(M_O_mean_ENC_std_T2* 6241.51)),'e)'];
% text(.1,42,str);

 % combined distributions
%hist_all = [hist_mean_enc hist_mean_th];
% figure('position',[200 200 1200 800]);
% subplot(2,1,1);
% histogram(mean_enc);
% hold on ;
% histogram(mean_th);
% axis([0 5 0 50]);
% title('Combined Distribution Plot(BEFORE Trimming)');
% xlabel('Charge_{fC}');
% ylabel('channel count');
% 
% x1 = M_O_mean_Th;
% y1 = -5;
% txt1 = '\uparrow MeanTh_{fC}';
% text(x1,y1,txt1)
% x2 = M_O_mean_ENC;
% y2 = -5;
% txt2 = '\uparrow MeanENC(fC)';
% text(x2,y2,txt2)
% 
% 
% txt_x = 0.5;
% txt_y = 20;
% str = ['MeanENC :   ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC* 6241.51)),'e)'];
% text(txt_x,30,str);
% str = ['std          :   ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
% text(txt_x,txt_y-2,str)
% 
% txt_x = 3;
% txt_y = 20;
% str = ['MeanTh :   ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th* 6241.51)),'e)'];
% text(txt_x,txt_y,str);
% str = ['std          :   ',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
% text(txt_x,txt_y-2,str)
% 
%  % combined after trimming
% 
% subplot(2,1,2);
% histogram(mean_enc_T2);
% hold on ;
% histogram(mean_th_T2);
% axis([0 5 0 30]);
% title('Combined Distribution Plot (AFTER Trimming) 2');
% xlabel('Charge_{fC}');
% ylabel('channel count');
% 
% x1 = M_O_mean_Th_T2;
% y1 = -5;
% txt1 = '\uparrow MeanTh_{fC}';
% text(x1,y1,txt1)
% x2 = M_O_mean_ENC_T2;
% y2 = -5;
% txt2 = '\uparrow MeanENC(fC)';
% text(x2,y2,txt2)
% 
% txt_x = 0;
% txt_y = 20;
% str = ['MeanENC :   ', num2str(round(M_O_mean_ENC_T2,3)),'fC (',num2str(round(M_O_mean_ENC_T2* 6241.51)),'e)'];
% text(txt_x,txt_y,str);
% str = ['std          :   ',num2str(round(M_O_mean_ENC_std_T2,3)),'fC (',num2str(round(M_O_mean_ENC_std_T2* 6241.51)),'e)'];
% text(0,txt_y-2 ,str)
% 
% str = ['MeanTh :   ', num2str(round(M_O_mean_Th_T2,3)),'fC (',num2str(round(M_O_mean_Th_T2* 6241.51)),'e)'];
% text(txt_x+3,txt_y,str);
% str = ['std          :   ',num2str(round(M_O_mean_Th_std_T2,3)),'fC (',num2str(round(M_O_mean_Th_std_T2* 6241.51)),'e)'];
% text(txt_x+3,txt_y-2,str)

