%% 
clearvars;
%%
load 'preamp.mat';

figure();
subplot(3,1,1);
t2 = time* 1e9;
plot(t2,ns*1e3,t2,ns1*1e3,t2,ns2*1e3,t2,ns3*1e3);
axis([0 ,200,600,800]);
grid on
legend('15ns','25ns','35ns','45ns');
title('Preamp waveforms')
xlabel('Time(ns)');
ylabel('Amplitude(mv)');
%xticks([1 2 3 4 5 6 7 8 9 10]);
%xticklabels({'PRE','600KRad','5.9MRAD','5.9MRAD','5.9MRAD','5.9MRAD','5.9MRAD','5.9MRAD','5.9MRAD','5.9MRAD'});

%%
clearvars;
load 'shaper.mat'
subplot(3,1,2);
t2 = time* 1e9;
plot(t2,pt15*1e3,t2,pt25*1e3,t2,pt35*1e3,t2,pt45*1e3);
axis([0 ,500,600,1200]);
grid on
legend('15ns','25ns','35ns','45ns');
title('Shaper waveforms')
xlabel('Time(ns)');
ylabel('Amplitude(mv)');
%%
clearvars;
load 'sd.mat'
subplot(3,1,3);
t2 = TIME* 1e9;
plot(t2,pt25ns*1e3,t2,pt50ns*1e3,t2,pt75ns*1e3,t2,pt100ns*1e3);
axis([0 ,500,100,700]);
grid on
legend('15ns','25ns','35ns','45ns');
title('SD waveforms')
xlabel('Time(ns)');
ylabel('Amplitude(mv)');