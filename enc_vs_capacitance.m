
Peaking_time = "45"; % 15 25 36 45 
Pre_Gain =  "HG"  ;% LG MG HG  
start_chan = 0 ;stop_chan = 127 ;step_chan = 1 ;
Latency = uint16(20);
LV1As   = uint16(1000);
D1 = uint16(23);
D2 = uint16(200);
DELAY = uint8(1);
calpulse = uint8(1);
arm_dac = uint8(60);
%start_fc = -2.0 2
%stop_fc = 20.0 ;

num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;
%% connect  hard reset chip
a=sync_chip()
SOFT =uint8(0);
HARD =uint8(255);
sc_hw = SOFT;
%% read chip id
 chip_id = strcat('vfat3-',num2str(read_register(hex2dec('00010003'),sc_hw)))
 VFAT3_NUMBER = chip_id;
% VFAT3_NU  MBER= 'VFAT3-TEST';
%% Adjust IREF 
[IREF] = AdjustIref();

%% Cal_dac to fC 
[Lfit_caldac,Lfit_charge,step_fc,cal_dac,charge_injected,A,B] = caldac_to_fC(VFAT3_NUMBER);
Max_Caldac = floor(Lfit_charge(0))
%% front end settings
 
set_preamp(Peaking_time,Pre_Gain,sc_hw);
%%
front_end_default  = [202 255 9 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,front_end_default);
A = uint8(fread(t,4));
fclose(t);

%%
%Arming_fit = fc_arm_dac(step_fc,Lfit_caldac,leg,x_label,y_label,VFAT3_NUMBER,Pre_Gain,Peaking_time)

% %% clear all trimming registers before running scurves
% for i=0 : 127
%     write_register(i,0,sc_hw);
% end
 %%

 
Max_Caldac = floor(Lfit_charge(0));
start_fc = 0.0 ;
stop_fc = 8.0;

fc_arr = double(start_fc:step_fc:stop_fc)
fc_size = size(fc_arr,2)
 
dac = uint8(round(Lfit_caldac(fc_arr)))
% [scurve0,mean_th0,mean_enc0,M_O_mean_Th0,M_O_mean_Th_std0,M_O_mean_ENC0,M_O_mean_ENC_std0] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac);

%Arming_th=6.0;% start arm_dac from 5.0 and go to some criteria
%arm_dac = uint8(round(Arming_fit(Arming_th)))
%Criteria = 1.0;%fC
%i= 1;
%
 
%Arming_th = 2.5;% fC

[scurve,mean_th,mean_enc,~,~,~,~] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
%%
Bad_mean_th = find(isnan(mean_th))
mean_th(Bad_mean_th) = 0; 
Bad_mean_enc = find(isnan(mean_enc))
mean_enc(Bad_mean_enc) = 0; 
%%
M_O_mean_Th  = mean(mean_th(:));
M_O_mean_Th_std = std(mean_th(:));
M_O_mean_ENC = mean(mean_enc(:));
M_O_mean_ENC_std = std(mean_enc(:));

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
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
subplot(3,2,2);
plot(fc_arr,scurve,'color',col(1));
title 'scurve plot'
xlabel Charge(fc);
ylabel efficiency;
grid on;
grid 'minor';
str0 = ['',VFAT3_NUMBER];
str1 = ['armdac:',num2str(arm_dac)];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=7;y0=.9;
x1=x0;y1=y0-.05;
x2=x0;y2=y1-.05;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);
%
%figure();
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
subplot(3,2,1);
z = temp'; % sample data, use your own variable
p = pcolor(x,y,z);
p.EdgeAlpha = 0;
cb = colorbar;
xlabel 'channel # ';
ylabel 'caldac(fC)';
title 'scurve plot vfat3 128 channels';
cb.Label.String = 'Ocuppancy(Hits)';
grid on;
grid 'minor';

str0 = ['',VFAT3_NUMBER];
str1 = ['armdac:',num2str(arm_dac)];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=5;y0=stop_fc -.5;
x1=x0;y1=y0-.5;
x2=x0;y2=y1-.5;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);

%% threshold plots

%figure;

subplot(3,2,3);
plot (mean_th,'r-x'); 

axis([1 stop_chan start_fc stop_fc]);
str = ['\mu: ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th * 6241.51)),'e)' ];
text(3,7,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
text(3,6,str);

str0 = ['',VFAT3_NUMBER];
str1 = ['armdac:',num2str(arm_dac)];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=80;y0=M_O_mean_Th + 3;
x1=x0;y1=y0-.6;
x2=x0;y2=y1-1;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);
%title('Mean Threshold (Before trimming)');
xlabel 'channel number';
ylabel 'Charge (fC)';
title 'Threshold Plot(All channels)'
grid on;
grid 'minor';


% threshold histograms

