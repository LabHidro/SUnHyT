function varargout = guide_results_ungauged(varargin)
% GUIDE_RESULTS_UNGAUGED MATLAB code for guide_results_ungauged.fig
%      GUIDE_RESULTS_UNGAUGED, by itself, creates a new GUIDE_RESULTS_UNGAUGED or raises the existing
%      singleton*.
%
%      H = GUIDE_RESULTS_UNGAUGED returns the handle to a new GUIDE_RESULTS_UNGAUGED or the handle to
%      the existing singleton*.
%
%      GUIDE_RESULTS_UNGAUGED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDE_RESULTS_UNGAUGED.M with the given input arguments.
%
%      GUIDE_RESULTS_UNGAUGED('Property','Value',...) creates a new GUIDE_RESULTS_UNGAUGED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guide_results_ungauged_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guide_results_ungauged_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guide_results_ungauged

% Last Modified by GUIDE v2.5 12-Jul-2020 11:23:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guide_results_ungauged_OpeningFcn, ...
                   'gui_OutputFcn',  @guide_results_ungauged_OutputFcn, ...
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


% --- Executes just before guide_results_ungauged is made visible.
function guide_results_ungauged_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guide_results_ungauged (see VARARGIN)

global SUH_method;
handles.check_unit_hidro.Value = 0;
handles.radio_spread.Enable = 'off';
handles.radio_fig.Enable = 'off';

if SUH_method == 10
    handles.check_hill_rivers.Visible = 'on';
else
    handles.check_hill_rivers.Visible = 'off';
end

% Choose default command line output for guide_results_ungauged
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guide_results_ungauged wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guide_results_ungauged_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in check_hill_rivers.
function check_hill_rivers_Callback(hObject, eventdata, handles)
% hObject    handle to check_hill_rivers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_hill_rivers


% --- Executes on button press in results_button.
function results_button_Callback(hObject, eventdata, handles)
% hObject    handle to results_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SUH_method BF_flag x_par_ungauged dt calib_flag valid_flag ungauged_flag;
calib_flag =0;
valid_flag =0;
ungauged_flag =1;
val_res = handles.check_unit_hidro.Value+handles.check_hill_rivers.Value;
if val_res > 0
    if handles.check_unit_hidro.Value == 1
        if handles.radio_fig.Value ==1
            make_figure('Ungauged','Time(h)','Runoff (m^3/s)',BF_flag)
        else
            % Load data
            load('data\data_base\Ungauged\Results\Evento','Evento')
            if BF_flag == 1
                f = figure('Name','Numerical Information','Position',[400 50 500 550]);
                t = uitable(f,'ColumnName', {'Rainfall [mm]' 'Runoff_mod [m^3/s]' 'Baseflow [m^3/s]'},'ColumnWidth',{110},'Position',[10 10 490 540]);
                set(t,'data',[Evento(:,1) Evento(:,2) Evento(:,3)])
                
            else
                f = figure('Name','Numerical Information','Position',[400 50 400 550]);
                t = uitable(f,'ColumnName', {'Rainfall [mm]' 'Runoff_mod [m^3/s]'},'ColumnWidth',{110},'Position',[10 10 390 540]);
                set(t,'data',[Evento(:,1:2)])
                
            end
        end
    end
    
    if SUH_method == 10
        if handles.check_hill_rivers.Value == 1
            load('data\data_base\Ungauged\temp\river','river')
            load('data\data_base\Ungauged\temp\hill','hill')
            figure
            subplot(1,2,1)
            hill_n = hill./x_par_ungauged(2)*dt/(3600);  %[hours]
            hill_n(hill_n==0)=nan;
            imh = image(hill_n);
            axis 'equal'
            axis([0 size(hill,2) 0 size(hill,1)])
            title('Travel time on hillslope (hours)')
            imh.CDataMapping = 'scaled';
            colorbar;
            
            subplot(1,2,2)
            %river_n = ((river./x_par(1))*(dt/3600))./24;  %[days]
            river_n = (river./x_par_ungauged(1))*dt/(3600);  %[hours]
            river_n(river_n==0) = nan;
            travel_time = nan(size(river_n,1),size(river_n,1));
            travel_time(isnan(hill_n)==1)=river_n(isnan(hill_n)==1);
            %travel_time = river_n;
            
            %imr = image(river_n);
            imr = image(travel_time);
            axis 'equal'
            axis([0 size(river,2) 0 size(river,1)])
            title('Travel time in river (hours)')
            
            %C = imr.CData;
            imr.CDataMapping = 'scaled';
            colorbar;
            %caxis([min(river_n(:)) max(river_n(:))])
        end
    end
else
    msgbox('You must select an option to be shown.')
end

% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rg_close = questdlg(['Make sure you have saved the results. Do you still want to close the window?'], ...
    'Close', ...
    'Yes','No','No');
switch rg_close
    case 'Yes'
        
        delete(guide_results_ungauged);
        
    case 'No'      
        
end


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global dt SUH_method SUH_string BF_flag x_par_ungauged P1_text P2_text;

