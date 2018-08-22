%%
clearvars
load 'ESD3_D1.mat'
%%
x= Voltage;
y1= I_PRE;
y2= I_200KRAD;
y3= I_400KRAD;
y4= I_1MRAD;
y5= I_2MRAD;
figure();
subplot(4,1,1);
plot(x,y1,x,y2,x,y3,x,y4,x,y5);
axis([-10,10,-.012,.012]);
grid on
legend('pre','200K','400K','1M','2M');
title('ESD3-D1-IV (full Curve)')
xlabel('voltage(v)');
ylabel('current(A)');
%%

subplot(4,1,2);
plot(x,y1,x,y2,x,y3,x,y4,x,y5);
axis([7,8.5,-.012,.012]);
grid on
legend('pre','200K','400K','1M','2M');
title('ESD3-D1-IV (right most part)')
xlabel('voltage(v)');
ylabel('current(A)');
%%

subplot(4,1,3);
plot(x,y1,x,y2,x,y3,x,y4,x,y5);
axis([-8,8,-.0000000005,.0000000005]);
grid on
legend('pre','200K','400K','1M','2M');
title('ESD3-D1-IV (centre part)')
xlabel('voltage(v)');
ylabel('current(A)');
%%

subplot(4,1,4);
plot(x,y1,x,y2,x,y3,x,y4,x,y5);
axis([-8,8,-.00000000010,.0000000002]);
grid on
legend('pre','200K','400K','1M','2M');
title('ESD3-D1-IV (centre part zoomed)')
xlabel('voltage(v)');
ylabel('current(A)');
%%
avalanche_Index = zeros(1,5);
%avalanche_voltage = zeros(1,6);
Criteria= 1e-6;
y1_1= y1> Criteria;
y2_1= y2> Criteria;
y3_1= y3> Criteria;
y4_1= y4> Criteria;
y5_1= y5> Criteria;


avalanche_Index(1)= find(y1_1,1); % find index at which diode starts avalanche @ I_pre
avalanche_Index(2)= find(y2_1,1); % find index at which diode starts avalanche @ I_200k
avalanche_Index(3)= find(y3_1,1); % find index at which diode starts avalanche @ I_400k
avalanche_Index(4)= find(y4_1,1); % find index at which diode starts avalanche @ I_1M
avalanche_Index(5)= find(y5_1,1); % find index at which diode starts avalanche @ I_2M



avalanche_voltage = x(avalanche_Index);
figure();
plot(avalanche_voltage,'-*');
title('Avalache voltage vs. Radiation plot');
xlabel('Radiation ');
ylabel('Avalanche voltage(volts)');
xticks([1 2 3 4 5 ]);
xticklabels({'PRE','200KRad','400KRad','1MRad','2MRad'});
text(1.2,8.3,'ESD3-D1');
text(1.2,8.25,'Avalanche current >= 1 uA');
grid on;

