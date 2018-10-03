function varargout = temperature_calibration(varargin)
% TEMPERATURE_CALIBRATION MATLAB code for temperature_calibration.fig
%      TEMPERATURE_CALIBRATION, by itself, creates a new TEMPERATURE_CALIBRATION or raises the existing
%      singleton*.
%
%      H = TEMPERATURE_CALIBRATION returns the handle to a new TEMPERATURE_CALIBRATION or the handle to
%      the existing singleton*.
%
%      TEMPERATURE_CALIBRATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEMPERATURE_CALIBRATION.M with the given input arguments.
%
%      TEMPERATURE_CALIBRATION('Property','Value',...) creates a new TEMPERATURE_CALIBRATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before temperature_calibration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to temperature_calibration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help temperature_calibration

% Last Modified by GUIDE v2.5 25-Sep-2018 15:53:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @temperature_calibration_OpeningFcn, ...
                   'gui_OutputFcn',  @temperature_calibration_OutputFcn, ...
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

% --- Executes just before temperature_calibration is made visible.
function temperature_calibration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to temperature_calibration (see VARARGIN)

% Choose default command line output for temperature_calibration
handles.output = hObject;
handles.temp_arr =[];
handles.voltage_arr =[];
handles.id = [];
handles.reply =0;
set(handles.hard_reset, 'String', 'Not Connected');
set(handles.id_text, 'String', 'Unknown');
% Update handles structure
guidata(hObject, handles);
 
% This sets up the initial plot - only do when we are invisible
% so window can get raised using temperature_calibration.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes temperature_calibration wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = temperature_calibration_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_acquire.
function pushbutton_acquire_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_acquire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%myhandles = guidata(gcbo);
%set(handles.SampleOut, 'String', SampleOut);
%temp_arr= handles.temp_arr;
%temperature = handles.temperature;
if handles.reply ~= 58
   errordlg('First connect with chip!','Error');
elseif isempty(handles.temp_arr)
    handles.temp_arr(size(handles.temp_arr,2)+1)= handles.temperature;
    handles.voltage_arr(size(handles.voltage_arr,2)+1)= Read_Internal_temp();
     SampleOut = size(handles.voltage_arr,2);
    set(handles.SampleOut, 'String', SampleOut);
elseif handles.temperature == handles.temp_arr(end)
    handles.temp_arr(size(handles.temp_arr,2))= handles.temperature;
    handles.voltage_arr(size(handles.voltage_arr,2))= Read_Internal_temp();
    SampleOut = size(handles.voltage_arr,2);
    set(handles.SampleOut, 'String', SampleOut);
else 
    handles.temp_arr(size(handles.temp_arr,2)+1)= handles.temperature;
    handles.voltage_arr(size(handles.voltage_arr,2)+1)= Read_Internal_temp();

    SampleOut = size(handles.voltage_arr,2);
    set(handles.SampleOut, 'String', SampleOut);
end
    guidata(hObject, handles);
%handles.temp_arr=temp_arr;
%guidata(hObject, handles);
    handles.temp_arr
    handles.voltage_arr

%adc_array =[]; 


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
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

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function temp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to temp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temp_edit as text
%        str2double(get(hObject,'String')) returns contents of temp_edit as a double
temperature = str2double(get(hObject, 'String'));
if isnan(temperature)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new temperature value
handles.temperature = temperature;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function temp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function samples_Callback(hObject, eventdata, handles)
% hObject    handle to samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of samples as text
%        str2double(get(hObject,'String')) returns contents of samples as a double
samples = str2double(get(hObject, 'String'));
if isnan(samples)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new temperature value
handles.samples = samples;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function samples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.temp_arr = [];
handles.voltage_arr = [];
handles.id_text     = 'Unknown';
SampleOut = size(handles.voltage_arr,2);
set(handles.SampleOut, 'String', SampleOut);
guidata(hObject,handles)

% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if size(handles.temp_arr,2)>=2
axes(handles.axes1);
cla;
VFAT3_NUMBER = num2str(handles.id);
x_label = 'Temperature(C)';
y_label = 'ADC(mV)';
title ='SensorOut(mV) vs. Temperature(C) ';
legend_title ='SensorOut(mV)';

[fitresult, gof] = LinearFit_general(handles.temp_arr, handles.voltage_arr,VFAT3_NUMBER,title,legend_title,x_label,y_label,handles.axes1)
else 
    errordlg('You need at least two data points to plot!','Error');
end
    



% --- Executes during object creation, after setting all properties.
function SampleOut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SampleOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_volt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_volt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_volt as text
%        str2double(get(hObject,'String')) returns contents of edit_volt as a double
voltage = str2double(get(hObject, 'String'));
if isnan(voltage)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new voltage value
handles.voltage = voltage;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_volt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_volt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_connect.
function pushbutton_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reply=sync_chip();
handles.reply = reply;
if reply == 58
set(handles.hard_reset, 'String', 'connected');
IREF = AdjustIref();
 handles.IREF = IREF;
 set(handles.iref_text, 'String', handles.IREF);
 chip_id = read_register(hex2dec('00010003'),0);
 handles.id = chip_id;
 set(handles.id_text, 'String',handles.id);
  
 
else
    set(handles.hard_reset, 'String', 'No reply');
end
guidata(hObject,handles)


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d= datestr(datetime('now','InputFormat','yyyy-MM-dd''T''HHmm'));
d= erase(d,':');
d= erase(d,'-');
d= erase(d,'#');
d= erase(d,' ');

folderName = horzcat(handles.selected_dir,'/results/vfat3_',num2str(handles.id));% define a folder name for every chip programatically
[parentFolder deepestFolder] = fileparts(folderName);
TempCalibSubFolder = sprintf('%s/TempCalib', folderName);% define a scurve subfolder
% Finally, create the folder if it doesn't exist already.
if ~exist(TempCalibSubFolder, 'dir')
  mkdir(TempCalibSubFolder);
end

filename = horzcat(TempCalibSubFolder,'/TempCalib_',num2str(handles.id),'_',d,'.xlsx');

%fileID   = fopen(filename,'w');
plot_data=horzcat(handles.temp_arr',handles.voltage_arr');
xlswrite(filename,plot_data);
%fprintf(fileID,'%d',handles.temp_arr');
%fclose(fileID);


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selected_dir = uigetdir();
handles.selected_dir = selected_dir; 
%set(handles.selected_path, 'String', selected_dir)   %change handle name as appropriate

%[FileName,FilePath ]= uigetfile();
%ExPath = fullfile(FilePath, FileName)
set(handles.edit_browse,'string',selected_dir);% show path on gui

guidata(hObject,handles)


function edit_browse_Callback(hObject, eventdata, handles)
% hObject    handle to edit_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_browse as text
%        str2double(get(hObject,'String')) returns contents of edit_browse as a double


% --- Executes during object creation, after setting all properties.
function edit_browse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Close.

% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.

% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all;
