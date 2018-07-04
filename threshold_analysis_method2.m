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

load arm_dac_fc_all_gains_vfat22.mat;
%%
VFAT3_NUMBER = 'vfat3#22';
Peaking_time = "100"; 
Pre_Gain =  "HG"  ;%"Medium" , " High" 
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(1000);
D1 = uint16(5) ;D2 = uint16(400) ;DELAY = uint8(1);
calpulse = uint8(1);
 
start_fc = 0.0 ;
stop_fc = 4.0 ;
num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;

%% connect  hard reset chip
sync_chip();
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
charge = (0:0.05:5)';
fprintf("arm dac  :: charge\r\n");
%test_dac = round(Arming_fit(charge(:)));
%for i =1:size(charge,1)
%fprintf('%f   ::  %f  \r\n',test_dac(i) ,charge(i) );
%end
%% 
%load 'Arming_fit_100_HG.mat';
%% SET  ALL  trimming registers TO MAX before running scurves
for i=0 : 127
    write_register(i,63);
end
 

fc_arr = double(start_fc:step_fc:stop_fc)
fc_size = size(fc_arr,2)
 
dac = uint8(round(Lfit_caldac(fc_arr)))
%%
arm_dac =20;
Arming_th = Arming_fit_HG(double(arm_dac))

%% 
[scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 

%%
%% noisy channels
for i=1:128
    if(mean_enc(i)>(M_O_mean_ENC + (M_O_mean_ENC_std*3)))
        noisy(i)=0;% 0 for noisy channel 
    else noisy(i)=1;% 1 for good channel    
    end
end
figure();
plot(noisy);
axis([1 128 -1 2])

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
for i=0 : 127
    write_register(i,63);
end

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

    

while channel <= (NUM_OF_CHANNELS-1)
ADDRESS = channel;
j=1;
DATA = 63;
old_difference = 1000.0;
new_difference = 1000.0;
set=0;
    % channel trim loop do trimming while channel is trimmed
%old_diff = double(100.0);
%new_diff = double(100.0);
fprintf('channel = %d \n', channel);
while true 
    
    Trim_dac(channel+1,j) = DATA;
   write_register(ADDRESS,sign_bit_conversion(DATA));
   %%%%%%%%%%%%%%%scurve to get threshold value
   while true 
    [~,~,~,M_O_mean_Th_1,~,~,~] = scurve_all_channel(channel,channel,1,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
                       
        Threshold(channel+1,j)= M_O_mean_Th_1;
        if (Threshold(channel+1,j)~=0.0)
            break; 
        end
   end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % fprintf('Threshold(%d, %d) = %f  Trim_dac(%d, %d) = %f \n', channel,j, Threshold(channel+1,j),channel,j,Trim_dac(channel+1,j));

    new_difference = abs(double(Threshold(channel+1,j)) - double(minimum_val)) ;
    fprintf('Threshold(%d, %d) = %f  Trim_dac(%d, %d) = %f  new_difference = %f\n', channel,j, Threshold(channel+1,j),channel,j,Trim_dac(channel+1,j),new_difference);

    if Threshold(channel+1,j) > minimum_val % ALGORITHM CONVERGING 
    
            if DATA > -63  
                
                if new_difference >0.1 
                    DATA = DATA - 6;%4,6  was working well, lets test  jump of 8
                else
                    DATA = DATA - 1;
                end
            else
                set=1;
            end
    elseif Threshold(channel+1,j) ==       minimum_val
        set =1;
    elseif old_difference < new_difference 
        set=1;
        DATA = DATA + 1;%GET OLD VALUE OF DATA 
    else 
        set=1;
        
    end
    
   old_difference = new_difference;
   
   
j=j+1;
    if set==1
       fprintf('break \n');
    break;
   end
end
Trimming_dac(channel+1) = DATA; 


    


%%

write_register(ADDRESS,sign_bit_conversion(round(Trimming_dac(channel+1))));% writing correct trimming value in local channel register


channel = channel +1;

end
%%
Trim_dac_rounded = round(Trimming_dac(:));
figure();
p= plot(Trim_dac_rounded);
title('TrimDac vs. channel ');
xlabel('channel');
ylabel('TrimDac');


str0 = ['',VFAT3_NUMBER];
str1 = ['ArmDac:',num2str(Arming_th),'fC (',num2str(Arming_th * 6241.51),'e)','(',num2str(arm_dac),')'];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=120;y0=70;
x1=80;y1=0;
x2=80;y2=-5;
%x3=80;y3=-10;
text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);
%text(x3,y3,str3);
%text  = num2str('ArmingTh',Arm_dac_fC,'fC');
%PrintLegend('TrimDac vs. channel',VFAT3_NUMBER ,Arming_th,arm_dac,Pre_Gain,Peaking_time,100,0);
%% ensure trim dac loading to the chip
for i= 0 : 127
    write_register(i,Trim_dac_rounded(i+1));
end
%% scurve post trimming
[scurve_T,mean_th_T,mean_enc_T,M_O_mean_Th_T,M_O_mean_Th_std_T,M_O_mean_ENC_T,M_O_mean_ENC_std_T] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
 

%% %% scurve plots
col= ["red" "green"  "blue" "cyan" "black"];
figure();

subplot(2,1,1);
plot(fc_arr,scurve);
title 'Scurve before Trimming'
xlabel Charge(fc);
ylabel efficiency;

subplot(2,1,2);
plot(fc_arr,scurve_T);
title 'Scurve after Trimming'
xlabel Charge(fc);
ylabel efficiency;

%%


%% threshold plots

figure;

subplot(2,1,1);
plot (mean_th,'r-x'); 
hold on;
axis([1 stop_chan 0.5 3]);
str = ['\mu: ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th * 6241.51)),'e)' ];
text(3,M_O_mean_Th+1,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
text(3,M_O_mean_Th +.7,str);
%title('Mean Threshold (Before trimming)');
xlabel 'channel number';
ylabel 'Charge (fC)';
P_Three_sigma =  M_O_mean_Th + ones(1,128)* 3* M_O_mean_Th_std ;
N_Three_sigma =  M_O_mean_Th - ones(1,128)* 3* M_O_mean_Th_std ;
plot(P_Three_sigma,'color','blue')
plot(N_Three_sigma, 'color','blue')
plot_conditions(VFAT3_NUMBER,Arming_th,arm_dac,Pre_Gain,Peaking_time);

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
subplot(2,1,2);
plot (mean_th_T,'r-x');
hold on;
axis([1 stop_chan 0.5 3]);
str = ['\mu: ', num2str(round(M_O_mean_Th_T,3)),'fC (',num2str(round(M_O_mean_Th_T * 6241.51)),'e)' ];
text(3,M_O_mean_Th_T+1,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std_T,3)),'fC (',num2str(round(M_O_mean_Th_std_T* 6241.51)),'e)'];
text(3,M_O_mean_Th_T +.7,str);
%title('Mean Threshold (Before trimming)');
xlabel 'channel number';
ylabel 'Charge (fC)';
P_Three_sigma =  M_O_mean_Th_T + ones(1,128)* 3* M_O_mean_Th_std_T ;
N_Three_sigma =  M_O_mean_Th_T - ones(1,128)* 3* M_O_mean_Th_std_T ;
plot(P_Three_sigma,'color','blue')
plot(N_Three_sigma, 'color','blue')
grid on;
grid 'minor';
%% threshold histograms

