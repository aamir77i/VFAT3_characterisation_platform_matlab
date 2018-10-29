x = 0:0.1:10;
y = (1/2)*(1+erf((x-5)/(sqrt(2)*0.5)));
figure;
plot(x,y)
grid on
title('CDF of normal distribution with \mu = 0 and \sigma = 1')
xlabel('x')
ylabel('CDF')