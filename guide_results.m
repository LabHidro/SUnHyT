function varargout = guide_results(varargin)
% GUIDE_RESULTS MATLAB code for guide_results.fig
%      GUIDE_RESULTS, by itself, creates a new GUIDE_RESULTS or raises the existing
%      singleton*.
%
%      H = GUIDE_RESULTS returns the handle to a new GUIDE_RESULTS or the handle to
%      the existing singleton*.
%
%      GUIDE_RESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDE_RESULTS.M with the given input arguments.
%
%      GUIDE_RESULTS('Property','Value',...) creates a new GUIDE_RESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guide_results_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guide_results_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guide_results

% Last Modified by GUIDE v2.5 12-Jul-2020 11:27:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guide_results_OpeningFcn, ...
                   'gui_OutputFcn',  @guide_results_OutputFcn, ...
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


% --- Executes just before guide_results is made visible.
function guide_results_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guide_results (see VARARGIN)
global SUH_method;
handles.check_unit_hidro.Value = 0;
handles.radio_spread.Enable = 'off';
handles.radio_fig.Enable = 'off';

if SUH_method == 10
    handles.check_hill_rivers.Visible = 'on';
else
    handles.check_hill_rivers.Visible = 'off';
end

% Choose default command line output for guide_results
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guide_results wait for user response (see UIRESUME)
% uiwait(handles.figure_output);


% --- Outputs from this function are returned to the command line.
function varargout = guide_results_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in check_unit_hidro.
function check_unit_hidro_Callback(hObject, eventdata, handles)
% hObject    handle to check_unit_hidro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.check_unit_hidro.Value==1
    handles.radio_spread.Enable = 'on';
    handles.radio_fig.Enable = 'on';
else
    handles.radio_spread.Enable = 'off';
    handles.radio_fig.Enable = 'off';
end

% Hint: get(hObject,'Value') returns toggle state of check_unit_hidro


% --- Executes on button press in check_calib_data.
function check_calib_data_Callback(hObject, eventdata, handles)
% hObject    handle to check_calib_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_calib_data


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
global SUH_method BF_flag stat x_par obj_val P1_text P2_text dt calib_flag valid_flag ungauged_flag;
calib_flag =1;
valid_flag =0;
ungauged_flag =0;

val_res = handles.check_unit_hidro.Value+handles.check_calib_data.Value+handles.check_hill_rivers.Value;
if val_res > 0
    if handles.check_unit_hidro.Value == 1
        if handles.radio_fig.Value ==1
            make_figure('Calibration','Time(h)','Runoff (m^3/s)',BF_flag)
        else
            % Load data
            load('data\data_base\Calibration\Results\Evento','Evento')
            load('data\data_base\Calibration\Results\Hidrograma','Hidrograma')
            if BF_flag == 1
                f = figure('Name','Numerical Information','Position',[400 50 500 550]);
                t = uitable(f,'ColumnName', {'Rainfall [mm]' 'Runoff_obs [m^3/s]' 'Runoff_mod [m^3/s]' 'Baseflow [m^3/s]'},'ColumnWidth',{110},'Position',[10 10 490 540]);
                set(t,'data',[Evento(:,1) Evento(:,2) Hidrograma(:,1) Evento(:,3)])
                
            else
                f = figure('Name','Numerical Information','Position',[400 50 400 550]);
                t = uitable(f,'ColumnName', {'Rainfall [mm]' 'Runoff_obs [m^3/s]' 'Runoff_mod [m^3/s]'},'ColumnWidth',{110},'Position',[10 10 390 540]);
                set(t,'data',[Evento(:,1:2) Hidrograma(:,1)])
                                
            end
        end
    end
    if SUH_method == 10 || SUH_method == 7 || SUH_method == 6 || SUH_method == 5 || SUH_method == 3 || SUH_method == 2
        if handles.check_calib_data.Value == 1
            figure
            subplot(2,2,1)
            
%             CI_f1 = @(x,p)prctile(x,abs([min(stat(:,1)),max(stat(:,1))]-(max(stat(:,1))-p)/2));
%             x = stat(:,1);
%             p = 95;          % Confidence Interval 95%
%             CI1 = CI_f1(x,p);
            
            hist(stat(:,1))
