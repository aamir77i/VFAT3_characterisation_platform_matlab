function [scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse)
%scurve_Multichannels  It performs scurve for more than one channel
%Detailed explanation goes here

%% do scurve for all channels
   % clear all trimming registers

%start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
%Latency = uint16(0);
%LV1As   = uint16(500);
%arm_dac = 30;
%D1 = uint16(5) ;D2 = uint16(500) ;DELAY = uint8(200);
%start_fc = 0.0 ;
%stop_fc = 5.0 ;
%step_fc = 0.25 ;
%fc_size = uint8(ceil(((stop_fc - start_fc)/step_fc)+1));
%dac = uint8(zeros(1,fc_size))
%fc_arr = double(zeros(1,fc_size))
%c = 64.070068 ;
%m = -0.260292;
num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;
%%
%fc_arr = double(start_fc:step_fc:stop_fc)
fc_size = size(fc_arr,2);
%% test 
%%dac = uint8(round(Lfit_caldac(fc_arr)));
%%
%% run scurve all channels
tx_data=uint8([202 255 8 uint8(start_chan) uint8(stop_chan) uint8(step_chan) 0 0 0 fliplr(typecast(uint16(Latency),'uint8')) fliplr(typecast(uint16(LV1As),'uint8')) uint8(arm_dac) uint8(DELAY)  fliplr(typecast(D1,'uint8')) fliplr(typecast(D2,'uint8')) uint8(calpulse) uint8(fc_size) dac(:)'])';
%fprintf('%x \n',tx_data(:,:))
 
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
channels = size(scurve,1);    % no. of columns 
%fC_steps = fc_size           % no. of rows


fC  = fc_arr;
fC_fine = (0:.1:max(fC))';    % generate fC array with 0.1fc resolution , we can generate as much as we like
mean_th= double(zeros(1,channels));
mean_enc= double(zeros(1,channels));
s_fine= double( zeros( size(fC_fine,1),channels     )  );
s_diff= double(zeros(size(fC_fine,1),channels));
%% error function fit
 

if(calpulse==1)
x=fC;
 for i  = 1 : 1 : channels
y = scurve(i,:);
%subplot(12,11,i);
[fitresult,~]=createFit1(x,y);
 

s_fine(:,i)  = fitresult(fC_fine); %get fitted scurve data w.r.t injected fC array
%s_diff(:,i)  = differentiate(s_fine(:,i),fC_fine);
s_diff(:,i)  = differentiate(fitresult,fC_fine);


mean_th(i) = wmean(fC_fine,s_diff(:,i));
mean_enc(i) = std(fC_fine,s_diff(:,i));
 end
 
 
 
 
 %%
%%
% figure();

 %%

else
    for i=1:channels
mean_th(i) = mean(scurve(i,:));
mean_enc(i) = std(scurve(i,:));    
    end
end





M_O_mean_Th  = mean(mean_th(:));
M_O_mean_Th_std = std(mean_th(:));
M_O_mean_ENC = mean(mean_enc(:));
M_O_mean_ENC_std = std(mean_enc(:));

end

