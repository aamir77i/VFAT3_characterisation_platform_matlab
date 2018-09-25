%%
clearvars
%%
load 'ESD6_D1.mat'
%%
x= Voltage;
y1= I_PRE;
y2= I_500K;
y3 = I_55MRAD;
y4 = I_10MRAD;
figure();
subplot(4,1,1);
plot(x,y1,x,y2,x,y3,x,y4);
axis([-10,10,-.012,.012]);
grid on
legend('pre','0.6MRAD','5.9MRAD','10MRAD');
title('ESD6-D1-IV (full Curve)(Beam Analysis)')
xlabel('voltage(v)');
ylabel('current(A)');
%%

subplot(4,1,2);
plot(x,y1,x,y2,x,y3,x,y4);
axis([7,10,-.012,.012]);
grid on
legend('pre','0.6MRAD','5.9MRAD','10MRAD');
title('ESD6-D1-IV (right most part)(Beam Analysis)')
xlabel('voltage(v)');
ylabel('current(A)');
%%

subplot(4,1,3);
plot(x,y1,x,y2,x,y3,x,y4);
axis([-9,9,-.0000001,.0000001]);
grid on
legend('pre','0.6MRAD','5.9MRAD','10MRAD');
title('ESD6-D1-IV (centre part)(Beam Analysis)')
xlabel('voltage(v)');
ylabel('current(A)');
%%

subplot(4,1,4);
plot(x,y1,x,y2,x,y3,x,y4);
axis([-9,9,-.00000001,.00000001]);
grid on
legend('pre','0.6MRAD','5.9MRAD','10MRAD');
title('ESD6-D1-IV (centre part zoomed)')
xlabel('voltage(v)');
ylabel('current(A)');

%%
avalanche_Index = zeros(1,3);
%avalanche_voltage = zeros(1,6);
Criteria= 1e-6;
y1_1= y1> Criteria;
y2_1= y2> Criteria;
y3_1= y3> Criteria;
y4_1= y4> Criteria;

avalanche_Index(1)= find(y1_1,1); % find index at which diode starts avalanche @ I_pre
avalanche_Index(2)= find(y2_1,1); % find index at which diode starts avalanche @ I_500kRAD
avalanche_Index(3)= find(y3_1,1); % find index at which diode starts avalanche @ I_5.5MRAD
avalanche_Index(4)= find(y4_1,1); % find index at which diode starts avalanche @ I_10MRAD



avalanche_voltage = x(avalanche_Index);
figure();
plot(avalanche_voltage,'-*');
title('Breakdown voltage vs. Radiation plot(ESD6-D1)');
xlabel('Proton Beam Radiation ');
ylabel('Breakdown voltage(volts)');
xticks([1 2 3]);
xticklabels({'PRE','600KRad','5.9MRAD','10MRAD'});
text(1.5,8,'ESD6-D1');
text(1.5,7.97,'Breakdown Current >= 1 uA');
grid on;