subplot(3,2,4);


%title('Threshold Histograms(Before trimming)');



histogram(mean_th,'facecolor',col(1)); 
axis([start_fc stop_fc 1 50]);
str = ['\mu: ', num2str(round(M_O_mean_Th,3)),'fC (',num2str(round(M_O_mean_Th * 6241.51)),'e)' ];
text(M_O_mean_Th+.7,40,str);
str = ['\sigma:',num2str(round(M_O_mean_Th_std,3)),'fC (',num2str(round(M_O_mean_Th_std* 6241.51)),'e)'];
text(M_O_mean_Th+.7,38,str);

str0 = ['',VFAT3_NUMBER];
str1 = ['armdac:',num2str(arm_dac)];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=M_O_mean_Th +4;y0=40;
x1=x0;y1=y0-4;
x2=x0;y2=y1-4;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);


xlabel 'charge (fC)';
ylabel 'Channel count';
title 'Threshold All channels histograms'
%plot ((1:size(S_mean_th,2)),S_mean_th(i,:)'); 

grid on;
grid 'minor';





%% enc plots
%figure;
st=1;stp=128;
subplot(3,2,5);
plot(mean_enc,'r-o');

axis([st stp 0 (M_O_mean_ENC +.45)]);
str = ['\mu: ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC * 6241.51)),'e)' ];
text(50,.05,str);
str = ['\sigma: ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
text(50,.03,str);

str0 = ['',VFAT3_NUMBER];
str1 = ['armdac:',num2str(arm_dac)];
str2 = ['',num2str(Pre_Gain),',',num2str(Peaking_time)];
x0=80;y0=.06;
x1=x0;y1=y0-.02;
x2=x0;y2=y1-.02;

text(x0,y0,str0);
text(x1,y1,str1);
text(x2,y2,str2);


xlabel 'channel number';
ylabel 'ENC (fC)';
title 'ENC plot '
grid on;
grid 'minor';


% enc histograms

subplot(3,2,6);
histogram(mean_enc,'facecolor',col(1));
axis([0 1 0 50]);


str = ['\mu: ', num2str(round(M_O_mean_ENC,3)),'fC (',num2str(round(M_O_mean_ENC * 6241.51)),'e)' ];
text(0,40,str);
str = ['\sigma: ',num2str(round(M_O_mean_ENC_std,3)),'fC (',num2str(round(M_O_mean_ENC_std* 6241.51)),'e)'];
text(0,35,str);


str0 = ['',VFAT3_NUMBER];
str1 = ['armdac:',num2str(arm_dac)];
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
grid on;
grid 'minor';


%%
% % fname = sprintf('test.txt');
% % save(fname, '-ascii')
% 
% figure;
% % Enlarge figure to full screen.
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);



%%
x = 0:.1:1;
A = [x; exp(x)];

folderName = horzcat('results/',VFAT3_NUMBER);
if ~exist(folderName, 'dir')
    mkdir(folderName);
end
%fileID = sprintf('try_%s.txt',VFAT3_NUMBER);
filename = horzcat('try_',VFAT3_NUMBER,'.txt');
fileID = fopen(filename,'w');
fprintf(fileID,'%6s %12s\n','x','exp(x)');
fprintf(fileID,'%6.2f %12.8f\n',A);
fclose(fileID);

%% date and time stamp for files

d= datestr(datetime('now','InputFormat','yyyy-MM-dd''T''HHmm'));
d= erase(d,':');
d= erase(d,'-');
d= erase(d,'#');
d= erase(d,' ');

%%
folderName = horzcat('results/',VFAT3_NUMBER,'/',d);% define a folder name for every chip programatically
% First, get the name of the folder you're using.
% For example if your folder is 'D:\photos\Info', parentFolder  would = 'D:\photos, and deepestFolder would = 'Info'.
[parentFolder deepestFolder] = fileparts(folderName);
% Next, create a name for a subfolder within that.
% For example 'D:\photos\Info\DATA-Info'
saveas(gcf, horzcat(folderName,d,'.png'));
% scurve folder and file creation
scurveSubFolder = sprintf('%s/scurve_%s_%s', folderName, deepestFolder,d);% define a scurve subfolder 
% Finally, create the folder if it doesn't exist already.
if ~exist(scurveSubFolder, 'dir')
  mkdir(scurveSubFolder);
end
filename = horzcat(scurveSubFolder,'/scurves_',VFAT3_NUMBER,d,'.txt');
fileID   = fopen(filename,'w');
% end scurve folder and file creation




fprintf(fileID,'%12.6f',fc_arr);
fprintf(fileID,'\n');
for i =1 : size(scurve,1)
data = scurve(i,:);
fprintf(fileID,'%12.6f',data);
fprintf(fileID,'\n');
end
fclose(fileID);