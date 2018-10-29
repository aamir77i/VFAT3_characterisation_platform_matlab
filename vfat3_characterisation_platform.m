function varargout = vfat3_characterisation_platform(varargin)
% VFAT3_CHARACTERISATION_PLATFORM MATLAB code for vfat3_characterisation_platform.fig
%      VFAT3_CHARACTERISATION_PLATFORM, by itself, creates a new VFAT3_CHARACTERISATION_PLATFORM or raises the existing
%      singleton*.
%
%      H = VFAT3_CHARACTERISATION_PLATFORM returns the handle to a new VFAT3_CHARACTERISATION_PLATFORM or the handle to
%      the existing singleton*.
%
%      VFAT3_CHARACTERISATION_PLATFORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VFAT3_CHARACTERISATION_PLATFORM.M with the given input arguments.
%
%      VFAT3_CHARACTERISATION_PLATFORM('Property','Value',...) creates a new VFAT3_CHARACTERISATION_PLATFORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vfat3_characterisation_platform_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vfat3_characterisation_platform_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vfat3_characterisation_platform

% Last Modified by GUIDE v2.5 12-Oct-2018 11:25:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vfat3_characterisation_platform_OpeningFcn, ...
                   'gui_OutputFcn',  @vfat3_characterisation_platform_OutputFcn, ...
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


% --- Executes just before vfat3_characterisation_platform is made visible.
function vfat3_characterisation_platform_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vfat3_characterisation_platform (see VARARGIN)

handles.tgroup = uitabgroup('Parent', handles.vfat3_characterisation_fig,'TabLocation', 'top');
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'VFAT3 Configuration');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'SCURVE Analysis');
handles.tab3 = uitab('Parent', handles.tgroup, 'Title', 'Threshold Trimming');
handles.tab4 = uitab('Parent', handles.tgroup, 'Title', 'ENC vs. capacitance');

handles.subgui = findobj(0,'Type','figure','Tag','temperature_calibration_figure')

handles.tab5 = uitab('Parent', handles.tgroup, 'Title', 'Temperature Calibration');
%Place panels into each tab
set(handles.P1,'Parent',handles.tab1)
set(handles.P2,'Parent',handles.tab2)
set(handles.P3,'Parent',handles.tab3)
set(handles.P4,'Parent',handles.tab4)
set(handles.subgui,'Parent',handles.tab5)

%Reposition each panel to same location as panel 1
set(handles.P2,'position',get(handles.P1,'position'));
set(handles.P3,'position',get(handles.P1,'position'));
set(handles.P4,'position',get(handles.P1,'position'));
set(handles.subgui,'position',get(handles.P1,'position'));
% Choose default command line output for vfat3_characterisation_platform
handles.output = hObject;
handles.reply=[];
%handles.SampleOut = [];
handles.Capacitor_arr = [];

handles.ENC_LG_15_arr = [];
handles.ENC_LG_25_arr = [];
handles.ENC_LG_35_arr = [];
handles.ENC_LG_45_arr = [];

handles.ENC_MG_15_arr = [];
handles.ENC_MG_25_arr = [];
handles.ENC_MG_35_arr = [];
handles.ENC_MG_45_arr = [];

handles.ENC_HG_15_arr = [];
handles.ENC_HG_25_arr = [];
handles.ENC_HG_35_arr = [];
handles.ENC_HG_45_arr = [];

handles.LG = 1;
handles.MG = 2;
handles.HG = 3;

handles.PT_15 = 15;
handles.PT_25 = 25;
handles.PT_35 = 35;
handles.PT_45 = 45;
 
handles.channel= 46;


handles.LV1As =1000;

a='Low';b='Medium';c='High'
s=char(a,b,c)
set(handles.popupmenu1,'string',s)
% Update handles structure

guidata(hObject, handles);
default(hObject, handles);

% UIWAIT makes vfat3_characterisation_platform wait for user response (see UIRESUME)
% uiwait(handles.vfat3_characterisation_fig);


% --- Outputs from this function are returned to the command line.
function varargout = vfat3_characterisation_platform_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PB_HardReset.
function PB_HardReset_Callback(hObject, eventdata, handles)
% hObject    handle to PB_HardReset (see GCBO)
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

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function status_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to status_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

guidata(hObject, handles);
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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_Capacitance_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Capacitance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Capacitance as text
%        str2double(get(hObject,'String')) returns contents of edit_Capacitance as a double

