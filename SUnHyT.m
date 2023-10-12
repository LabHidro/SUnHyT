function varargout = SUnHyT(varargin)
%*********************************************************************
%            Synthetic Unit Hydrograph Tool (SUnHyT)
%*********************************************************************
% Authors: Camyla Innocente dos Santos, Tomas Carlotto, Leonardo Vilela
% Steiner e Pedro Luiz Borges Chaffe%
%
%
% SUnHyT developers: Camyla Innocente dos Santos, Tomas Carlotto, Leonardo Vilela
% Steiner e Pedro Luiz Borges Chaffe%
% Graphical user interface developer and code reviewer: Tomas Carlotto.
%
% This code or any part of it may be used as long as the authors are cited.
% Under no circumstances will authors or copyright holders be liable for any claims,
% damages or other liability arising from the use any part of related code.
%*********************************************************************
 

% SUNHYT MATLAB code for SUnHyT.fig
%      SUNHYT, by itself, creates a new SUNHYT or raises the existing
%      singleton*.
%
%      H = SUNHYT returns the handle to a new SUNHYT or the handle to
%      the existing singleton*.
%
%      SUNHYT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUNHYT.M with the given input arguments.
%
%      SUNHYT('Property','Value',...) creates a new SUNHYT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SUnHyT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SUnHyT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SUnHyT

% Last Modified by GUIDE v2.5 11-Aug-2020 17:24:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SUnHyT_OpeningFcn, ...
                   'gui_OutputFcn',  @SUnHyT_OutputFcn, ...
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


% --- Executes just before SUnHyT is made visible.
function SUnHyT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SUnHyT (see VARARGIN)

global SUH_method BF_flag check_ungauged check_valid check_cal;
check_ungauged = 0;
check_valid = 0;
check_cal = 0;
SUH_method = 0;
BF_flag = 0;
% Choose default command line output for SUnHyT
handles.output = hObject;
handles.BF_m_popupmenu.Enable = 'off';
handles.bf_checkbox.Enable = 'off';
handles.choice_SUH.Enable = 'off';
handles.calib_checkbox.Enable = 'off';
handles.Valid_checkbox.Enable = 'off';
handles.ungauged_checkbox.Enable = 'off';
handles.next_pushbutton.Enable = 'off';

handles.basin_area.TooltipString = 'Basin area [km²]'; %help text
handles.time_interval.TooltipString = 'Temporal resolution of data [s]'; %help text
handles.bf_checkbox.TooltipString = 'Select this option if you want to use baseflow separation.'; %help text

handles.calib_checkbox.TooltipString = ['Select this option to perform parameter calibration.',char(10)...
                                       ,'An event containing observed data of precipitation',char(10)...
                                       ,'and runoff will be required.']; %help text
                                   
handles.Valid_checkbox.TooltipString = ['Select this option to perform parameter validation.',char(10)...
                                       ,'An event containing observed data of precipitation',char(10)...
                                       ,'and runoff will be required.']; %help text
                                   
handles.ungauged_checkbox.TooltipString = ['Select this option to obtain a unit hydrograph',char(10)...
                                           ,'from precipitation data in a basin with no runoff',char(10)...
                                           ,'data available for a given period.']; %help text


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SUnHyT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SUnHyT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function input_area_Callback(hObject, eventdata, handles)
% hObject    handle to input_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_area as text
%        str2double(get(hObject,'String')) returns contents of input_area as a double
if isempty(handles.input_area.String)==0 && isempty(handles.input_dt.String) ==0 
    handles.bf_checkbox.Enable = 'on'; 
    handles.choice_SUH.Enable = 'on';
else
    handles.bf_checkbox.Enable = 'off'; 
    handles.choice_SUH.Enable = 'off';
end



% --- Executes during object creation, after setting all properties.
function input_area_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_dt_Callback(hObject, eventdata, handles)
% hObject    handle to input_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_dt as text
%        str2double(get(hObject,'String')) returns contents of input_dt as a double
if isempty(handles.input_area.String)==0 && isempty(handles.input_dt.String) ==0 
    handles.bf_checkbox.Enable = 'on'; 
    handles.choice_SUH.Enable = 'on';
else
    handles.bf_checkbox.Enable = 'off'; 
    handles.choice_SUH.Enable = 'off';
end


