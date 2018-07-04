clear all
t = tcpclient('192.168.1.10', 7);
data = uint8([202, 0, 2]');
write(t, data);
pause(1);
num = read(t);
disp(dec2hex(num));