% Load data
    load('data\data_base\Ungauged\Results\Evento','Evento')

if handles.check_unit_hidro.Value == 1
    
    rg_valid_data = questdlg(['Would you like to save the ungauged results?'], ...
        'Save file', ...
        'Save file','Exit','Exit');
    switch rg_valid_data
        case 'Save file'
            if BF_flag == 1
                [namefile,path] = uiputfile({'.xlsx',  'Excel (*.xlsx)';'.txt', 'text file(*.txt)'});
                if path ~=0
                    T = table(Evento(:,1),Evento(:,2),Evento(:,3));
                    T.Properties.VariableNames = {'Rainfall' 'Runoff_mod' 'Baseflow'};
                    writetable(T,[path,namefile])
                end
            else
                [namefile,path] = uiputfile({'.xlsx',  'Excel (*.xlsx)';'.txt', 'text file(*.txt)'});
                if path ~=0
                    T = table(Evento(:,1),Evento(:,2));
                    T.Properties.VariableNames = {'Rainfall' 'Runoff_mod'};
                    writetable(T,[path,namefile])
                end
                
            end
        case 'Exit'
    end
    
end


if handles.check_hill_rivers.Value == 1
     %msgbox('Enter a name to save the travel time matrix (River)');
            
     rg1 = questdlg(['Would you like to save the travel time matrix (River)?'], ...
         'Save file', ...
         'Save file','Exit','Exit');
     switch rg1
         case 'Save file'             
             [namefile1,path1] = uiputfile({'.mat', 'MAT-files(*.mat)'});
             if path1 ~= 0
                 load('data\data_base\Ungauged\temp\river','river')
                 load('data\data_base\Calibration\temp\hill','hill')
                 hill_n = hill./x_par_ungauged(2)*dt/(3600);  %[hours]
                 hill_n(hill_n==0)=nan;
                 river_n = (river./x_par_ungauged(1))*dt/(3600);  %[hours]
                 river_n(river_n==0) = nan;
                 travel_time_r = nan(size(river_n,1),size(river_n,1));
                 travel_time_r(isnan(hill_n)==1)=river_n(isnan(hill_n)==1);
                 
                 save([path1 namefile1],'travel_time_r');
             end
         case 'Exit'
     end
     
     rg2 = questdlg(['Would you like to save the travel time matrix (hillslope)?'], ...
         'Data file', ...
         'Save file','Exit','Exit');
     switch rg2
         case 'Save file'
             [namefile2,path2] = uiputfile({'.mat', 'MAT-files(*.mat)'});
             if path2 ~= 0
                 load('data\data_base\Ungauged\temp\hill','hill')
                 travel_time_h = hill./x_par_ungauged(2)*dt/(3600);  %[hours]
                 travel_time_h(travel_time_h==0)=nan;
                 
                 save([path2 namefile2],'travel_time_h');
             end
         case 'Exit'
     end
     
end


rg_valid = questdlg(['Would you like to save parameters?'], ...
    'Save file', ...
    'Save file','Exit','Exit');
switch rg_valid
    case 'Save file'      
        
        if SUH_method == 10 || SUH_method == 7 || SUH_method == 6 || SUH_method == 5 || SUH_method == 3 || SUH_method == 2
            [namefile,path] = uiputfile({'.txt', 'text file(*.txt)'});
            if path ~= 0
                path_file = fopen([path,namefile],'w');
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',char(cell(SUH_string)),'(Ungauged)\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s\r\n','Parameters','Values');
                fprintf(path_file,'%5s %21s\r\n',P1_text,num2str(x_par_ungauged(1)));
                fprintf(path_file,'%5s %21s\r\n',P2_text,num2str(x_par_ungauged(2)));
                fprintf(path_file,'***************************************************************\r\n')
                fclose(path_file);
            end
        else
            [namefile,path] = uiputfile({'.txt', 'text file(*.txt)'});
            if path ~= 0
                path_file = fopen([path,namefile],'w');
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,['                      ',char(cell(SUH_string)),'(Ungauged)\r\n']);
                fprintf(path_file,'***************************************************************\r\n')
                fprintf(path_file,'%6s %18s\r\n','Parameters','Value');
                fprintf(path_file,'%5s %21s\r\n',P1_text,num2str(x_par_ungauged(1)));
                fprintf(path_file,'***************************************************************\r\n')
                fclose(path_file);
            end
        end
    case 'Exit'
end

% --- Executes on button press in check_unit_hidro.
function check_unit_hidro_Callback(hObject, eventdata, handles)
% hObject    handle to check_unit_hidro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_unit_hidro
if handles.check_unit_hidro.Value==1
    handles.radio_spread.Enable = 'on';
    handles.radio_fig.Enable = 'on';
else
    handles.radio_spread.Enable = 'off';
    handles.radio_fig.Enable = 'off';
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);

rg_close = questdlg(['Make sure you have saved the results. Do you still want to close the window?'], ...
    'Close', ...
    'Yes','No','No');
switch rg_close
    case 'Yes'
        
        delete(hObject);
        
    case 'No'      
        
end