% --- Executes during object creation, after setting all properties.
function input_dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_Btime_Callback(hObject, eventdata, handles)
% hObject    handle to input_Btime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_Btime as text
%        str2double(get(hObject,'String')) returns contents of input_Btime as a double

if isempty(handles.input_area.String)==0 && isempty(handles.input_dt.String) ==0 && isempty(handles.input_Btime.String)==0
    handles.bf_checkbox.Enable = 'on'; 
    handles.choice_SUH.Enable = 'on';
else
    handles.bf_checkbox.Enable = 'off'; 
    handles.choice_SUH.Enable = 'off';
end



% --- Executes during object creation, after setting all properties.
function input_Btime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_Btime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in choice_SUH.
function choice_SUH_Callback(hObject, eventdata, handles)
% hObject    handle to choice_SUH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choice_SUH contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choice_SUH

global SUH_method SUH_string; 
SUH_method = get(handles.choice_SUH,'Value');
SUH_string = handles.choice_SUH.String(SUH_method);
if handles.choice_SUH.Value ~= 1
    handles.calib_checkbox.Enable = 'on';
    handles.Valid_checkbox.Enable = 'on';
    handles.ungauged_checkbox.Enable = 'on';
else
    handles.calib_checkbox.Enable = 'off';
    handles.Valid_checkbox.Enable = 'off';
    handles.ungauged_checkbox.Enable = 'off';
end

% --- Executes during object creation, after setting all properties.
function choice_SUH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choice_SUH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_data_calib.
function select_data_calib_Callback(hObject, eventdata, handles)
% hObject    handle to select_data_calib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of select_data_calib


% --- Executes on button press in start_calib.
function start_calib_Callback(hObject, eventdata, handles)
% hObject    handle to start_calib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of start_calib



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



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select_data_valid.
function select_data_valid_Callback(hObject, eventdata, handles)
% hObject    handle to select_data_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of select_data_valid


% --- Executes on button press in start_valid.
function start_valid_Callback(hObject, eventdata, handles)
% hObject    handle to start_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of start_valid


% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5


% --- Executes on button press in togglebutton6.
function togglebutton6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton6



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



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in next_pushbutton.
function next_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to next_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global sum_action check_ungauged check_valid check_cal area dt;
area = str2num(handles.input_area.String);
dt = str2num(handles.input_dt.String);
%bt = str2num(handles.input_Btime.String);

check_ungauged = get(handles.ungauged_checkbox,'Value');
check_valid = get(handles.Valid_checkbox,'Value');
check_cal = get(handles.calib_checkbox,'Value');

sum_action = check_cal+check_valid+check_ungauged;

SUH_go = handles.choice_SUH.Value;
BF_go = handles.BF_m_popupmenu.Value;

if SUH_go == 1
    msgbox('Select the SUH method to continue.')
end
    
if handles.bf_checkbox.Value == 1
    
    if BF_go == 1
        msgbox('Select the Base flow separation method to continue.')
    end   
    if BF_go ~= 1 && SUH_go ~= 1 && sum_action ~= 0             
        if sum_action > 1
            if check_cal == 1
                Calibration_guide;
            elseif check_valid == 1
                Validation_guide;
            elseif check_ungauged == 1
                Ungauged_guide;
            end
        elseif sum_action == 1
            if check_cal == 1
                Calibration_guide;
            end
            if check_valid == 1
                Validation_guide;
            end
            if check_ungauged == 1
                Ungauged_guide;
            end
            
        end
    end
    
elseif SUH_go ~= 1 && sum_action ~= 0
            if sum_action > 1
            if check_cal == 1
                Calibration_guide;
            elseif check_valid == 1
                Validation_guide;
            elseif check_ungauged == 1
                Ungauged_guide;
            end
        elseif sum_action == 1
            if check_cal == 1
                Calibration_guide;
            end
            if check_valid == 1
                Validation_guide;
            end
            if check_ungauged == 1
                Ungauged_guide;
            end
            
        end   
end

if sum_action == 0
        msgbox('Select the next action ("Calibration", "Validation", "ungauged") to continue.')
end







% --- Executes on selection change in BF_m_popupmenu.
function BF_m_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to BF_m_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BF_m_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BF_m_popupmenu
global BF_method;
BF_method = get(handles.BF_m_popupmenu,'Value');



