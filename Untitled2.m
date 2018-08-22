%%
 load 'input_data.mat'
%%

for i=1 : size(mb_subsystem_iHDLC_WRAP_data_out70,1)
    if mb_subsystem_iHDLC_WRAP_data_out70(i) == 96
        data_bin(i) = 0;
    elseif mb_subsystem_iHDLC_WRAP_data_out70(i) == 99
            data_bin(i) = 1;
    end
end 
%%
clear fcs
i=1;
j=1;
 while true
     fcs(i) =  data_bin(j);
     fcs(i+1)=  data_bin(j+1);
     fcs(i+2)=  data_bin(j+2);
     fcs(i+3)=  data_bin(j+3);
     fcs(i+4)=  data_bin(j+4);
     fcs(i+5)=  data_bin(j+5);
     fcs(i+6)=  data_bin(j+6);
     fcs(i+7)=  data_bin(j+7);
     
     j=j+1;
     if fcs(i+7)==0 && fcs(i+6)==1 && fcs(i+5)==1 && fcs(i+4) == 1 && fcs(i+3) ==1 && fcs(i+2) == 1 && fcs(i+1) == 1 && fcs(i)==0
     break;
     end
 end

 

%%
FCS = binaryVectorToHex(data_bin(1:8));


%% remove headers footers 
A= char(data_bin);
B=char ([0 1 1 1 1 1 1 0]);
[startIndex,endIndex] = regexp(A,B)
data_2 = data_bin(endIndex(1)+1 : startIndex(2)-1)


%% extra zero removal 
A= char(data_2);
B=char ([1 1 1 1 1]);
[startIndex,endIndex] = regexp(A,B);


data_2(endIndex+1)=[];



%%

HDLC_ADDRESS = binaryVectorToHex(data_2(1:8),'LSBFirst')
HDLC_CONTROL = binaryVectorToHex(data_2(9:16),'LSBFirst')

H1 = binaryVectorToHex(data_2(17:24),'LSBFirst')
H2 = binaryVectorToHex(data_2(25:32),'LSBFirst')
H3 = binaryVectorToHex(data_2(33:40),'LSBFirst')
H4 = binaryVectorToHex(data_2(41:48),'LSBFirst')



A1 = binaryVectorToHex(data_2(49:56),'LSBFirst')
A2 = binaryVectorToHex(data_2(57:64),'LSBFirst')
A3 = binaryVectorToHex(data_2(65:72),'LSBFirst')
A4 = binaryVectorToHex(data_2(73:80),'LSBFirst')


D1 = binaryVectorToHex(data_2(81:88),'LSBFirst')
D2 = binaryVectorToHex(data_2(89:96),'LSBFirst')
D3 = binaryVectorToHex(data_2(97:104),'LSBFirst')
D4 = binaryVectorToHex(data_2(105:112),'LSBFirst')


C1 = binaryVectorToHex(data_2(113:120),'LSBFirst')
C2 = binaryVectorToHex(data_2(121:128),'LSBFirst')


