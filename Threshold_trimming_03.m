%% scurve Analysis for vfat3



clearvars;
%%
sync  = [202 0 2 ]';

%% sync 
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


%% do scurve for all channels
   % clear all trimming registers
for i=0 : 127
    write_register(i,0);
end


start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(100);
arm_dac = 99;
D1 = uint16(5) ;D2 = uint16(500) ;DELAY = uint8(20);
start_fc = 2.0 ;
stop_fc = 9.0 ;
step_fc = 0.26 ;
fc_size = uint8(ceil(((stop_fc - start_fc)/step_fc)+1));
dac = uint8(zeros(1,fc_size))
fc_arr = double(zeros(1,fc_size))
c = 64.070068 ;
m = -0.260292;
num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;
for j = 1 : fc_size 


dac(1,j) =  ((start_fc+ step_fc*double(j-1))*(1/m )) - c/m;  
fc_arr(j) =  start_fc + (step_fc * double((j-1)));

end
%% run scurve all channels
tx_data=uint8([202 255 8 start_chan stop_chan step_chan 0 0 0 fliplr(typecast(Latency,'uint8')) fliplr(typecast(LV1As,'uint8')) arm_dac DELAY  fliplr(typecast(D1,'uint8')) fliplr(typecast(D2,'uint8')) fc_size dac(:)'])';
fprintf('%x \n',tx_data(:,:))
 
scurve_uint16 = uint16(zeros(num_of_channels,fc_size));
t = tcpip('192.168.1.10',7);

fopen(t);
fwrite(t,tx_data);
for i=1: num_of_channels 

    scurve_uint16(i,:) = typecast(uint8(fread(t,double(fc_size*2))),'uint16' );
   %scurve(i,:) = typecast( S_ch_8, 'uint16');
end

fclose(t);




    
%% load labview data
%load 'f:\labview\data\scurve.txt';
%load 'f:\labview\data\fC.txt';
scurve=double(double(scurve_uint16)./double(LV1As));
channels = size(scurve,1)    % no. of columns 
fC_steps = fc_size           % no. of rows
fC  = fc_arr
hold on

%for i  = 1 : 1 : channels
figure();
    plot(fC,scurve(:,:));
 %   hold on
%end
title('scurve before threshold trimming');
xlabel('fC');
ylabel('Hit Efficiency');
 %% error function fit
hold off; 
x=fC;
 for i  = 1 : 1 : channels
y = scurve(i,:);

[fitresult,gof]=createFit1(x,y);
 
fC_fine = (0:.01:max(fC))';    % generate fC array with 0.1fc resolution , we can generate as much as we like
s_fine(:,i)  = fitresult(fC_fine); %get fitted data w.r.t injected fC array
%s_diff(:,i)  = differentiate(s_fine(:,i),fC_fine);
s_diff(:,i)  = differentiate(fitresult,fC_fine);


mean_th(i) = wmean(fC_fine,s_diff(:,i));
mean_enc(i) = std(fC_fine,s_diff(:,i));
 end
 
 %% exception handling of mean enc mean th
 NAN_mean_th= isnan(mean_th);
 
 
 %%
%%
figure();
plot(fC_fine,s_fine(:,:));
title('fitted scurves');
%hold on;
%figure;
%plot(fC_fine,0.01*s_diff(:,:)');
%title('scurve before threshold trimming');
xlabel('fC');
ylabel('Hit Efficiency');
 
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

str = ['Mean ', num2str(M_O_mean_Th),'fC (',num2str(M_O_mean_Th* 6241.51),'e)'];
text(3.3,47,str);
str = ['std     ',num2str(M_O_mean_Th_std),'fC (',num2str(M_O_mean_Th_std* 6241.51),'e)'];
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
title('combined distributions');
xlabel('Charge(fC)');
ylabel('channel count');
x1 = [0.147  .147];
y1 = [.05 .1];
annotation('textarrow',x1,y1,'String','Mean ENC ')

x2 = [.66  .66];
y2 = [.05 .1];
annotation('textarrow',x2,y2,'String','   Mean Threshold ')


%% send arming dac to new value


  %new_diff=double(100.0);
NUM_OF_CHANNELS = 128; %0, 1  
READ    = uint8(0);
WRITE   = uint8(1);
YES     = uint8(1);
NO      = uint8(0);
ADDRESS = uint16(0);
channel = uint16(0);
DATA    = int16(0);
Threshold= double(zeros(1,NUM_OF_CHANNELS));
scurve_1_ch = double(zeros(NUM_OF_CHANNELS,fc_size));
channel = 0;
i=1;
j=1;
while channel <= (NUM_OF_CHANNELS-1)
ADDRESS = channel;
j=1;
DATA = 0;

    % channel trim loop do trimming while channel is trimmed
old_diff = double(100.0);
new_diff = double(100.0);

ch_trim = NO;
Threshold(channel+1)= scurve_one_channel(channel,m,c,start_fc,stop_fc,step_fc,fC);

if(Threshold(channel+1) > M_O_mean_Th) % if channel threshold is greater than mean
    sign= 1; 
else 
    sign =0;
end
while ch_trim ~= YES 
%% run scurve on one channel 

 %%
 %DATA = 64;
 %channel = 0;
% compare threshold with mean threshold

%%
if abs(DATA)>=63
    ch_trim =YES;
    
else
 
    if(sign ==1)
DATA = DATA -1;
Threshold_understanadable(i,j) = DATA;
    else 
DATA = DATA +1;
Threshold_understanadable(i,j) = DATA;
    end
    
write_register(ADDRESS,sign_bit_conversion(DATA));
% send this value to vfat3
Threshold(channel+1)= scurve_one_channel(channel,m,c,start_fc,stop_fc,step_fc,fC);%find threshold of channel
fprintf('Threshold(%d) = %f \t', channel, Threshold(channel+1));



old_diff = new_diff;
new_diff = abs(M_O_mean_Th - Threshold(channel+1));
if(new_diff == 0.0 ) 
    ch_trim = YES;
    
elseif(new_diff < .03)
    ch_trim = YES;
    
    
end

end
if ch_trim== YES
    
    Trim_dac(channel +1) = DATA; % desired value
    write_register(ADDRESS,Trim_dac(channel+1));%send to vfat3 trim value
    
end   

fprintf('old_diff= %5.3f new_diff =%5.3f  ch_trim %d \n',old_diff,new_diff,ch_trim);
j=j+1;
end % end while single channel trim done
channel = channel +1;
i=i+1;
end


 %%
 figure();
 plot(Threshold);
figure();
histogram(Threshold);
M= mean(Threshold)*6241.51
S= std(Threshold)* 6241.51;




%% repeat scurves again


   % clear all trimming registers

start_chan_T = 0 ;stop_chan_T = 127 ;step_chan_T = 1 ;
Latency_T = uint16(0);
LV1As_T   = uint16(100);
arm_dac_T = 99;
D1_T = uint16(5) ;D2_T = uint16(500) ;DELAY_T = uint8(20);
start_fc_T = 2.0 ;
stop_fc_T = 9.0 ;
step_fc_T = 0.26 ;
fc_size_T = uint8(ceil(((stop_fc_T - start_fc_T)/step_fc_T)+1));
dac_T = uint8(zeros(1,fc_size_T))
fc_arr_T = double(zeros(1,fc_size_T))
c = 64.070068 ;
m = -0.260292;
num_of_channels_T = ( (stop_chan_T - start_chan_T)/step_chan_T)+1;
for j = 1 : fc_size_T 


dac_T(1,j) =  ((start_fc_T+ step_fc_T*double(j-1))*(1/m )) - c/m;  
fc_arr_T(j) =  start_fc_T + (step_fc_T * double((j-1)));

end
 % run scurve all channels
tx_data_T=uint8([202 255 8 start_chan_T stop_chan_T step_chan_T 0 0 0 fliplr(typecast(Latency_T,'uint8')) fliplr(typecast(LV1As_T,'uint8')) arm_dac_T DELAY_T  fliplr(typecast(D1_T,'uint8')) fliplr(typecast(D2_T,'uint8')) fc_size_T dac_T(:)'])';
fprintf('%x \n',tx_data_T(:,:))
 
scurve_uint16_T = uint16(zeros(num_of_channels_T,fc_size_T));
t = tcpip('192.168.1.10',7);

fopen(t);
fwrite(t,tx_data_T);
for i=1: num_of_channels_T 

    scurve_uint16_T(i,:) = typecast(uint8(fread(t,double(fc_size_T*2))),'uint16' );
   %scurve(i,:) = typecast( S_ch_8, 'uint16');
end

fclose(t);




    
%% load labview data
%load 'f:\labview\data\scurve.txt';
%load 'f:\labview\data\fC.txt';
scurve_T=double(double(scurve_uint16_T)./double(LV1As_T));
channels_T = size(scurve_T,1)    % no. of columns 
fC_steps_T = fc_size_T;           % no. of rows
fC_T  = fc_arr_T;
hold on

%for i  = 1 : 1 : channels
figure();
    plot(fC_T,scurve_T(:,:));
 %   hold on
%end
title('scurve After threshold trimming');
xlabel('fC');
ylabel('Hit Efficiency');
 %% error function fit
hold off; 
x_T=fC_T;
 for i  = 1 : 1 : channels_T
y_T = scurve_T(i,:);

[xData_T, yData_T] = prepareCurveData( x_T, y_T );
ft_T = fittype( '0.5 * erf( (x-a)/(sqrt(2)*b) ) + 0.5 ' ,'dependent',{'y'},'independent',{'x'},'coefficients',{'a','b'});
options_T = fitoptions;
options_T.Normal = 'on';
[fitresult_T, gof_T] = fit( xData_T, yData_T, ft_T,options_T);
f_res_T = fitresult(x_T); 
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
 
fC_fine_T = (0:.01:max(fC_T))';    % generate fC array with 0.1fc resolution , we can generate as much as we like
s_fine_T(:,i)  = fitresult_T(fC_fine_T); %get fitted data w.r.t injected fC array
%s_diff(:,i)  = differentiate(s_fine(:,i),fC_fine);
s_diff_T(:,i)  = differentiate(fitresult_T,fC_fine_T);

%w= s_diff;
%x=fC_fine;
%dim = min(find(size(x)~=1));
%y = sum(w.*x,dim)./sum(w,dim);
mean_th_T(i) = wmean(fC_fine_T,s_diff_T(:,i));
mean_enc_T(i) = std(fC_fine_T,s_diff_T(:,i));
 end
 
 %% exception handling of mean enc mean th
% NAN_mean_th= isnan(mean_th);
 
 
 %%
%%
figure();
plot(fC_fine_T,s_fine_T(:,:));
title('fitted scurves after trimming');
%hold on;
%figure;
%plot(fC_fine,0.01*s_diff(:,:)');
%title('scurve before threshold trimming');
xlabel('fC');
ylabel('Hit Efficiency');
 
 %%
 M_O_mean_Th_T  = mean(mean_th_T(:));
 M_O_mean_Th_std_T = std(mean_th_T(:));
M_O_mean_ENC_T = mean(mean_enc_T(:));
M_O_mean_ENC_std_T = std(mean_enc_T(:));
 figure();
 title('Mean Threshold and enc plots after trimming');
 subplot(2,2,1);
plot(mean_th_T);
title(' Thresholds(fC) All channels(after trimming)');
ylabel('Th(fC)');
xlabel('# of channels');
axis([1 128 2 8]);
%axis([-10 10 0 inf])
subplot(2,2,2);
plot(mean_enc_T);
title(' ENC(fC) All channels(after trimming)');
ylabel('ENC(fC)');
xlabel('# of channels');
axis([1 128 0 .5]);

subplot(2,2,3);
hist_mean_th_T = histogram(mean_th_T,20);
title(' Mean thresholds (Histogram )(after trimming)');
xlabel('Th(fC)');
ylabel('channel count');
axis([3 7 1 50]);

str = ['Mean ', num2str(M_O_mean_Th_T),'fC (',num2str(M_O_mean_Th_T* 6241.51),'e)'];
text(3.3,47,str);
str = ['std     ',num2str(M_O_mean_Th_std_T),'fC (',num2str(M_O_mean_Th_std_T* 6241.51),'e)'];
text(3.3,42,str)


subplot(2,2,4);
hist_mean_enc_T = histogram(mean_enc_T,20);
title(' Mean ENC(Histogram )(after trimming)');
xlabel('ENC(fC)');
ylabel('channel count');
axis([0 .5 1 50]);
str = ['Mean ', num2str(M_O_mean_ENC_T),'fC (',num2str(M_O_mean_ENC_T* 6241.51),'e)' ];
text(0.1,47,str);
str = ['std     ',num2str(M_O_mean_ENC_std_T),'fC (',num2str(M_O_mean_ENC_std_T* 6241.51),'e)'];
text(.1,42,str)
%%

%hist_all = [hist_mean_enc hist_mean_th];
figure();
histogram(mean_enc_T,20);
hold on ;
histogram(mean_th_T,20);
axis([0 7 0 130]);
title('combined distributions (after trimming)');
xlabel('Charge(fC)');
ylabel('channel count');
x1 = [0.147  .147];
y1 = [.05 .1];
annotation('textarrow',x1,y1,'String','Mean ENC ')

x2 = [.66  .66];
y2 = [.05 .1];
annotation('textarrow',x2,y2,'String','   Mean Threshold ')