figure();


%title('Threshold Histograms(Before trimming)');


subplot(2,1,1);
histogram(mean_th,'facecolor',col(1)); 
axis([start_fc stop_fc 1 50]);
str = ['\mu: ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th * 6241.51)),'e)' ];
text(M_O_mean_Th+.7,38,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
text(M_O_mean_Th+.7,35,str);

xlabel 'charge (fC)';
ylabel 'Channel count';
grid on;
grid 'minor';

subplot(2,1,2);
histogram(mean_th_T,'facecolor',col(1)); 
axis([start_fc stop_fc 1 50]);
str = ['\mu: ', num2str(round(M_O_mean_Th_T,3)),'fC (',num2str(round(M_O_mean_Th_T * 6241.51)),'e)' ];
text(M_O_mean_Th_T+.7,38,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std_T,3)),'fC (',num2str(round(M_O_mean_Th_std_T* 6241.51)),'e)'];
text(M_O_mean_Th_T+.7,35,str);

xlabel 'charge (fC)';
ylabel 'Channel count';
grid on;
grid 'minor';

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

subplot(2,1,1);
plot (y,'r-x');
title 'ENC before trimming'
hold on;
axis([1 stop_chan 0 .3 ]);
str = ['\mu: ', num2str(round(NUMBER,3)),'fC (',num2str(round(NUMBER * 6241.51)),'e)' ];
text(3,NUMBER + .13,str);
str = ['\sigma:',num2str(round(NUMBER_STD,3)),'fC (',num2str(round(NUMBER_STD* 6241.51)),'e)'];
text(3,NUMBER +.1,str);
%title('Mean Threshold (Before trimming)');
xlabel 'channel number';
ylabel 'Charge (fC)';
P_Three_sigma =  NUMBER + ones(1,128)* 3* NUMBER_STD ;
N_Three_sigma =  NUMBER - ones(1,128)* 3* NUMBER_STD ;
plot(P_Three_sigma,'color','blue')
plot(N_Three_sigma, 'color','blue')
grid on;
grid 'minor';
hold off;

subplot(2,1,2);
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
ylabel 'Charge (fC)';
P_Three_sigma =  NUMBER + ones(1,128)* 3* NUMBER_STD ;
N_Three_sigma =  NUMBER - ones(1,128)* 3* NUMBER_STD ;
plot(P_Three_sigma,'color','blue')
plot(N_Three_sigma, 'color','blue')
grid on;
grid 'minor';
hold off;

%% enc histograms
figure;

histogram(mean_enc,'facecolor',col(1));
axis([0 1 0 50]);


str = ['\mu: ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC * 6241.51)),'e)' ];
text(0,40,str);
str = ['\sigma: ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
text(0,35,str);
xlabel 'charge (fC)';
ylabel 'channel count';




