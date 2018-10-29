function  set_preamp_simple(Peaking_time,Pre_Gain,sc_hw)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% preamp values 
%Peaking_time = "100nsec"; 
%Pre_Gain =  "High"  ;%"Medium" , " High"  



switch Peaking_time
    case 1%15
        TP_FE = 0;
        
    case 2%25
        TP_FE = 1;
        
    case 3%35
        TP_FE = 3;
        
    case 4%45
        TP_FE = 7;
    otherwise
        TP_FE = 0;
        
end    
switch Pre_Gain
    case 1
        RES_PRE =4;
        CAP_PRE = 3;
        
    case 2
        RES_PRE = 2;
        CAP_PRE = 1;
        
    case 3
        RES_PRE = 1;
        CAP_PRE = 0;
        
    otherwise
        RES_PRE = 1;
        CAP_PRE = 0;
        
end        
        

        register_data = bitor( bitor(uint16(CAP_PRE),uint16(bitshift(RES_PRE,2)),'uint16'), uint16(bitshift(TP_FE,5)),'uint16');%   bitand( bitshift(instructionWord, -21), hex2dec('1F'))   )
        fprintf("%08s",dec2bin(register_data));
        write_register(uint32(hex2dec('83')), uint32(register_data));
end