%            s1 = std(stat(:,1));
            title([P1_text,' ',num2str(x_par(1))]);%,';  \sigma = ',num2str(CI1(2))])
            xlabel(P1_text(P1_text~=':'))
            ylabel('%')
            
            subplot(2,2,2)
            hist(stat(:,2))
%            s2 = std(stat(:,2));
            title([P2_text,' ',num2str(x_par(2))]);%,';  \sigma = ',num2str(s2)])
            xlabel(P2_text(P2_text~=':'))
            ylabel('%')
            subplot(2,2,[3 4])
            plot(stat(:,3),'b')
            title(['NSE = ', num2str(obj_val)])
            xlabel('funcCount')
            ylabel('NSE')
        end
        if SUH_method == 10
            if handles.check_hill_rivers.Value == 1
                load('data\data_base\Calibration\temp\river','river')
                load('data\data_base\Calibration\temp\hill','hill')
                figure
                subplot(1,2,1)
                hill_n = hill./x_par(2)*dt/(3600);  %[hours]
                hill_n(hill_n==0)=nan;
                imh = image(hill_n);
                axis 'equal'
                axis([0 size(hill,2) 0 size(hill,1)])
                title('Travel time on hillslope (hours)')
                imh.CDataMapping = 'scaled';
                colorbar;
                
                subplot(1,2,2)
                %river_n = ((river./x_par(1))*(dt/3600))./24;  %[days]      
                river_n = (river./x_par(1))*dt/(3600);  %[hours]
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
        if handles.check_calib_data.Value == 1
            figure
            subplot(2,1,1)
            hist(stat(:,1))
%            s = std(stat(:,1));
            title([P1_text, ' ',num2str(x_par)]);%,';  \sigma = ',num2str(s)])
            xlabel(P1_text(P1_text~=':'))
            ylabel('%')
            subplot(2,1,2)
            plot(stat(:,2),'b')
            title(['NSE = ', num2str(obj_val)])
            xlabel('funcCount')
            ylabel('NSE')
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
%close()
rg_close = questdlg(['Make sure you have saved the results. Do you still want to close the window?'], ...
    'Close', ...
    'Yes','No','No');
switch rg_close
    case 'Yes'
        
        delete(guide_results);
        
    case 'No'      
        
end

% --- Executes on button press in radio_spread.
function radio_spread_Callback(hObject, eventdata, handles)
% hObject    handle to radio_spread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_spread


% --- Executes on button press in radio_fig.
function radio_fig_Callback(hObject, eventdata, handles)
% hObject    handle to radio_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_fig


% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dt CN_calib Ia_calib SUH_method SUH_string BF_flag x_par obj_val P1_text P2_text;

% Load data
    load('data\data_base\Calibration\Results\Evento','Evento')
    load('data\data_base\Calibration\Results\Hidrograma','Hidrograma')



if handles.check_unit_hidro.Value == 1
    
    rg_cal_data = questdlg(['Would you like to save the calibration data?'], ...
        'Save file', ...
        'Save file','Exit','Exit');
    switch rg_cal_data
        case 'Save file'
            if BF_flag == 1
                [namefile,path] = uiputfile({'.xlsx',  'Excel (*.xlsx)';'.txt', 'text file(*.txt)'});
                if path ~=0
                    T = table(Evento(:,1),Evento(:,2),Hidrograma(:,1),Evento(:,3));
                    T.Properties.VariableNames = {'Rainfall' 'Runoff_obs' 'Runoff_mod' 'Baseflow'};
                    writetable(T,[path,namefile])
                end
            else
                [namefile,path] = uiputfile({'.xlsx',  'Excel (*.xlsx)';'.txt', 'text file(*.txt)'});
                if path ~=0
                    T = table(Evento(:,1),Evento(:,2),Hidrograma(:,1));
                    T.Properties.VariableNames = {'Rainfall' 'Runoff_obs' 'Runoff_mod'};
                    writetable(T,[path,namefile])
                end
                
            end
        case 'Exit'
    end
    
