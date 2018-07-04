clearvars ;
load_mA = [ 4 8 9 10 11 12 16 33 110 118 152 224 ]';
IV_AVDD    = [ 31 55 60 61 65 69 88 164 493 524 667 983 ]' ;
plot(IV_AVDD,load_mA);
xlabel('mV');
ylabel('load mA');
hold on;


IV_DVDD    = [ 36 53 58 59 64 68 87 164 498 529 675 996 ]' ;
plot(IV_DVDD,load_mA);
load_mA_vddio = [9 17 19 20 22 24 33 69 227 243 311 ]';
IV_VDDIO    = [55 88 99 100 109 117 155 308 959 1032 1295 ]' ;
plot(IV_VDDIO,load_mA_vddio);


fit=zeros(3,2);

fit(1,:)=polyfit(IV_AVDD,load_mA,1);
fit(2,:)=polyfit(IV_DVDD,load_mA,1);
fit(3,:)=polyfit(IV_VDDIO,load_mA_vddio,1);

mean_M=mean(fit(:,:))