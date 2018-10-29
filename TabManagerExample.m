function varargout = TabManagerExample(varargin)
% TABMANAGEREXAMPLE MATLAB code for TabManagerExample.fig
%      TABMANAGEREXAMPLE, by itself, creates a new TABMANAGEREXAMPLE or raises the existing
%      singleton*.
%
%      H = TABMANAGEREXAMPLE returns the handle to a new TABMANAGEREXAMPLE or the handle to
%      the existing singleton*.
%
%      TABMANAGEREXAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABMANAGEREXAMPLE.M with the given input arguments.
%
%      TABMANAGEREXAMPLE('Property','Value',...) creates a new TABMANAGEREXAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TabManagerExample_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TabManagerExample_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TabManagerExample

% Last Modified by GUIDE v2.5 14-Oct-2018 10:19:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TabManagerExample_OpeningFcn, ...
                   'gui_OutputFcn',  @TabManagerExample_OutputFcn, ...
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


% --- Executes just before TabManagerExample is made visible.
function TabManagerExample_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TabManagerExample (see VARARGIN)

% Choose default command line output for TabManagerExample
handles.output = hObject;

% Initialise tabs
handles.tabManager = TabManager( hObject );

% Set-up a selection changed function on the create tab groups
tabGroups = handles.tabManager.TabGroups;
for tgi=1:length(tabGroups)
    set(tabGroups(tgi),'SelectionChangedFcn',@tabChangedCB)
end
set(handles.gain_panel,'SelectedObject',handles.Radio_HG)
set(handles.PT_popupmenu,'String',{'15ns'  '25ns' '35ns' '45ns'});
set(handles.PT_popupmenu,'Value',3);
%set(handles.PT_popupmenu,'Default','15ns');
%set(handles.PT_popupmenu,'String','25ns');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TabManagerExample wait for user response (see UIRESUME)
% uiwait(handles.mainFigure);


% Called when a user clicks on a tab
function tabChangedCB(src, eventdata)

disp(['Changing tab from ' eventdata.OldValue.Title ' to ' eventdata.NewValue.Title ] );




% --- Outputs from this function are returned to the command line.
function varargout = TabManagerExample_OutputFcn(hObject, eventdata, handles) 
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
reply=sync_chip_dpa()
handles.reply = reply(1);
if reply(1) == 58
set(handles.status_text, 'String', 'connected');
IREF = AdjustIref();
 handles.IREF = IREF;
 
 % Cal_dac to fC 
[fc_arr,dac_arr] = caldac_to_fC_GUI();
handles.fc_arr = fc_arr;
handles.dac_arr = dac_arr;
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
SelectedIndex = get(handles.PT_popupmenu,'Value');
temp=get(handles.gain_panel,'SelectedObject');
handles.GainSelection = get(temp,'String');
set(handles.text21,'String',horzcat(num2str(SelectedIndex),handles.GainSelection));

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
selectedIndex = get(handles.PT_popupmenu,'Value');
selectedString = popStrings{selectedIndex}
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
