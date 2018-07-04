clearvars;
five_ones = de2bi(uint8(hex2dec('1f')),5);
HDLC_FS = de2bi(uint8(hex2dec('7e')),8)
HDLC_ADDRESS = de2bi(uint8(hex2dec('00')),8)
JOINED = horzcat(HDLC_FS,HDLC_ADDRESS)
ANS = ismember(five_ones,HDLC_FS)
STR= strfind(JOINED,five_ones)

for i=1 : size(JOINED,2)
    if(JOINED(i)== 0) JOINED_res(i) = hex2dec('96');
    else 
        JOINED_res(i) = hex2dec('99');
    end
end
%%
HDLC_ADDRESS = uint8()
input_buffer = [202 0 0  0 14 uint8(hex2dec('17')) uint8(hex2dec('17')) uint8(hex2dec('17')) 0 255 0 255 0 255 0 255  uint8(hex2dec('17')) uint8(hex2dec('17')) uint8(hex2dec('17')) ]';
sc_data = []
output_buffer = direct_comm(input_buffer);

%%
Vector=1:5;  
Idx=[2 4];
%%
c=false(1,length(Vector)+length(Idx));
%%
c(Idx)=true;
result=nan(size(c));
result(~c)=Vector;
result(c)=42

%%
a= [0 1 1 1 1 0 1 1 1 1 1 1 1 1];
b = a;
count = 1;
while true
  index = strfind(b(count:end), [1 1 1 1 1])+5;
  if isempty(index)
      break
  end
  index = index(1);
  count = count+index-1;
  b = [b(1:count-1) 0 b(count:end)];
end
b


%%
a = [1 0 0 1 1 1 1 1 1 1 1 1];
b = a;
idx = strfind(a, [1,1,1,1,1])
if ~isempty(idx)
  % Remove indices with a too short distance:
  p = idx(1);
  for k = 2:numel(idx)
    if idx(k) - p < 5
       idx(k) = 0;
    else
       p = idx(k);
    end
  end
  idx = idx(idx ~= 0) + 4;
  %
  b         = cat(1, b, nan(size(b)));  % Pad with NaNs
  b(2, idx) = 0;                        % Insert zeros
  b         = b(~isnan(b)).';           % Crop remaining NaNs
end
b

%%
a = [1 1 1 1 0 1 0];
b = regexprep(char(a+'0'),'11111','111110')-'0'