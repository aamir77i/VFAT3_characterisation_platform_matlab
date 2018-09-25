%%
clearvars
%%
load 'ESD6_D1.mat'
%%
x = Voltage;
y1= I_PRE;
y2= I_500K;
y3 = I_55MRAD;


XX1 = x(1: find(x ==0) -1);
XX2 = x(find(x ==0): length(x));

YY1= abs(y1(1: find(x ==0) -1)');
YY2= abs(y1(find(x ==0): length(y1)))' ;

y1 = horzcat(YY1,YY2);
figure();
%subplot(4,1,1);
semilogy(XX2,YY2);
axis([0,10,-.012,.012]);
grid on
legend('pre','0.6MRAD','5.9MRAD');
title('ESD6-D1-IV (full Curve)(Beam Analysis)')
xlabel('voltage(v)');
ylabel('current(A)');
%%

subplot(4,1,2);
plot(x,y1,x,y2,x,y3);
axis([7,10,-.012,.012]);
grid on
legend('pre','0.6MRAD','5.9MRAD');
title('ESD6-D1-IV (right most part)(Beam Analysis)')
xlabel('voltage(v)');
ylabel('current(A)');
%%

subplot(4,1,3);
plot(x,y1,x,y2,x,y3);
axis([-9,9,-.0000001,.0000001]);
grid on
legend('pre','0.6MRAD','5.9MRAD');
title('ESD6-D1-IV (centre part)(Beam Analysis)')
xlabel('voltage(v)');
ylabel('current(A)');
%%

subplot(4,1,4);
plot(x,y1,x,y2,x,y3);
axis([-9,9,-.00000001,.00000001]);
grid on
legend('pre','0.6MRAD','5.9MRAD');
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

avalanche_Index(1)= find(y1_1,1); % find index at which diode starts avalanche @ I_pre
avalanche_Index(2)= find(y2_1,1); % find index at which diode starts avalanche @ I_500kRAD
avalanche_Index(3)= find(y3_1,1); % find index at which diode starts avalanche @ I_5.5MRAD



avalanche_voltage = x(avalanche_Index);
figure();
plot(avalanche_voltage,'-*');
title('Breakdown voltage vs. Radiation plot(ESD6-D1)');
xlabel('Proton Beam Radiation ');
ylabel('Breakdown voltage(volts)');
xticks([1 2 3]);
xticklabels({'PRE','600KRad','5.9MRAD'});
text(1.5,8,'ESD6-D1');
text(1.5,7.97,'Breakdown Current >= 1 uA');
grid on;




