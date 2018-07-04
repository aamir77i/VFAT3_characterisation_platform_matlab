function [Threshold,scurve] = scurve_one_channel(channel,fc_size,fC,dac,arm_dac,LV1As,DELAY)
%scurve_one_channel This function finds threshold of a channel after getting scurve of a single channel
%   Detailed explanation goes here

start_chan = channel ;
stop_chan = channel ;
step_chan = 1;
Latency = uint16(0);
%LV1As   = uint16(200);
%arm_dac = 50;
D1 = uint16(5) ;
D2 = uint16(500) ;
%DELAY = uint8(40);
%start_fc = 3.0 ;
%stop_fc = 6.0 ;
%step_fc = 0.26 ;
fC_fine = (0:.01:max(fC))';    % generate fC array with 0.1fc resolution
%fc_size = uint8(ceil(((stop_fc - start_fc)/step_fc)+1));
%dac = uint8(zeros(1,fc_size));
%fc_arr = double(zeros(1,fc_size));
%c = 64.070068 ;
%m = -0.260292;
%num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;
% for j = 1 : fc_size 
% 
% 
% dac(1,j) =  ((start_fc+ step_fc*double(j-1))*(1/m )) - c/m;  
% fc_arr(j) =  start_fc + (step_fc * double((j-1)));
% end
tx_data=uint8([202 255 8 start_chan stop_chan step_chan 0 0 0 fliplr(typecast(Latency,'uint8')) fliplr(typecast(uint16(LV1As),'uint8')) uint8(arm_dac) uint8(DELAY)  fliplr(typecast(D1,'uint8')) fliplr(typecast(D2,'uint8')) fc_size dac(:)'])';
%fprintf('%x \n',tx_data(:,:))

scurve_1_uint16 = uint16(zeros(1,fc_size));
scurve_1 = double(zeros(1,fc_size));

t = tcpip('192.168.1.10',7);

fopen(t);
fwrite(t,tx_data);
%for i=1: num_of_channels 
               % receive scurve data for single channel
    scurve_1_uint16(1,:) = typecast(uint8(fread(t,double(fc_size*2))),'uint16' );
    scurve_1(1,:)=double(double(scurve_1_uint16)./double(LV1As));
   %scurve(i,:) = typecast( S_ch_8, 'uint16');
%end

fclose(t);

%fit single channel 

   %   curve fit
x=fC;
 %for i  = 1 : 1 : channels
y = scurve_1(1,:);
[fitresult,gof]=createFit1(x,y);

%s_1_fine  = fitresult(fC_fine); %get fitted data w.r.t injected fC array
%s_diff(:,i)  = differentiate(s_fine(:,i),fC_fine);
s_1_diff  = differentiate(fitresult,fC_fine);


  % calculate threshold & enc for single channel
th_1  = wmean(fC_fine,s_1_diff);

Threshold = th_1;
scurve = scurve_1(1,:);
%enc       = enc_1;


