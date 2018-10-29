function varargout = GUI_vfat3_characterisation(varargin)
% GUI_VFAT3_CHARACTERISATION MATLAB code for GUI_vfat3_characterisation.fig
%      GUI_VFAT3_CHARACTERISATION, by itself, creates a new GUI_VFAT3_CHARACTERISATION or raises the existing
%      singleton*.
%
%      H = GUI_VFAT3_CHARACTERISATION returns the handle to a new GUI_VFAT3_CHARACTERISATION or the handle to
%      the existing singleton*.
%
%      GUI_VFAT3_CHARACTERISATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_VFAT3_CHARACTERISATION.M with the given input arguments.
%
%      GUI_VFAT3_CHARACTERISATION('Property','Value',...) creates a new GUI_VFAT3_CHARACTERISATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_vfat3_characterisation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_vfat3_characterisation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_vfat3_characterisation

% Last Modified by GUIDE v2.5 17-Oct-2018 11:35:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_vfat3_characterisation_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_vfat3_characterisation_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_vfat3_characterisation is made visible.
function GUI_vfat3_characterisation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_vfat3_characterisation (see VARARGIN)

% Choose default command line output for GUI_vfat3_characterisation
handles.output = hObject;

% Initialise tabs
handles.tabManager = TabManager( hObject );

% Set-up a selection changed function on the create tab groups
tabGroups = handles.tabManager.TabGroups;
for tgi=1:length(tabGroups)
    set(tabGroups(tgi),'SelectionChangedFcn',@tabChangedCB)
end
handles.PRE_I_BIT       = 6;
handles.PRE_I_BSF       = 30;
handles.PRE_I_BLCC      = 6;
handles.PRE_VREF        = 30;
handles.SH_I_BFCAS      = 10;
handles.SH_I_BDIFF      = 4;
handles.SLVS_IBIAS      = 40;
handles.SLVS_VREF       = 40;

set(handles.gain_panel,'SelectedObject',handles.Radio_HG)
set(handles.PT_popupmenu,'String',{'15ns'  '25ns' '35ns' '45ns'});
set(handles.PT_popupmenu,'Value',3);

set(handles.popupmenu_DACSCAN,'String',{'Iref' 'Calib IDC' 'PreAmp InpTrans' 'PreAmp LC' 'PreAmp' 'SF Shap FC'  ' Shap Inpair' 'SD Inpair' 'SD FC' 'SD SF' 'CFD Bias1' 'CFD Bias2' 'CFD Hyst' 'CFD Ireflocal' 'CFD ThArm' 'CFD ThZcc' 'SLVS Ibias' 'BGR' 'Calib Vstep'});
set(handles.popupmenu_DACSCAN,'Value',3);

%set(handles.PT_popupmenu,'Default','15ns');
%set(handles.PT_popupmenu,'String','25ns');