Capacitance = str2double(get(hObject, 'String'));
if isnan(Capacitance)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new temperature value
handles.Capacitance = Capacitance;
guidata(hObject,handles)




% --- Executes on button press in pushbutton_acquire_measurement.
function pushbutton_acquire_measurement_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_acquire_measurement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldpointer = get(handles.vfat3_characterisation_fig, 'pointer'); 
set(handles.vfat3_characterisation_fig, 'pointer', 'watch') 
drawnow;
if handles.reply ~= 58   % there is no sync
   errordlg('First connect with chip!','Error');
elseif isempty(handles.Capacitor_arr)% first value in array
    handles.Capacitor_arr(size(handles.Capacitor_arr,2)+1)= handles.Capacitance;
    
    handles.ENC_LG_15_arr(size(handles.ENC_LG_15_arr,2)+1)= calculate_ENC(handles.LG,handles.PT_15,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_LG_25_arr(size(handles.ENC_LG_25_arr,2)+1)= calculate_ENC(handles.LG,handles.PT_25,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_LG_35_arr(size(handles.ENC_LG_35_arr,2)+1)= calculate_ENC(handles.LG,handles.PT_35,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_LG_45_arr(size(handles.ENC_LG_45_arr,2)+1)= calculate_ENC(handles.LG,handles.PT_45,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    
    handles.ENC_MG_15_arr(size(handles.ENC_MG_15_arr,2)+1)= calculate_ENC(handles.MG,handles.PT_15,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_MG_25_arr(size(handles.ENC_MG_25_arr,2)+1)= calculate_ENC(handles.MG,handles.PT_25,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_MG_35_arr(size(handles.ENC_MG_35_arr,2)+1)= calculate_ENC(handles.MG,handles.PT_35,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_MG_45_arr(size(handles.ENC_MG_45_arr,2)+1)= calculate_ENC(handles.MG,handles.PT_45,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    
    handles.ENC_HG_15_arr(size(handles.ENC_HG_15_arr,2)+1)= calculate_ENC(handles.HG,handles.PT_15,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_HG_25_arr(size(handles.ENC_HG_25_arr,2)+1)= calculate_ENC(handles.HG,handles.PT_25,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_HG_35_arr(size(handles.ENC_HG_35_arr,2)+1)= calculate_ENC(handles.HG,handles.PT_35,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_HG_45_arr(size(handles.ENC_HG_45_arr,2)+1)= calculate_ENC(handles.HG,handles.PT_45,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    
    SampleOut = size(handles.ENC_LG_15_arr,2);
    set(handles.SampleOut, 'String', SampleOut);
    
elseif handles.Capacitance == handles.Capacitor_arr(end)% entering same capacitor value , not increasing array index
    
    handles.Capacitor_arr(size(handles.Capacitor_arr,2))= handles.Capacitance;
    
    handles.ENC_LG_15_arr(size(handles.ENC_LG_15_arr,2))= calculate_ENC(handles.LG,handles.PT_15,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_LG_25_arr(size(handles.ENC_LG_25_arr,2))= calculate_ENC(handles.LG,handles.PT_25,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_LG_35_arr(size(handles.ENC_LG_35_arr,2))= calculate_ENC(handles.LG,handles.PT_35,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_LG_45_arr(size(handles.ENC_LG_45_arr,2))= calculate_ENC(handles.LG,handles.PT_45,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    
    handles.ENC_MG_15_arr(size(handles.ENC_MG_15_arr,2))= calculate_ENC(handles.MG,handles.PT_15,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_MG_25_arr(size(handles.ENC_MG_25_arr,2))= calculate_ENC(handles.MG,handles.PT_25,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_MG_35_arr(size(handles.ENC_MG_35_arr,2))= calculate_ENC(handles.MG,handles.PT_35,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_MG_45_arr(size(handles.ENC_MG_45_arr,2))= calculate_ENC(handles.MG,handles.PT_45,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    
    handles.ENC_HG_15_arr(size(handles.ENC_HG_15_arr,2))= calculate_ENC(handles.HG,handles.PT_15,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_HG_25_arr(size(handles.ENC_HG_25_arr,2))= calculate_ENC(handles.HG,handles.PT_25,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_HG_35_arr(size(handles.ENC_HG_35_arr,2))= calculate_ENC(handles.HG,handles.PT_35,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_HG_45_arr(size(handles.ENC_HG_45_arr,2))= calculate_ENC(handles.HG,handles.PT_45,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    
    SampleOut = size(handles.ENC_LG_15_arr,2);
    set(handles.SampleOut, 'String', SampleOut);
else % new different sample with new capacitance 
    handles.Capacitor_arr(size(handles.Capacitor_arr,2)+1)= handles.Capacitance;
    
    handles.ENC_LG_15_arr(size(handles.ENC_LG_15_arr,2)+1)= calculate_ENC(handles.LG,handles.PT_15,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_LG_25_arr(size(handles.ENC_LG_25_arr,2)+1)= calculate_ENC(handles.LG,handles.PT_25,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_LG_35_arr(size(handles.ENC_LG_35_arr,2)+1)= calculate_ENC(handles.LG,handles.PT_35,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_LG_45_arr(size(handles.ENC_LG_45_arr,2)+1)= calculate_ENC(handles.LG,handles.PT_45,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    
    handles.ENC_MG_15_arr(size(handles.ENC_MG_15_arr,2)+1)= calculate_ENC(handles.MG,handles.PT_15,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_MG_25_arr(size(handles.ENC_MG_25_arr,2)+1)= calculate_ENC(handles.MG,handles.PT_25,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_MG_35_arr(size(handles.ENC_MG_35_arr,2)+1)= calculate_ENC(handles.MG,handles.PT_35,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_MG_45_arr(size(handles.ENC_MG_45_arr,2)+1)= calculate_ENC(handles.MG,handles.PT_45,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    
    handles.ENC_HG_15_arr(size(handles.ENC_HG_15_arr,2)+1)= calculate_ENC(handles.HG,handles.PT_15,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_HG_25_arr(size(handles.ENC_HG_25_arr,2)+1)= calculate_ENC(handles.HG,handles.PT_25,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_HG_35_arr(size(handles.ENC_HG_35_arr,2)+1)= calculate_ENC(handles.HG,handles.PT_35,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    handles.ENC_HG_45_arr(size(handles.ENC_HG_45_arr,2)+1)= calculate_ENC(handles.HG,handles.PT_45,handles.channel,handles.LV1As,handles.id,handles.fc_arr,handles.dac_arr);
    
    SampleOut = size(handles.ENC_LG_15_arr,2);
    set(handles.SampleOut, 'String', SampleOut);
end
    
%handles.temp_arr=temp_arr;
%guidata(hObject, handles);
T=table;
handles.T= T;
T.Capacitor = handles.Capacitor_arr';

T.ENC_LG_15 = round(handles.ENC_LG_15_arr'*6241.50934326018);
T.ENC_LG_25 = round(handles.ENC_LG_25_arr'*6241.50934326018);
T.ENC_LG_35 = round(handles.ENC_LG_35_arr'*6241.50934326018);
T.ENC_LG_45 = round(handles.ENC_LG_45_arr'*6241.50934326018);

T.ENC_MG_15 = round(handles.ENC_MG_15_arr'*6241.50934326018);
T.ENC_MG_25 = round(handles.ENC_MG_25_arr'*6241.50934326018);
T.ENC_MG_35 = round(handles.ENC_MG_35_arr'*6241.50934326018);
T.ENC_MG_45 = round(handles.ENC_MG_45_arr'*6241.50934326018);

T.ENC_HG_15 = round(handles.ENC_HG_15_arr'*6241.50934326018);
T.ENC_HG_25 = round(handles.ENC_HG_25_arr'*6241.50934326018);
T.ENC_HG_35 = round(handles.ENC_HG_35_arr'*6241.50934326018);
T.ENC_HG_45 = round(handles.ENC_HG_45_arr'*6241.50934326018);


handles.T= T;
guidata(hObject, handles);

T
set(handles.vfat3_characterisation_fig, 'pointer', oldpointer)
    %handles.Capacitor_arr
    %handles.ENC_HG_15_arr
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Capacitor_arr = [];

handles.ENC_LG_15_arr = [];
handles.ENC_LG_25_arr = [];
handles.ENC_LG_35_arr = [];
handles.ENC_LG_45_arr = [];

handles.ENC_MG_15_arr = [];
handles.ENC_MG_25_arr = [];
handles.ENC_MG_35_arr = [];
handles.ENC_MG_45_arr = [];

handles.ENC_HG_15_arr = [];
handles.ENC_HG_25_arr = [];
handles.ENC_HG_35_arr = [];
handles.ENC_HG_45_arr = [];
SampleOut = size(handles.ENC_LG_15_arr,2);
    set(handles.SampleOut, 'String', SampleOut);
guidata(hObject, handles);
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if size(handles.Capacitor_arr,2)>=2
   
    
axes(handles.axes7);
cla;
 [fitresult_LG_15,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_LG_15)
 [fitresult_LG_25,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_LG_25)
 [fitresult_LG_35,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_LG_35)
 [fitresult_LG_45,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_LG_45)
 
plot (handles.T.Capacitor,handles.T.ENC_LG_15,'-x',handles.Capacitor_arr,handles.T.ENC_LG_25,'-o',handles.Capacitor_arr,handles.T.ENC_LG_35,'-+',handles.Capacitor_arr,handles.T.ENC_LG_45,'-*');
legend({'15ns','25ns','35ns','45ns'},'Location','southeast');
xlabel 'Capacitance(fC)'
ylabel 'ENC(e)'
T_str0 = ['Date:',num2str(date)];
T_str1 = ['Chip ID : ',num2str(handles.id)];
T_str2 = ['Channel:',num2str(handles.channel)];
T_str3 =  'LG';
str0 = ['15:Y = p1*X + p2 (p1:',num2str(round(fitresult_LG_15.p1,2)),',','p2:',num2str(round(fitresult_LG_15.p2,2)),')'];
str1 = ['25:Y = p1*X + p2 (p1:',num2str(round(fitresult_LG_25.p1,2)),',','p2:',num2str(round(fitresult_LG_25.p2,2)),')'];
str2 = ['35:Y = p1*X + p2 (p1:',num2str(round(fitresult_LG_35.p1,2)),',','p2:',num2str(round(fitresult_LG_35.p2,2)),')'];
str3 = ['45:Y = p1*X + p2 (p1:',num2str(round(fitresult_LG_45.p1,2)),',','p2:',num2str(round(fitresult_LG_45.p2,2)),')'];
insert_plot_timestamps(handles.T.Capacitor,handles.T.ENC_LG_15,T_str0,T_str1,T_str2,T_str3)
insert_plot_text(handles.T.Capacitor,handles.T.ENC_LG_45,str0,str1,str2,str3)






axes(handles.axes8);
cla;
 [fitresult_MG_15,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_MG_15)
 [fitresult_MG_25,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_MG_25)
 [fitresult_MG_35,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_MG_35)
 [fitresult_MG_45,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_MG_45)
 
plot (handles.T.Capacitor,handles.T.ENC_MG_15,'-x',handles.Capacitor_arr,handles.T.ENC_MG_25,'-o',handles.Capacitor_arr,handles.T.ENC_MG_35,'-+',handles.Capacitor_arr,handles.T.ENC_MG_45,'-*');
legend({'15ns','25ns','35ns','45ns'},'Location','southeast');
xlabel 'Capacitance(fC)'
ylabel 'ENC(e)'
T_str0 = ['Date:',num2str(date)];
T_str1 = ['Chip ID : ',num2str(handles.id)];
T_str2 = ['Channel:',num2str(handles.channel)];
T_str3 =  'MG';
str0 = ['15:Y = p1*X + p2 (p1:',num2str(round(fitresult_MG_15.p1,2)),',','p2:',num2str(round(fitresult_MG_15.p2,2)),')'];
str1 = ['25:Y = p1*X + p2 (p1:',num2str(round(fitresult_MG_25.p1,2)),',','p2:',num2str(round(fitresult_MG_25.p2,2)),')'];
str2 = ['35:Y = p1*X + p2 (p1:',num2str(round(fitresult_MG_35.p1,2)),',','p2:',num2str(round(fitresult_MG_35.p2,2)),')'];
str3 = ['45:Y = p1*X + p2 (p1:',num2str(round(fitresult_MG_45.p1,2)),',','p2:',num2str(round(fitresult_MG_45.p2,2)),')'];
insert_plot_timestamps(handles.T.Capacitor,handles.T.ENC_MG_15,T_str0,T_str1,T_str2,T_str3)
insert_plot_text(handles.T.Capacitor,handles.T.ENC_MG_45,str0,str1,str2,str3)





axes(handles.axes9);
cla;
[fitresult_HG_15,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_HG_15)
 [fitresult_HG_25,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_HG_25)
 [fitresult_HG_35,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_HG_35)
 [fitresult_HG_45,~] = LinearFit_No_Plot(handles.T.Capacitor,handles.T.ENC_HG_45)
 
 plot (handles.T.Capacitor,handles.T.ENC_HG_15,'-x',handles.Capacitor_arr,handles.T.ENC_HG_25,'-o',handles.Capacitor_arr,handles.T.ENC_HG_35,'-+',handles.Capacitor_arr,handles.T.ENC_HG_45,'-*');
legend({'15ns','25ns','35ns','45ns'},'Location','southeast');
xlabel 'Capacitance(fC)'
ylabel 'ENC(e)'
T_str0 = ['Date:',num2str(date)];
T_str1 = ['Chip ID : ',num2str(handles.id)];
T_str2 = ['Channel:',num2str(handles.channel)];
T_str3 =  'HG';
str0 = ['15:Y = p1*X + p2 (p1:',num2str(round(fitresult_HG_15.p1,2)),',','p2:',num2str(round(fitresult_HG_15.p2,2)),')'];
str1 = ['25:Y = p1*X + p2 (p1:',num2str(round(fitresult_HG_25.p1,2)),',','p2:',num2str(round(fitresult_HG_25.p2,2)),')'];
str2 = ['35:Y = p1*X + p2 (p1:',num2str(round(fitresult_HG_35.p1,2)),',','p2:',num2str(round(fitresult_HG_35.p2,2)),')'];
str3 = ['45:Y = p1*X + p2 (p1:',num2str(round(fitresult_HG_45.p1,2)),',','p2:',num2str(round(fitresult_HG_45.p2,2)),')'];
insert_plot_timestamps(handles.T.Capacitor,handles.T.ENC_HG_15,T_str0,T_str1,T_str2,T_str3)
insert_plot_text(handles.T.Capacitor,handles.T.ENC_HG_45,str0,str1,str2,str3)



else 
    errordlg('You need at least two data points to plot!','Error');
end

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected_dir = uigetdir();
handles.selected_dir = selected_dir; 
%set(handles.selected_path, 'String', selected_dir)   %change handle name as appropriate

%[FileName,FilePath ]= uigetfile();
%ExPath = fullfile(FilePath, FileName)
set(handles.edit_browse,'string',selected_dir);% show path on gui

guidata(hObject,handles)


% --- Executes on button press in save_data.
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.selected_dir)
d= datestr(datetime('now','InputFormat','yyyy-MM-dd''T''HHmm'));
d= erase(d,':');
d= erase(d,'-');
d= erase(d,'#');
d= erase(d,' ');
folderName = horzcat(handles.selected_dir,'/results/vfat3_',num2str(handles.id));% define a folder name for every chip programatically
[parentFolder deepestFolder] = fileparts(folderName);
ENCSubFolder = sprintf('%s/ENC_DATA', folderName);% define a scurve subfolder
% Finally, create the folder if it doesn't exist already.
if ~exist(ENCSubFolder, 'dir')
  mkdir(ENCSubFolder);
end

filename = horzcat(ENCSubFolder,'/ENC_DATA_',num2str(handles.id),'_',d,'.xlsx');

%fileID   = fopen(filename,'w');
plot_data=(handles.T);
writetable(plot_data,filename);
%xlswrite(filename,plot_data);
end


function edit_channel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_channel as text
%        str2double(get(hObject,'String')) returns contents of edit_channel as a double
Channel = str2double(get(hObject, 'String'));
if isnan(Channel)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');

elseif Channel >=0 && Channel<=127
% Save the new temperature value
handles.channel = Channel;
guidata(hObject,handles)
else 
     set(hObject, 'String', 0);
    errordlg('Input must be between 0 and 127','Error');
end 
% --- Executes during object creation, after setting all properties.
function edit_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
Channel = str2double(get(hObject, 'String'));
if isnan(Channel)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');

elseif Channel >=0 && Channel<=127
% Save the new temperature value
handles.channel = Channel;
guidata(hObject,handles)
else 
     set(hObject, 'String', 0);
    errordlg('Input must be between 0 and 127','Error');
end 

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function default(hObject, handles)

    set(handles.edit_channel, 'string', num2str(handles.channel));% default setting for channel field
   
    guidata(hObject, handles);



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
