%% TrimDac analysis @ different gains combined 
% stable version 
% 
% 

% last updated on 10 June 2018 
%%
clearvars;
%%
leg     = 'Threshold(fC) vs. TrimDac';
x_label = 'TrimDac';
y_label = 'Threshold(fC)';
VFAT3_NUMBER = 'vfat3#22';
start_chan = 20 ;stop_chan = 20 ;step_chan = 1 ;
Latency = uint16(0);
LV1As   = uint16(1000);
D1 = uint16(5) ;D2 = uint16(400) ;DELAY = uint8(1);
calpulse = uint8(1);
 
%start_fc = -2.0 ;
%stop_fc = 20.0 ;

num_of_channels = ( (stop_chan - start_chan)/step_chan)+1;

%% connect  hard reset chip
sync_chip();
%% Adjust IREF 
AdjustIref();

%% Cal_dac to fC
%start_fc = 0.0 ;
%stop_fc = 10.0 ;
[Lfit_caldac,Lfit_charge,step_fc]= caldac_to_fC(VFAT3_NUMBER);
% fc_arr = double(start_fc:step_fc:stop_fc);
% fc_size = size(fc_arr,2); 
% dac = uint8(round(Lfit_caldac(fc_arr)))

%% front end default configurations
Peaking_Time = "45"; 
Pre_Gain =  "MG"  ;%"Medium" , " High" 
set_preamp(Peaking_Time,Pre_Gain);
front_end_default  = [202 255 9 ]';
t = tcpip('192.168.1.10',7);
fopen(t);
fwrite(t,front_end_default);
A = uint8(fread(t,4));
fclose(t);

%% ensure all trim dacs are at zero

    write_register(uint8(start_chan),0);



 
%% front end settings
%% LG trim fit  




start_fc = 0.0 ;
stop_fc = 50.0 ;
fc_arr = double(start_fc:step_fc:stop_fc);
fc_size = size(fc_arr,2); 
dac = uint8(round(Lfit_caldac(fc_arr)))
arm_dac = uint8(100);
load 'arm_dac_fc_all_gains_vfat22.mat';

j=1;loop = 1;
figure();
x0=-70;  y0=34;
%%
col={'kd' , 'b*' , 'k.'};
%%
while loop <= 3
    if loop == 1 
        Arm_dac_fc = round(Arming_fit_LG(double(arm_dac)),2);
        Pre_Gain =  "LG"  ;%"Medium" , " High" 
        
    elseif loop ==2 
         Arm_dac_fc = round(Arming_fit_MG(double(arm_dac)),2);
        Pre_Gain =  "MG"  ;%"Medium" , " High" 
        
    else
         Arm_dac_fc = round(Arming_fit_HG(double(arm_dac)),2);
        Pre_Gain =  "HG"  ;%"Medium" , " High" 
        
    end
    set_preamp(Peaking_Time,Pre_Gain);
ADDRESS = uint16(start_chan);
i=1;
Trim_dac = -63;
fprintf('\narm_dac : %d\n',arm_dac);
while Trim_dac <= 63 % individual channel loop inner
    write_register(ADDRESS,sign_bit_conversion(Trim_dac));
    Trim_dac_arr(i)= Trim_dac;
% send this value to vfat3

    while true 
       %%
        [scurve,mean_th,mean_enc,M_O_mean_Th,M_O_mean_Th_std,M_O_mean_ENC,M_O_mean_ENC_std] = scurve_all_channel(start_chan,stop_chan,step_chan,Latency,LV1As,arm_dac,D1,D2,DELAY,start_fc,stop_fc,fc_arr,dac,calpulse);
        %%
        Threshold(i)= M_O_mean_Th;
        if (Threshold(i)~=0.0)
            break; 
        end
    end
    fprintf('Threshold(%d) = %f  Trim_dac(%d) = %f \n', i, Threshold(i),i,Trim_dac_arr(i));
    Trim_dac = Trim_dac + 2;
    i = i+1;
    
end

[Tfit,gof]=Trim_fit(Trim_dac_arr,Threshold);  
%%

hold on;

h = plot( Tfit, 'r',Trim_dac_arr, Threshold,char(col(loop)));



str1 = ['',num2str(Pre_Gain),',',num2str(Peaking_Time)];
str2 = [ '(p1:',num2str(round(Tfit.p1,2)),',','p2:',num2str(round(Tfit.p2,2)),')'];
str3 = [ '(Armdac:',num2str(arm_dac),'(',num2str(Arm_dac_fc),'fC)'];


if loop == 1
    x1 = x0 ; y1 = 30;
    x2 = x0;  y2 = y1 - 1;
    x3 = x0;  y3 = y2 - 1;
elseif loop == 2
    x1 = x0 ; y1 = 20;
    x2 = x0;  y2 = y1 - 1;
    x3 = x0;  y3 = y2-  1;
else
    x1 = x0 ; y1 = 8;
    x2 = x0;  y2 = y1 - 1;
    x3 = x0;  y3 = y2 - 1;
end

text(x1,y1,str1);
text(x2,y2,str2);
text(x3,y3,str3);
loop = loop+1;

end
%%
legend({'dataPointsLG', 'Fit','dataPointsMG', 'Fit','dataPointsHG', 'Fit'}, 'Location', 'SouthEast' );
title ('TrimDac Plot')
xlabel (x_label) 
ylabel (y_label) 
grid on



str0 = ['',VFAT3_NUMBER];
text(x0,y0,str0);
hold off;
%%





