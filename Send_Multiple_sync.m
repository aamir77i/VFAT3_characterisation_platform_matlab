function [received_words] = Send_Multiple_sync(num_of_sync)

 %%
    num_of_sync =10;
WORD_SIZE = 4;       
sync_command = uint8(ones(3* num_of_sync,1)* hex2dec('17'))';
input_data_len = num_of_sync * WORD_SIZE;% IN BYTES
[received_words] = TX_FCC(sync_command,input_data_len)
T= table;
T.sync    = bitand(received_words(:),hex2dec('000000ff'));
BC        = bitshift(received_words(:),-8);%shiftright 8 steps
T.BC      = dec2hex(BC);
%T.BC_diff= (bitshift(received_words(2:end),-8) - bitshift(received_words(1:end-1),-8))'
BC_diff   = diff(BC); 
T.BC_diff =  [BC_diff ;  0];
T
end