end

if handles.check_calib_data.Value == 1
    % msgbox('Enter a name to save the calibrated parameters')
    
    rg_cal = questdlg(['Would you like to save the calibrated parameters?'], ...
        'Save file', ...
        'Save file','Exit','Exit');
    switch rg_cal
        case 'Save file'
            
            %         histogram(stat(:,1));
            %         CI_f1 = @(x,p)prctile(x,abs([min(stat(:,1)),max(stat(:,1))]-(max(stat(:,1))-p)/2));
            %         x = stat(:,1);
            %         p = 95;          % Confidence Interval 95%
            %         CI1 = CI_f1(x,p);            
            
            if SUH_method == 10 || SUH_method == 7 || SUH_method == 6 || SUH_method == 5 || SUH_method == 3 || SUH_method == 2
                [namefile,path] = uiputfile({'.txt', 'text file(*.txt)'});
                if path ~= 0
                    path_file = fopen([path,namefile],'w');
                    fprintf(path_file,'***************************************************************\r\n');
                    fprintf(path_file,['                      ',char(cell(SUH_string)),'(Calibration)\r\n']);
                    fprintf(path_file,'***************************************************************\r\n');
                    fprintf(path_file,'%6s %32s\r\n','Parameters','Fit Value');
                    fprintf(path_file,'%5s %35s\r\n',P1_text,num2str(x_par(1)));
                    fprintf(path_file,'%5s %35s\r\n',P2_text,num2str(x_par(2)));
                    fprintf(path_file,'%5s %21s\r\n','Curve Number (CN): ',num2str(CN_calib));
                    fprintf(path_file,'%5s %11s\r\n','Initial abstraction (Ia): ',num2str(Ia_calib));
                    fprintf(path_file,'--> Objective function value\r\n');
                    fprintf(path_file,'%5s %10s\r\n','Nash–Sutcliffe model efficiency coefficient (NSE):',num2str(obj_val));
                    fprintf(path_file,'***************************************************************\r\n');
                    fclose(path_file);
                end
            else
                [namefile,path] = uiputfile({'.txt', 'text file(*.txt)'});
                if path ~= 0
                    path_file = fopen([path,namefile],'w');
                    fprintf(path_file,'***************************************************************\r\n');
                    fprintf(path_file,['                      ',char(cell(SUH_string)),'(Calibration)\r\n']);
                    fprintf(path_file,'***************************************************************\r\n');
                    fprintf(path_file,'%6s %32s\r\n','Parameters','Fit Value');
                    fprintf(path_file,'%5s %35s\r\n',P1_text,num2str(x_par(1)));
                    fprintf(path_file,'%5s %21s\r\n','Curve Number (CN): ',num2str(CN_calib));
                    fprintf(path_file,'%5s %11s\r\n','Initial abstraction (Ia): ',num2str(Ia_calib));
                    fprintf(path_file,'--> Objective function value\r\n');
                    fprintf(path_file,'%5s %10s\r\n','Nash–Sutcliffe model efficiency coefficient (NSE):',num2str(obj_val));
                    fprintf(path_file,'***************************************************************\r\n');
                    fclose(path_file);
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
                 load('data\data_base\Calibration\temp\river','river')
                 load('data\data_base\Calibration\temp\hill','hill')
                 hill_n = hill./x_par(2)*dt/(3600);  %[hours]
                 hill_n(hill_n==0)=nan;
                 river_n = (river./x_par(1))*dt/(3600);  %[hours]
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
                 load('data\data_base\Calibration\temp\hill','hill')
                 travel_time_h = hill./x_par(2)*dt/(3600);  %[hours]
                 travel_time_h(travel_time_h==0)=nan;
                 
                 save([path2 namefile2],'travel_time_h');
             end
         case 'Exit'
     end
     
end


% --- Executes when user attempts to close figure_output.
function figure_output_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% delete(hObject);

rg_close = questdlg(['Make sure you have saved the results. Do you still want to close the window?'], ...
    'Close', ...
    'Yes','No','No');
switch rg_close
    case 'Yes'
        
        delete(hObject);
        
    case 'No'      
        
end