% --- Executes during object creation, after setting all properties.
function BF_m_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BF_m_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bf_checkbox.
function bf_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to bf_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bf_checkbox
global BF_flag;
BF_flag = handles.bf_checkbox.Value;

if handles.bf_checkbox.Value == 1
    handles.BF_m_popupmenu.Enable = 'on';
else
    handles.BF_m_popupmenu.Enable = 'off';
end


% --- Executes on button press in ungauged_checkbox.
function ungauged_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to ungauged_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ungauged_checkbox
%if handles.calib_checkbox.Value == 1 && handles.Valid_checkbox.Value == 1 && handles.ungauged_checkbox.Value == 1
%    handles.next_pushbutton.Enable = 'on';
%else
    
if handles.ungauged_checkbox.Value == 1
    handles.next_pushbutton.Enable = 'on';
elseif handles.calib_checkbox.Value == 0 && handles.Valid_checkbox.Value == 0 && handles.ungauged_checkbox.Value == 0
    %msgbox('To estimate the unit hydrograph using the "Ungauged" mode, you must perform the calibration process for a monitored period.')
    handles.next_pushbutton.Enable = 'off';
end


% --- Executes on button press in Valid_checkbox.
function Valid_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to Valid_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Valid_checkbox
%if handles.calib_checkbox.Value == 0 && handles.Valid_checkbox.Value == 1 && handles.ungauged_checkbox.Value == 1
%    msgbox('To estimate the unit hydrograph using the "Ungauged" mode, you must perform the calibration process for a monitored period.')
%    handles.next_pushbutton.Enable = 'off';
%else
if handles.Valid_checkbox.Value == 1
    handles.next_pushbutton.Enable = 'on';
elseif handles.calib_checkbox.Value == 0 && handles.Valid_checkbox.Value == 0 && handles.ungauged_checkbox.Value == 0
    handles.next_pushbutton.Enable = 'off';
end


% --- Executes on button press in calib_checkbox.
function calib_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to calib_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calib_checkbox
%if handles.calib_checkbox.Value == 0 && handles.ungauged_checkbox.Value == 1
%    msgbox('To estimate the unit hydrograph using the "Ungauged" mode, you must perform the calibration process for a monitored period.')
%    handles.next_pushbutton.Enable = 'off';  
%else
if handles.calib_checkbox.Value == 1
    handles.next_pushbutton.Enable = 'on';
elseif handles.calib_checkbox.Value == 0 && handles.Valid_checkbox.Value == 0 && handles.ungauged_checkbox.Value == 0
    handles.next_pushbutton.Enable = 'off';
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over input_Btime.
function input_Btime_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to input_Btime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on key press with focus on input_Btime and none of its controls.
function input_Btime_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to input_Btime (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% 


% --- Executes on button press in next_general_par.
function next_general_par_Callback(hObject, eventdata, handles)
% hObject    handle to next_general_par (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.input_area.String)==0 && isempty(handles.input_dt.String) ==0 
    handles.bf_checkbox.Enable = 'on'; 
    handles.choice_SUH.Enable = 'on';
else
    handles.bf_checkbox.Enable = 'off'; 
    handles.choice_SUH.Enable = 'off';
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rg_close1 = questdlg(['All temporary data will be deleted. Do you still want to close the tool?'], ...
    'Close', ...
    'Yes','No','No');
switch rg_close1
    case 'Yes'        
                global check_cal check_valid check_ungauged;
                check_cal=0;
                check_valid=0;
                check_ungauged=0;
%                        
%         if check_cal == 1
%             if isdir('data\data_base\Calibration\temp\')~=0
%              %   delete(Calibration_guide);
%                 rmdir('data\data_base\Calibration\temp','s');
%             end
%             
%         end
%         if check_valid == 1
%             if isdir('data\data_base\Validation\temp\')~=0
%              %   delete(Validation_guide);
%                 rmdir('data\data_base\Validation\temp','s');
%             end
%             
%         end
%         if check_ungauged == 1
%             if isdir('data\data_base\Ungauged\temp\')~=0
%               %  delete(Ungauged_guide);
%                 rmdir('data\data_base\Ungauged\temp','s');                
%             end
%         end   

%delete(guide_results);
%delete(Guide_results_valid);
%delete(guide_results_ungauged);

if isdir('data\')~=0    
    rmdir('data','s');
end
delete(findall(0));
%close 'all'
        
    case 'No'      
        
end
