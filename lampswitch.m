%%
function lampswitch
fig = uifigure('Position',[100 100 350 275]);

% Create lamp
lmp = uilamp(fig,...
    'Position',[165 75 20 20],...
    'Color','red');

% Create switch
uiswitch(fig,'toggle',...
    'Items',{'Go','Stop'},...    
    'Position',[165 160 20 45],...
    'ValueChangedFcn',@switchMoved); 

% ValueChangedFcn callback
function switchMoved(src,event)  
    switch src.Value
        case 'Go'
            lmp.Color = 'green';
            find_dead_channels();
            
        case 'Stop'
            lmp.Color = 'red';
   end
end
end