default(hObject, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_vfat3_characterisation wait for user response (see UIRESUME)
% uiwait(handles.mainFigure);


% Called when a user clicks on a tab
function tabChangedCB(src, eventdata)

disp(['Changing tab from ' eventdata.OldValue.Title ' to ' eventdata.NewValue.Title ] );




% --- Outputs from this function are returned to the command line.
function varargout = GUI_vfat3_characterisation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonSelectMain.
function buttonSelectMain_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSelectMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabMan = handles.tabManager;
tabMan.Handles.TabA.SelectedTab = tabMan.Handles.TabA01Main;
tabMan.Handles.TabB.SelectedTab = tabMan.Handles.TabB01Main;


% --- Executes on button press in buttonSelectSupplementary.
function buttonSelectSupplementary_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSelectSupplementary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tabMan = handles.tabManager;
tabMan.Handles.TabA.SelectedTab = tabMan.Handles.TabA02Supplementary;
tabMan.Handles.TabB.SelectedTab = tabMan.Handles.TabB02Nesting;






function editSup1_Callback(hObject, eventdata, handles)
% hObject    handle to editSup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSup1 as text
%        str2double(get(hObject,'String')) returns contents of editSup1 as a double


% --- Executes during object creation, after setting all properties.
function editSup1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSup2_Callback(hObject, eventdata, handles)
% hObject    handle to editSup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSup2 as text
%        str2double(get(hObject,'String')) returns contents of editSup2 as a double


% --- Executes during object creation, after setting all properties.
function editSup2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSup3_Callback(hObject, eventdata, handles)
% hObject    handle to editSup3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSup3 as text
%        str2double(get(hObject,'String')) returns contents of editSup3 as a double


% --- Executes during object creation, after setting all properties.
function editSup3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSup3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Hard_reset.
function Hard_reset_Callback(hObject, eventdata, handles)
% hObject    handle to Hard_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assert_reset();
reply=sync_chip_dpa()
handles.reply = reply(1);
if reply(1) == 58
set(handles.status_text, 'String', 'connected');
IREF = AdjustIref();
 handles.IREF = IREF;
 
 % internal adc calibration
 [fitresult_adc0,fitresult_adc1] = ADC_Calibrate(5,5,255);
 handles.adc0.p1= fitresult_adc0.p1;
 handles.adc0.p2= fitresult_adc0.p2;
 
 handles.adc1.p1= fitresult_adc1.p1;
 handles.adc1.p2= fitresult_adc1.p2;
 
 set(handles.adc0_p1_text, 'String', num2str(handles.adc0.p1));
 set(handles.adc0_p2_text, 'String', num2str(handles.adc0.p2));
 set(handles.adc1_p1_text, 'String', num2str(handles.adc1.p1));
 set(handles.adc1_p2_text, 'String', num2str(handles.adc1.p2));
 
 % Cal_dac to fC 
[fc_arr,dac_arr,Lfit_charge] = caldac_to_fC_GUI();
handles.fc_arr = fc_arr;
handles.dac_arr = dac_arr;
handles.CALDAC.p1= Lfit_charge.p1;
handles.CALDAC.p2= Lfit_charge.p2;
 set(handles.CALDAC_p1_text, 'String', num2str(handles.CALDAC.p1));
 set(handles.CALDAC_p2_text, 'String', num2str(handles.CALDAC.p2));

%Max_Caldac = floor(Lfit_charge(0));
 set(handles.iref_text, 'String', handles.IREF);
 chip_id = read_register(hex2dec('00010003'),0);
 handles.id = chip_id;
 set(handles.id_text, 'String',handles.id);
  
 
else
    set(handles.hard_reset, 'String', 'No reply');
end
guidata(hObject,handles)


% --- Executes on button press in checkbox_run.
function checkbox_run_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_run
     write_register_gui(hex2dec('ffff'),get(hObject,'Value'));
 






%set(handles.gain_text, 'String', num2str(handles.Gain));
% --- Executes on button press in Radio_LG.
function Radio_LG_Callback(hObject, eventdata, handles)
% hObject    handle to Radio_LG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio_LG
temp=get(handles.gain_panel,'SelectedObject');
handles.GainSelection = get(temp,'String');
guidata(hObject,handles)


% --- Executes on button press in Radio_MG.
function Radio_MG_Callback(hObject, eventdata, handles)
% hObject    handle to Radio_MG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio_MG
temp=get(handles.gain_panel,'SelectedObject');
handles.GainSelection = get(temp,'String');
guidata(hObject,handles)

% --- Executes on button press in Radio_HG.
function Radio_HG_Callback(hObject, eventdata, handles)
% hObject    handle to Radio_HG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio_HG
temp=get(handles.gain_panel,'SelectedObject');
handles.GainSelection = get(temp,'String');
guidata(hObject,handles)







% --- Executes on selection change in popupmenu_ShapingTime.
function popupmenu_ShapingTime_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ShapingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ShapingTime contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ShapingTime


% --- Executes during object creation, after setting all properties.
function popupmenu_ShapingTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ShapingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PT_popupmenu.
function PT_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PT_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PT_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PT_popupmenu
SelectedIndex = get(handles.PT_popupmenu,'Value')
temp=get(handles.gain_panel,'SelectedObject');
handles.GainSelection = get(temp,'String')
set(handles.text21,'String',horzcat(num2str(SelectedIndex),handles.GainSelection));
set_preamp_gui(SelectedIndex,handles.GainSelection)
% --- Executes during object creation, after setting all properties.
function PT_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PT_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get(handles.popupmenu1,'String')
popStrings = get(handles.PT_popupmenu,'String'); % All the strings in the menu.
SelectedIndex = get(handles.PT_popupmenu,'Value');
SelectedString = popStrings{SelectedIndex}
%get(handles.popupmenu, 'UserData');



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function gain_panel_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to gain_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function Radio_LG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Radio_LG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function Radio_MG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Radio_MG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Radio_HG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Radio_HG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function gain_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gain_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_PRE_I_BSF_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PRE_I_BSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PRE_I_BSF as text
%        str2double(get(hObject,'String')) returns contents of edit_PRE_I_BSF as a double

PRE_I_BSF= str2double(get(hObject, 'String'));

if isnan(PRE_I_BSF)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
elseif PRE_I_BSF>=0 && PRE_I_BSF<=63
    handles.PRE_I_BSF = PRE_I_BSF;
    address = uint32(hex2dec('8d'));
    data = bitor(uint16(bitshift(handles.PRE_I_BSF,8)),uint16(handles.PRE_I_BIT),'uint16');%   
    write_register_gui(address,data);
    set(handles.GBL_CFG_BIAS1_text,'String',num2str(dec2hex(data)));
    
else
    set(hObject, 'String', 0);
    errordlg('Valid range is from 0 to 63','Error');
end

% Save the new temperature value

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_PRE_I_BSF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PRE_I_BSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_PRE_I_BIT_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PRE_I_BIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PRE_I_BIT as text
%        str2double(get(hObject,'String')) returns contents of edit_PRE_I_BIT as a double
PRE_I_BIT= str2double(get(hObject, 'String'));
if isnan(PRE_I_BIT)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
elseif PRE_I_BIT>=0 && PRE_I_BIT<=255
    handles.PRE_I_BIT = PRE_I_BIT;
    address = uint32(hex2dec('8d'));
    data = bitor(uint16(bitshift(handles.PRE_I_BSF,8)),uint16(handles.PRE_I_BIT),'uint16');%   
    write_register_gui(address,data);
    set(handles.GBL_CFG_BIAS1_text,'String',num2str(dec2hex(data)));
    
    
else
    set(hObject, 'String', 0);
    errordlg('Valid range is from 0 to 255','Error');
end

% Save the new temperature value

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_PRE_I_BIT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PRE_I_BIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_PRE_I_BLCC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PRE_I_BLCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PRE_I_BLCC as text
%        str2double(get(hObject,'String')) returns contents of edit_PRE_I_BLCC as a double
PRE_I_BLCC= str2double(get(hObject, 'String'));

if isnan(PRE_I_BLCC)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
elseif PRE_I_BLCC>=0 && PRE_I_BLCC<=63
    handles.PRE_I_BLCC = PRE_I_BLCC;
    address = uint32(hex2dec('8E'));
    data = bitor(uint16(bitshift(handles.PRE_I_BLCC,8)),uint16(handles.PRE_VREF),'uint16');%   
    write_register_gui(address,data);
    set(handles.GBL_CFG_BIAS2_text,'String',num2str(dec2hex(data)));
    
else
    set(hObject, 'String', 0);
    errordlg('Valid range is from 0 to 63','Error');
end

% Save the new temperature value

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit_PRE_I_BLCC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PRE_I_BLCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_PRE_VREF_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PRE_VREF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PRE_VREF as text
%        str2double(get(hObject,'String')) returns contents of edit_PRE_VREF as a double
PRE_VREF= str2double(get(hObject, 'String'));

if isnan(PRE_VREF)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
elseif PRE_VREF>=0 && PRE_VREF<=255
    handles.PRE_VREF = PRE_VREF;
    address = uint32(hex2dec('8d'));
    data = bitor(uint16(bitshift(handles.PRE_I_BLCC,8)),uint16(handles.PRE_VREF),'uint16');%   
    write_register_gui(address,data);
    set(handles.GBL_CFG_BIAS2_text,'String',num2str(dec2hex(data)));
    
else
    set(hObject, 'String', 0);
    errordlg('Valid range is from 0 to 63','Error');
end

% Save the new temperature value

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit_PRE_VREF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PRE_VREF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_SH_I_BFCAS_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SH_I_BFCAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SH_I_BFCAS as text
%        str2double(get(hObject,'String')) returns contents of edit_SH_I_BFCAS as a double

SH_I_BFCAS= str2double(get(hObject, 'String'));

if isnan(SH_I_BFCAS)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
elseif SH_I_BFCAS>=0 && SH_I_BFCAS<=255
    handles.SH_I_BFCAS = SH_I_BFCAS;
    address = uint32(hex2dec('8F'));
    data = bitor(uint16(bitshift(handles.SH_I_BFCAS,8)),uint16(handles.SH_I_BDIFF),'uint16');%   
    write_register_gui(address,data);
    set(handles.GBL_CFG_BIAS3_text,'String',num2str(dec2hex(data)));
    
else
    set(hObject, 'String', 0);
    errordlg('Valid range is from 0 to 255','Error');
end

% Save the new temperature value

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_SH_I_BFCAS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SH_I_BFCAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_SH_I_BDIFF_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SH_I_BDIFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SH_I_BDIFF as text
%        str2double(get(hObject,'String')) returns contents of edit_SH_I_BDIFF as a double
SH_I_BDIFF= str2double(get(hObject, 'String'));

if isnan(SH_I_BDIFF)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
elseif SH_I_BDIFF>=0 && SH_I_BDIFF<=255
    handles.SH_I_BDIFF = SH_I_BDIFF;
    address = uint32(hex2dec('8F'));
    data = bitor(uint16(bitshift(handles.SH_I_BFCAS,8)),uint16(handles.SH_I_BDIFF),'uint16');%   
    write_register_gui(address,data);
    set(handles.GBL_CFG_BIAS3_text,'String',num2str(dec2hex(data)));
    
else
    set(hObject, 'String', 0);
    errordlg('Valid range is from 0 to 255','Error');
end

% Save the new temperature value

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit_SH_I_BDIFF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SH_I_BDIFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_SH_I_BFAMP_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SH_I_BFAMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SH_I_BFAMP as text
%        str2double(get(hObject,'String')) returns contents of edit_SH_I_BFAMP as a double
SH_I_BFAMP= str2double(get(hObject, 'String'));

if isnan(SH_I_BFAMP)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
elseif SH_I_BFAMP>=0 && SH_I_BFAMP<=63
    handles.SH_I_BFAMP = SH_I_BFAMP;
    address = uint32(hex2dec('90'));
    data = bitor(uint16(bitshift(handles.SH_I_BFAMP,8)),uint16(handles.SD_I_BDIFF),'uint16');%   
    write_register_gui(address,data);
    set(handles.GBL_CFG_BIAS4_text,'String',num2str(dec2hex(data)));
    
else
    set(hObject, 'String', 0);
    errordlg('Valid range is from 0 to 63','Error');
end

% Save the new temperature value

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_SH_I_BFAMP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SH_I_BFAMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adc0_p1_text_Callback(hObject, eventdata, handles)
% hObject    handle to adc0_p1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adc0_p1_text as text
%        str2double(get(hObject,'String')) returns contents of adc0_p1_text as a double


% --- Executes during object creation, after setting all properties.
function adc0_p1_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adc0_p1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adc0_p2_text_Callback(hObject, eventdata, handles)
% hObject    handle to adc0_p2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adc0_p2_text as text
%        str2double(get(hObject,'String')) returns contents of adc0_p2_text as a double


% --- Executes during object creation, after setting all properties.
function adc0_p2_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adc0_p2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adc1_p1_text_Callback(hObject, eventdata, handles)
% hObject    handle to adc1_p1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adc1_p1_text as text
%        str2double(get(hObject,'String')) returns contents of adc1_p1_text as a double


% --- Executes during object creation, after setting all properties.
function adc1_p1_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adc1_p1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adc1_p2_text_Callback(hObject, eventdata, handles)
% hObject    handle to adc1_p2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adc1_p2_text as text
%        str2double(get(hObject,'String')) returns contents of adc1_p2_text as a double


% --- Executes during object creation, after setting all properties.
function adc1_p2_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adc1_p2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_SLVS_VREF_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SLVS_VREF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SLVS_VREF as text
%        str2double(get(hObject,'String')) returns contents of edit_SLVS_VREF as a double

SLVS_VREF = str2double(get(hObject, 'String'));

if isnan(SLVS_VREF)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
elseif SLVS_VREF>=0 && SLVS_VREF<=63
    handles.SLVS_VREF = SLVS_VREF;
    address = uint32(hex2dec('92'));
    data = bitor(uint16(bitshift(handles.SLVS_IBIAS,6)),uint16(handles.SLVS_VREF),'uint16');%   
    write_register_gui(address,data);
    set(handles.GBL_CFG_BIAS6_text,'String',num2str(dec2hex(data)));
    
else
    set(hObject, 'String', 0);
    errordlg('Valid range is from 0 to 63','Error');
end

% Save the new temperature value

guidata(hObject,handles)
% --- Executes during object creation, after setting all properties.
function edit_SLVS_VREF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SLVS_VREF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_SLVS_IBIAS_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SLVS_IBIAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SLVS_IBIAS as text
%        str2double(get(hObject,'String')) returns contents of edit_SLVS_IBIAS as a double
SLVS_IBIAS = str2double(get(hObject, 'String'));

if isnan(SLVS_IBIAS)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
elseif SLVS_IBIAS>=0 && SLVS_IBIAS<=63
    handles.SLVS_IBIAS = SLVS_IBIAS;
    address = uint32(hex2dec('92'));
    data = bitor(uint16(bitshift(handles.SLVS_IBIAS,6)),uint16(handles.SLVS_VREF),'uint16');%   
    write_register_gui(address,data);
    set(handles.GBL_CFG_BIAS6_text,'String',num2str(dec2hex(data)));
    
else
    set(hObject, 'String', 0);
    errordlg('Valid range is from 0 to 63','Error');
end

% Save the new temperature value

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_SLVS_IBIAS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SLVS_IBIAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function default(hObject, handles)
    
    set(handles.edit_PRE_I_BIT, 'string', num2str(handles.PRE_I_BIT));% default setting for channel field
    set(handles.edit_PRE_I_BSF, 'string', num2str(handles.PRE_I_BSF));% default setting for channel field
    set(handles.edit_PRE_I_BLCC, 'string', num2str(handles.PRE_I_BLCC));% default setting for channel field
    set(handles.edit_PRE_VREF, 'string', num2str(handles.PRE_VREF));% default setting for channel field
    set(handles.edit_SH_I_BFCAS, 'string', num2str(handles.SH_I_BFCAS));% default setting for channel field
    set(handles.edit_SH_I_BDIFF, 'string', num2str(handles.SH_I_BDIFF));% default setting for channel field
    set(handles.edit_SLVS_IBIAS, 'string', num2str(handles.SLVS_IBIAS));% default setting for channel field
    set(handles.edit_SLVS_VREF, 'string', num2str(handles.SLVS_VREF));% default setting for channel field
    
    guidata(hObject, handles)






function CALDAC_p1_text_Callback(hObject, eventdata, handles)
% hObject    handle to CALDAC_p1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CALDAC_p1_text as text
%        str2double(get(hObject,'String')) returns contents of CALDAC_p1_text as a double


% --- Executes during object creation, after setting all properties.
function CALDAC_p1_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CALDAC_p1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CALDAC_p2_text_Callback(hObject, eventdata, handles)
% hObject    handle to CALDAC_p2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CALDAC_p2_text as text
%        str2double(get(hObject,'String')) returns contents of CALDAC_p2_text as a double


% --- Executes during object creation, after setting all properties.
function CALDAC_p2_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CALDAC_p2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_DACSCAN.
function popupmenu_DACSCAN_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_DACSCAN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_DACSCAN contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_DACSCAN
SelectedIndex = get(handles.popupmenu_DACSCAN,'Value')
temp=get(popupmenu_DACSCAN,'SelectedObject');
handles.DACSelection = get(temp,'String')
set(handles.text21,'String',horzcat(num2str(SelectedIndex),handles.GainSelection));
%set_preamp_gui(SelectedIndex,handles.GainSelection)

% --- Executes during object creation, after setting all properties.
function popupmenu_DACSCAN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_DACSCAN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
