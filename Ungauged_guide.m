function varargout = Ungauged_guide(varargin)

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

% UNGAUGED_GUIDE MATLAB code for Ungauged_guide.fig
%      UNGAUGED_GUIDE, by itself, creates a new UNGAUGED_GUIDE or raises the existing
%      singleton*.
%
%      H = UNGAUGED_GUIDE returns the handle to a new UNGAUGED_GUIDE or the handle to
%      the existing singleton*.
%
%      UNGAUGED_GUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNGAUGED_GUIDE.M with the given input arguments.
%
%      UNGAUGED_GUIDE('Property','Value',...) creates a new UNGAUGED_GUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Ungauged_guide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Ungauged_guide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Ungauged_guide

% Last Modified by GUIDE v2.5 21-Jul-2020 17:20:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Ungauged_guide_OpeningFcn, ...
                   'gui_OutputFcn',  @Ungauged_guide_OutputFcn, ...
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


% --- Executes just before Ungauged_guide is made visible.
function Ungauged_guide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Ungauged_guide (see VARARGIN)

global CN_calib Ia_calib SUH_method BF_temp BF_flag check_cal x_par calib_flag valid_flag ungauged_flag inp_event_ungauged inp_fac_ungauged inp_fdr_ungauged;
% Selection enable paramiters to baseflow methods
handles.view_results_button.Enable = 'off';

calib_flag = 0;
valid_flag = 0;
ungauged_flag = 1;
BF_temp = BF_flag;

cla(handles.axes2);inp_event_ungauged = 0;
handles.axes2.Visible = 'off';
cla(handles.axes3);inp_fac_ungauged = 0;
handles.axes3.Visible = 'off';
cla(handles.axes4);inp_fdr_ungauged = 0;
handles.axes4.Visible = 'off';

if check_cal == 1
    handles.Ia_param.String = Ia_calib;
    handles.CN_param.String = CN_calib;
end

% if BF_flag == 1
%     if BF_method == 2
%         if check_cal == 1
%             handles.Ia_param.String = BF_a;
%         end
%         handles.BF_uipanel.Title = 'Base flow parameters - Lyne and Hollick method';
%         handles.Baseflow_const_param.Enable = 'off';
%         handles.Baseflow_const_text.Enable = 'off';
%         handles.Ia_param.Enable = 'on';
%         handles.Ia_param_text.Enable = 'on';
%     elseif BF_method == 3
%         if check_cal == 1
%             handles.Ia_param.String = BF_a;
%         end
%         handles.BF_uipanel.Title = 'Base flow parameters - Chapman and Maxwell method';
%         handles.Baseflow_const_param.Enable = 'off';
%         handles.Baseflow_const_text.Enable = 'off';
%         handles.Ia_param.Enable = 'on';
%         handles.Ia_param_text.Enable = 'on';
%     elseif BF_method == 4
%         if check_cal == 1
%             handles.Ia_param.String = BF_a;
%             handles.Baseflow_const_param.String = BF_bfi;
%         end        
%         handles.BF_uipanel.Title = 'Base flow parameters - Eckhardt method';
%         handles.Baseflow_const_param.Enable = 'on';
%         handles.Baseflow_const_text.Enable = 'on';
%         handles.Ia_param.Enable = 'on';
%         handles.Ia_param_text.Enable = 'on';
%     end
% else
%     handles.BF_uipanel.Title = 'Base flow parameters (not applicable)';
%     
%     handles.Baseflow_const_param.Enable = 'off';
%     handles.Baseflow_const_text.Enable = 'off';
%     handles.Ia_param.Enable = 'off';
%     handles.Ia_param_text.Enable = 'off';
%     
% end

handles.Baseflow_const_text.TooltipString = ['Defines a constant value for the baseflow',char(10)...
                                             ,'if it does not have a value then use 0 (zero)',char(10)...
                                             ,'to indicate that there is no baseflow.']; %help text

handles.base_time_text.TooltipString = ['Is the base time value, it can be an',char(10)...
                                        ,'estimated value for the runoff duration']; %help text

handles.Ia_param_text.TooltipString = ['Initial abstraction (Ia)',char(10)...
                                       ,'is determined as the rainfall of event that',char(10)...
                                       ,'falls before the direct runoff starts']; %help text

handles.CN_param_text.TooltipString = 'Curve number (CN)'; %help text



if SUH_method == 2
    if check_cal == 1
        handles.ungauged_param1_in.String = x_par(1);
        handles.ungauged_param2_in.String = x_par(2);
    end
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_ungauged.Name = 'SUnHyT - Ungauged - Mockus method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    
  
    handles.ungauged_param2_text.Enable = 'on';
    handles.ungauged_param2_in.Enable = 'on';
    
    handles.ungauged_param1_text.String = 'tc:';
    handles.ungauged_param1_text.TooltipString = ['tc: time of concentration [dt]',char(10)...
                                               ,'(e.g. if dt = 3600s, then tc = 1 is equivalent to 3600s)']; %help text

    handles.ungauged_param2_text.String = 'm:';
    handles.ungauged_param2_text.TooltipString = 'm: dimensionless parameter'; %help text

    

elseif SUH_method == 3
    if check_cal == 1
        if exist('data\data_base\Calibration\temp\P_Fisi.mat','file')~=0
        load('data\data_base\Calibration\temp\P_Fisi','P_Fisi');
        
        handles.ungauged_param1_in.String = x_par(1);
        handles.ungauged_param2_in.String = x_par(2);
        handles.SUH_param1.String = num2str(P_Fisi(1));
        handles.SUH_param2.String = num2str(P_Fisi(2));
        
        end
        
    end
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Physical parameters - Snyder`s method';
    handles.figure_ungauged.Name = 'SUnHyT - Ungauged - Snyder`s method';
    %handles.SUH_param1_text.Visible = 'on';
    %handles.SUH_param1.Visible = 'on';
    %handles.SUH_param2_text.Visible = 'on';
    %handles.SUH_param2.Visible = 'on';
    handles.SUH_param1_text.Enable = 'on';
    handles.SUH_param1.Enable = 'on';
    handles.SUH_param2_text.Enable = 'on';
    handles.SUH_param2.Enable = 'on';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    
    handles.SUH_param1_text.String = 'L:';
    handles.SUH_param1_text.TooltipString = 'L: mainstream length [km]'; %help text

    handles.SUH_param2_text.String = 'Lc:';
    handles.SUH_param2_text.TooltipString = ['Lc: distance from the watershed outlet to a',char(10)...
                                            ,'point on the main stream nearest to the center',char(10)...
                                            ,'of the watershed area [km]']; %help text

    
    handles.ungauged_param2_text.Enable = 'on';
    handles.ungauged_param2_in.Enable = 'on';
    
    handles.ungauged_param1_text.String = 'Ct:';
    handles.ungauged_param1_text.TooltipString = 'Ct: dimenssionless parameter'; %help text

    handles.ungauged_param2_text.String = 'Cp:';
    handles.ungauged_param2_text.TooltipString = 'Cp: dimenssionless parameter'; %help text  

      
    
elseif SUH_method == 4
    if check_cal == 1
        handles.ungauged_param1_in.String = x_par(1);
    end
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_ungauged.Name = 'SUnHyT - Ungauged - Zoch`s method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    

    handles.ungauged_param2_text.Enable = 'off';
    handles.ungauged_param2_in.Enable = 'off';
    
    handles.ungauged_param1_text.String = 'k:';
    handles.ungauged_param1_text.TooltipString = ['k: reservoir decay [dt]',char(10)...
                                               ,'(e.g. if dt = 3600s, then k = 1 is equivalent to 3600s)']; %help text

elseif SUH_method == 5
    if check_cal == 1
        handles.ungauged_param1_in.String = x_par(1);
        handles.ungauged_param2_in.String = x_par(2);
    end    
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_ungauged.Name = 'SUnHyT - Ungauged - Nash`s method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    
  
    handles.ungauged_param2_text.Enable = 'on';
    handles.ungauged_param2_in.Enable = 'on';
    
    handles.ungauged_param1_text.String = 'n:';
    handles.ungauged_param1_text.TooltipString = 'n: number of reservoirs'; %help text

    handles.ungauged_param2_text.String = 'k:';
    handles.ungauged_param2_text.TooltipString = ['k: reservoir decay [dt]',char(10)...
                                               ,'(e.g. if dt = 3600s, then k0 = 1 is equivalent to 3600s)']; %help text

elseif SUH_method == 6
    if check_cal == 1
        handles.ungauged_param1_in.String = x_par(1);
        handles.ungauged_param2_in.String = x_par(2);
    end    
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_ungauged.Name = 'SUnHyT - Ungauged - TwoParLn method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    

    handles.ungauged_param2_text.Enable = 'on';
    handles.ungauged_param2_in.Enable = 'on';
    
    handles.ungauged_param1_text.String = 'p1:';
    handles.ungauged_param1_text.TooltipString = ['p1: shape parameter',char(10)...
                                              ,'(is the standard deviation of the log of the distribution)(p1>0)'];

    handles.ungauged_param2_text.String = 'p2:';
    handles.ungauged_param2_text.TooltipString = ['p2: mean of the log of the distribution'];

elseif SUH_method == 7
    if check_cal == 1
        handles.ungauged_param1_in.String = x_par(1);
        handles.ungauged_param2_in.String = x_par(2);
    end
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_ungauged.Name = 'SUnHyT - Ungauged - TwoParGama method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    

    handles.ungauged_param2_text.Enable = 'on';
    handles.ungauged_param2_in.Enable = 'on';
    
    handles.ungauged_param1_text.String = 'p1:';
    handles.ungauged_param1_text.TooltipString = 'p1: scale parameter'; 

    handles.ungauged_param2_text.String = 'p2:';
    handles.ungauged_param2_text.TooltipString = 'p2: shape parameter (p2>0)';

elseif SUH_method == 8
    if check_cal == 1
        
        if exist('data\data_base\Calibration\temp\Law.mat','file')~=0
            load('data\data_base\Calibration\temp\Law','Law');
                
        handles.ungauged_param1_in.String = x_par(1);
        handles.SUH_param1.String = num2str(Law(1));
        handles.SUH_param2.String = num2str(Law(2));        
        handles.SUH_param3.String = num2str(Law(3));        
        handles.SUH_param4.String = num2str(Law(4));
        end
    end
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Geomorphological properties';
    handles.figure_ungauged.Name = 'SUnHyT - Ungauged - Rodriguez-Iturbé`s method';
    handles.SUH_param1_text.Enable = 'on';
    handles.SUH_param1.Enable = 'on';
    handles.SUH_param2_text.Enable = 'on';
    handles.SUH_param2.Enable = 'on';
    handles.SUH_param3_text.Enable = 'on';
    handles.SUH_param3.Enable = 'on';
    handles.SUH_param4_text.Enable = 'on';
    handles.SUH_param4.Enable = 'on';
    handles.SUH_param1_text.String = 'L:';
    handles.SUH_param1_text.TooltipString = 'L: length of main stream [km]';
    handles.SUH_param2_text.String = 'Rl:';
    handles.SUH_param2_text.TooltipString = 'Rl: law of stream length';
    handles.SUH_param3_text.String = 'Rb:';
    handles.SUH_param3_text.TooltipString = 'Rb: Horton law of stream number';
    handles.SUH_param4_text.String = 'Ra:';
    handles.SUH_param4_text.TooltipString = 'Ra: law of stream areas';

    handles.ungauged_param2_text.Enable = 'off';
    handles.ungauged_param2_in.Enable = 'off';
    
    handles.ungauged_param1_text.String = 'v:';
    handles.ungauged_param1_text.TooltipString = ['v: hydrodynamic factor flow velocity [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a v = 1 is equivalent to 1/3600 = 0.00028 m/s'];
    
elseif SUH_method == 9
    if check_cal == 1
        if exist('data\data_base\Calibration\temp\Law.mat','file')~=0
            load('data\data_base\Calibration\temp\Law','Law');
        
        handles.ungauged_param1_in.String = x_par(1);
        handles.SUH_param1.String = num2str(Law(1));
        handles.SUH_param2.String = num2str(Law(2));        
        handles.SUH_param3.String = num2str(Law(3));        
        handles.SUH_param4.String = num2str(Law(4));
        
        end
    end
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Geomorphological properties';
    handles.figure_ungauged.Name = 'SUnHyT - Ungauged - Rosso`s method';
    handles.SUH_param1_text.Enable = 'on';
    handles.SUH_param1.Enable = 'on';
    handles.SUH_param2_text.Enable = 'on';
    handles.SUH_param2.Enable = 'on';
    handles.SUH_param3_text.Enable = 'on';
    handles.SUH_param3.Enable = 'on';
    handles.SUH_param4_text.Enable = 'on';
    handles.SUH_param4.Enable = 'on';
    handles.SUH_param1_text.String = 'L:';
    handles.SUH_param1_text.TooltipString = 'L: length of main stream [km]';
    handles.SUH_param2_text.String = 'Rl:';
    handles.SUH_param2_text.TooltipString = 'Rl: law of stream length';
    handles.SUH_param3_text.String = 'Rb:';
    handles.SUH_param3_text.TooltipString = 'Rb: Horton law of stream number';
    handles.SUH_param4_text.String = 'Ra:';
    handles.SUH_param4_text.TooltipString = 'Ra: law of stream areas';
    
    
    handles.ungauged_param2_text.Enable = 'off';
    handles.ungauged_param2_in.Enable = 'off';
    
    handles.ungauged_param1_text.String = 'v:';
    handles.ungauged_param1_text.TooltipString = ['v: hydrodynamic factor flow velocity [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a v = 1 is equivalent to 1/3600 = 0.00028 m/s'];

    
elseif SUH_method == 10
    if check_cal == 1
        
        handles.ungauged_param1_in.String = x_par(1);
        handles.ungauged_param2_in.String = x_par(2);
        
    end
    handles.input_f_accumulation.Visible = 'on';
    handles.input_f_direction.Visible = 'on';
    handles.figure_ungauged.Name = 'SUnHyT - Ungauged - Kirkby`s method';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';    
    
    handles.ungauged_param2_text.Enable = 'on';
    handles.ungauged_param2_in.Enable = 'on';
    
    handles.ungauged_param1_text.String = 'vr:';
    handles.ungauged_param1_text.TooltipString = ['vr: average velocity of river [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a vr = 1 is equivalent to 1/3600 = 0.00028 m/s'];

    handles.ungauged_param2_text.String = 'vh:';
    handles.ungauged_param2_text.TooltipString = ['vh: average velocity of hillslope [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a vh = 1 is equivalent to 1/3600 = 0.00028 m/s'];

else    
end
% Choose default command line output for Ungauged_guide
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Ungauged_guide wait for user response (see UIRESUME)
% uiwait(handles.figure_ungauged);


% --- Outputs from this function are returned to the command line.
function varargout = Ungauged_guide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_ungauged_button.
function start_ungauged_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_ungauged_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of start_ungauged_button


global SUH_method BF_flag BF_method BF_a BF_bfi area dt stat x_par_ungauged P1_text P2_text bt inp_event_ungauged inp_fac_ungauged inp_fdr_ungauged calib_flag valid_flag ungauged_flag;
 
calib_flag = 0;
valid_flag = 0;
ungauged_flag = 1;

if inp_event_ungauged == 0 && SUH_method ~= 10
    msgbox('Make sure you have loaded the input data');
    return
end

if isempty(handles.Baseflow_const_param.String)==1
    msgbox('Make sure you have entered the "Constant baseflow" parameter.');
    return
end

if isempty(handles.base_time_param.String)== 1 
    msgbox('Make sure you have entered the "Base time" parameter');
    return
else
    bt = str2num(handles.base_time_param.String);
end

if isempty(handles.CN_param.String)==1
    msgbox('Make sure you have entered the "CN" parameter');
    return
end
if isempty(handles.Ia_param.String)==1
    msgbox('Make sure you have entered the "Ia" parameter');
    return
end

handles.view_results_button.Enable = 'off';
load('data\data_base\Ungauged\temp\Evento_ungauged','Evento');

%[bt]=basetime(Evento);

if isempty(handles.Baseflow_const_param.String)==0 && str2num(handles.Baseflow_const_param.String)~=0
   BF_flag = 1;
else
   BF_flag = 0; 
end

%Evento=Precipi;
Evento(:,2:4)=0;
Evento(size(Evento,1)+1:size(Evento,1)+bt,:)=0;
Evento(:,3)= str2num(handles.Baseflow_const_param.String); % Constant baseflow 

CN = str2num(handles.CN_param.String);
Ia = str2num(handles.Ia_param.String);

%[CN,Ia,PMatrix,Evento]=CN_(Evento,area,dt);
[PMatrix,Evento]=CN_Cal(Evento,area,dt,CN,Ia);

if isdir('data\data_base\Ungauged\temp\')==0
    mkdir('data\data_base\Ungauged\temp\');
end

save('data\data_base\Ungauged\temp\PMatrix','PMatrix');
save('data\data_base\Ungauged\temp\Evento','Evento');

if SUH_method==2
    if isempty(handles.ungauged_param1_in.String)==1 || isempty(handles.ungauged_param2_in.String)==1
        msgbox(['Make sure you have entered the parameters ',handles.ungauged_param1_text.String,' and ',handles.ungauged_param2_text.String])
        return;
    end
    P1_text = handles.ungauged_param1_text.String;
    P2_text = handles.ungauged_param2_text.String;    
    stat = [];
    x(1) =  str2num(handles.ungauged_param1_in.String);
    x(2) =  str2num(handles.ungauged_param2_in.String);
    
    Err=Mockus(x);
    
elseif SUH_method==3
    if isempty(handles.ungauged_param1_in.String)==1 || isempty(handles.ungauged_param2_in.String)==1
        msgbox(['Make sure you have entered the parameters ',handles.ungauged_param1_text.String,' and ',handles.ungauged_param2_text.String])
        return;
    end
    if isempty(handles.SUH_param1.String)==0 && isempty(handles.SUH_param2.String)==0
        P1_text = handles.ungauged_param1_text.String;
        P2_text = handles.ungauged_param2_text.String;
        stat = [];
        P_Fisi=[str2num(handles.SUH_param1.String) str2num(handles.SUH_param2.String)]; %Physical parameters=[L Lc]
        if isdir('data\data_base\Ungauged\temp\')==0
            mkdir('data\data_base\Ungauged\temp\');
        end
        save('data\data_base\Ungauged\temp\P_Fisi','P_Fisi');
        x(1) =  str2num(handles.ungauged_param1_in.String);
        x(2) =  str2num(handles.ungauged_param2_in.String);       
        
       Err=Snyder(x);
    else
        msgbox('Make sure you have entered all the physical parameters.')
        return;
    end
elseif SUH_method==4
    if isempty(handles.ungauged_param1_in.String)==1 
        msgbox(['Make sure you have entered the ',handles.ungauged_param1_text.String,' parameter.'])
        return;
    end
    P1_text = handles.ungauged_param1_text.String;
    
    stat = [];
    x(1) = str2num(handles.ungauged_param1_in.String);
    
    Err=Zoch(x);
    
elseif SUH_method==5
    if isempty(handles.ungauged_param1_in.String)==1 || isempty(handles.ungauged_param2_in.String)==1
        msgbox(['Make sure you have entered the parameters ',handles.ungauged_param1_text.String,' and ',handles.ungauged_param2_text.String])
        return;
    end
    P1_text = handles.ungauged_param1_text.String;
    P2_text = handles.ungauged_param2_text.String;    
    stat = [];
   
    x(1) = str2num(handles.ungauged_param1_in.String);
    x(2) = str2num(handles.ungauged_param2_in.String);    
    
    Err=Nash(x);
     
elseif SUH_method==6
    if isempty(handles.ungauged_param1_in.String)==1 || isempty(handles.ungauged_param2_in.String)==1
        msgbox(['Make sure you have entered the parameters ',handles.ungauged_param1_text.String,' and ',handles.ungauged_param2_text.String])
        return;
    end
    P1_text = handles.ungauged_param1_text.String;
    P2_text = handles.ungauged_param2_text.String;    
    stat = [];
    x(1) = str2num(handles.ungauged_param1_in.String);
    x(2) = str2num(handles.ungauged_param2_in.String); 
    
    Err=TwoParLn(x);
    
elseif SUH_method==7    
    if isempty(handles.ungauged_param1_in.String)==1 || isempty(handles.ungauged_param2_in.String)==1
        msgbox(['Make sure you have entered the parameters ',handles.ungauged_param1_text.String,' and ',handles.ungauged_param2_text.String])
        return;
    end
    
    P1_text = handles.ungauged_param1_text.String;
    P2_text = handles.ungauged_param2_text.String;    
    stat = [];
    x(1) = str2num(handles.ungauged_param1_in.String);
    x(2) = str2num(handles.ungauged_param2_in.String);    
    
    Err=TwoParGamma(x);
    
elseif SUH_method==8
    if isempty(handles.ungauged_param1_in.String)==1 
        msgbox(['Make sure you have entered the ',handles.ungauged_param1_text.String,' parameter.'])
        return;
    end
    if isempty(handles.SUH_param1.String)==0 && isempty(handles.SUH_param2.String)==0 && isempty(handles.SUH_param3.String)==0 && isempty(handles.SUH_param4.String)==0
        
        P1_text = handles.ungauged_param1_text.String;
        
        stat = [];        
        Law=[str2num(handles.SUH_param1.String) str2num(handles.SUH_param2.String) str2num(handles.SUH_param3.String) str2num(handles.SUH_param4.String)];        %Geomorphological informations=[L Rl Rb Ra];
        if isdir('data\data_base\Ungauged\temp\')==0
            mkdir('data\data_base\Ungauged\temp\');
        end
        save('data\data_base\Ungauged\temp\Law','Law');
        x(1) = str2num(handles.ungauged_param1_in.String);
        
        Err=Rodriguez(x);
        
    else
        msgbox('Make sure you have entered all the geomorphological properties.')
        return;
    end
elseif SUH_method==9
    if isempty(handles.ungauged_param1_in.String)==1 
        msgbox(['Make sure you have entered the ',handles.ungauged_param1_text.String,' parameter.'])
        return;
    end
    if isempty(handles.SUH_param1.String)==0 && isempty(handles.SUH_param2.String)==0 && isempty(handles.SUH_param3.String)==0 && isempty(handles.SUH_param4.String)==0
        P1_text = handles.ungauged_param1_text.String;
        
        stat = [];
        Law=[str2num(handles.SUH_param1.String) str2num(handles.SUH_param2.String) str2num(handles.SUH_param3.String) str2num(handles.SUH_param4.String)];        %Geomorphological informations=[L Rl Rb Ra];
        if isdir('data\data_base\Ungauged\temp\')==0
            mkdir('data\data_base\Ungauged\temp\');
        end
        save('data\data_base\Ungauged\temp\Law','Law');
        x(1) = str2num(handles.ungauged_param1_in.String);
        
        Err=Rosso(x);       
        
    else
        msgbox('Make sure you have entered all the geomorphological properties.')
        return;
    end
elseif SUH_method==10
    if isempty(handles.ungauged_param1_in.String)==1 || isempty(handles.ungauged_param2_in.String)==1
        msgbox(['Make sure you have entered the parameters ',handles.ungauged_param1_text.String,' and ',handles.ungauged_param2_text.String])
        return;
    end
    if inp_event_ungauged == 1 && inp_fac_ungauged == 1 && inp_fdr_ungauged == 1
        P1_text = handles.ungauged_param1_text.String;
        P2_text = handles.ungauged_param2_text.String;
        
        stat = [];
        prompt = {'Enter Treshold of area (number of cells) to drainage formation'};
        dlgtitle = 'Input';
        dims = [1 35];
        %definput = {'20','hsv'};
        answer = inputdlg(prompt,dlgtitle,dims);%,definput)
        if isempty(answer)==0 && isequal(answer,{''}) == 0
            tr = str2num(char(answer));
            if isdir('data\data_base\Ungauged\temp\')==0
                mkdir('data\data_base\Ungauged\temp\');
            end
            save('data\data_base\Ungauged\temp\tr','tr');
            [river,hill]=distance;                %Define river and hillslope
            save('data\data_base\Ungauged\temp\river','river'); save('data\data_base\Ungauged\temp\hill','hill');          
            x(1) = str2num(handles.ungauged_param1_in.String);
            x(2) = str2num(handles.ungauged_param2_in.String);
            
            Err=Kirkby(x);
            
        else
            msgbox('Enter the threshold of the area (number of cells) to start the calibration.')
            return
        end
    else
        msgbox('Make sure you have loaded all input data (Event, Flow accumulation and Flow direction).')      
        return;
    end
    
end

%if x ~= -9999999999
    handles.view_results_button.Enable = 'on';
    handles.next_button.Enable = 'on';
    
    % Load Hydrograph
    load('data\data_base\Ungauged\temp\Hidrograma','Hidrograma')%[mm]
    [Evento,Hidrograma] = unit_converter(Evento,Hidrograma,area,dt); % outputs: [L/s]
    
    %if BF_flag == 0
    %Hidrograma = Hidrograma+str2num(handles.Baseflow_const_param.String);
    %end    
    Evento(:,2) = Hidrograma;
    Evento(:,4) = [];
    
    % Creation of a constant baseflow series
% baseflow_value = str2num(handles.Baseflow_const_param.String);
% for ii=1:size(Evento,1)
%     value = baseflow_value;
%     if value <= Evento(ii,2)
%         Evento(ii,3)=value;
%     else
%         Evento(ii,3)=Evento(ii,2);
%     end
% end

%     %Baseflow separation filter
%     if BF_flag == 1
%         if BF_method == 2      % Lyne and Hollick method
%             if isempty(handles.Ia_param.String)==0
%                 a = str2num(handles.Ia_param.String); % Parameter
%                 BF_a = handles.Ia_param.String;
%                 Evento(1,3)=Evento(1,2);
%                 for ii=2:size(Evento,1)
%                     if isnan(Evento(ii,2))
%                         Evento(ii,3) = NaN;
%                     else
%                         value = ((a*Evento(ii-1,3))+(((1-a)./2)*(Evento(ii,2)+Evento(ii-1,2))));
%                         if value <= Evento(ii,2)
%                             Evento(ii,3)=value;
%                         else
%                             Evento(ii,3)=Evento(ii,2);
%                         end
%                     end
%                     Evento(:,4)=Evento(:,2)-Evento(:,3);
%                 end
%             else
%                 msgbox('Make sure you have entered the "a" parameter.')
%                 return;
%             end
%             
%         elseif BF_method == 3  % Chapman and Maxwell method
%             if isempty(handles.Ia_param.String)==0
%                 a = str2num(handles.Ia_param.String); % a - Parameter
%                 BF_a = handles.Ia_param.String;
%                 Evento(1,3)=Evento(1,2);
%                 for i1 = 2:size(Evento,1)
%                     if isnan(Evento(i1,2))
%                         Evento(i1,3) = NaN;
%                     else
%                         value = (a/(2-a))*Evento(i1-1,3) + ((1-a)/(2-a))*Evento(i1,2);
%                         if value <= Evento(i1,2)
%                             Evento(i1,3)=value;
%                         else
%                             Evento(i1,3)=Evento(i1,2);
%                         end
%                     end
%                     Evento(:,4)=Evento(:,2)-Evento(:,3);
%                 end
%             else
%                 msgbox('Make sure you have entered the "a" parameter.')
%                 return;
%             end
%             
%         elseif BF_method == 4  % Eckhardt method
%             
%             if isempty(handles.Ia_param.String)==0 && isempty(handles.Baseflow_const_param.String)==0
%                 %ECKHARDT, K. How to construct recursive digital filters for baseflow separation.
%                 %Hydrological Processes, v. 19, n. 1, p. 507–515, 2005.
%                 a = str2num(handles.Ia_param.String);     % a - Parameter
%                 BFI = str2num(handles.Baseflow_const_param.String); % BFI - parameter
%                 BF_a = handles.Ia_param.String;
%                 BF_bfi = handles.Baseflow_const_param.String;
%                 Evento(1,3)= Evento(1,2);
%                 for i=2:size(Evento,1)
%                     value=(((1-BFI)*a*Evento(i-1,3))+((1-a)*BFI*Evento(i,2)))/(1-(a*BFI));
%                     if value<=Evento(i,2)
%                         Evento(i,3)=value;
%                     else
%                         Evento(i,3)=Evento(i,2);
%                     end
%                 end
%                 Evento(:,4)=Evento(:,2)-Evento(:,3);
%             else
%                 msgbox('Make sure you have entered the "a" and "BFI" parameters.')
%                 return;
%             end
%         end
%     else
%         Evento(:,3) = 0;%Evento(:,2);
%         Evento(:,4) = Evento(:,2)-Evento(1,2);
%     end
%     

if isdir('data\data_base\Ungauged\Results\')==0
    mkdir('data\data_base\Ungauged\Results\');
end
    
    save('data\data_base\Ungauged\Results\Evento','Evento');
%    save('data\data_base\Ungauged\Results\Hidrograma','Hidrograma');
    
    x_par_ungauged = x;
    %NSE_ungauged = -Err;
%end



% --- Executes on button press in view_results_button.
function view_results_button_Callback(hObject, eventdata, handles)
% hObject    handle to view_results_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global calib_flag valid_flag ungauged_flag;
calib_flag = 0;
valid_flag = 0;
ungauged_flag = 1;
% Hint: get(hObject,'Value') returns toggle state of view_results_button
guide_results_ungauged;

% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BF_temp BF_flag;
BF_flag = BF_temp;
close();


function SUH_param1_Callback(hObject, eventdata, handles)
% hObject    handle to SUH_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SUH_param1 as text
%        str2double(get(hObject,'String')) returns contents of SUH_param1 as a double


% --- Executes during object creation, after setting all properties.
function SUH_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SUH_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SUH_param2_Callback(hObject, eventdata, handles)
% hObject    handle to SUH_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SUH_param2 as text
%        str2double(get(hObject,'String')) returns contents of SUH_param2 as a double


% --- Executes during object creation, after setting all properties.
function SUH_param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SUH_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SUH_param3_Callback(hObject, eventdata, handles)
% hObject    handle to SUH_param3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SUH_param3 as text
%        str2double(get(hObject,'String')) returns contents of SUH_param3 as a double


% --- Executes during object creation, after setting all properties.
function SUH_param3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SUH_param3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SUH_param4_Callback(hObject, eventdata, handles)
% hObject    handle to SUH_param4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SUH_param4 as text
%        str2double(get(hObject,'String')) returns contents of SUH_param4 as a double


% --- Executes during object creation, after setting all properties.
function SUH_param4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SUH_param4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Baseflow_const_param_Callback(hObject, eventdata, handles)
% hObject    handle to Baseflow_const_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Baseflow_const_param as text
%        str2double(get(hObject,'String')) returns contents of Baseflow_const_param as a double


% --- Executes during object creation, after setting all properties.
function Baseflow_const_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Baseflow_const_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ia_param_Callback(hObject, eventdata, handles)
% hObject    handle to Ia_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ia_param as text
%        str2double(get(hObject,'String')) returns contents of Ia_param as a double


% --- Executes during object creation, after setting all properties.
function Ia_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ia_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in input_event.
function input_event_Callback(hObject, eventdata, handles)
% hObject    handle to input_event (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2);
handles.axes2.Visible = 'off';
% Hint: get(hObject,'Value') returns toggle state of input_event
global inp_event_ungauged calib_flag valid_flag ungauged_flag;
inp_event_ungauged = 0;
calib_flag =0;
valid_flag = 0;
ungauged_flag =1;

[filename, pathname, filterindex] = uigetfile( ...
       {'*.txt*','text editor (*.txt)'}, ...
        'Pick a file', ...
        'MultiSelect', 'on');       
 
if filename ~= 0 
    
    sp = strsplit(filename,'.');
    nameDataFile = sp(1);
     
    %Evento = textread([pathname,filename],'headerlines',2);
    
    event_open = fopen([pathname filename], 'rt');
    cell_event = textscan(event_open, '%f%*[^\n]', 'headerlines', 1);
    Evento =[cell_event{1}];    
    fclose(event_open);
    
    if isdir('data\data_base\Ungauged\temp\')==0
        mkdir('data\data_base\Ungauged\temp\');
    end   
    
    save('data\data_base\Ungauged\temp\Evento_ungauged','Evento');    
    f = figure('Name','Input data','Position',[400 50 300 550]);
    t = uitable(f,'ColumnName', {'Rainfall [mm]'},'ColumnWidth',{110},'Position',[10 10 160 540]);
    set(t,'data',Evento(:,1))
    
    handles.axes2.Visible = 'on';
    axes(handles.axes2)
    matlabImage = imread('tick.png');
    imshow(matlabImage)
    axis off
    axis image
    inp_event_ungauged = 1;


else 

filtroquest = questdlg(['Data file was not imported. Do you want to do the procedure again? '], ...
	'Data file', ...
	'Open file','Exit','Exit');
switch filtroquest    
    case 'Open file'        
    input_event_Callback(hObject, eventdata, handles);
    case 'Exit'        
end
end
handles.output = hObject;   
%imshow(handles.images{index});
guidata(hObject, handles);


% --- Executes on button press in input_f_accumulation.
function input_f_accumulation_Callback(hObject, eventdata, handles)
% hObject    handle to input_f_accumulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes3);
handles.axes3.Visible = 'off';
% Hint: get(hObject,'Value') returns toggle state of input_f_accumulation
global inp_fac_ungauged calib_flag valid_flag ungauged_flag;
inp_fac_ungauged = 0;
calib_flag =0;
valid_flag =0;
ungauged_flag =1;

[filename, pathname, filterindex] = uigetfile( ...
       {'*.txt*','text editor (*.txt)'}, ...
        'Pick a file', ...
        'MultiSelect', 'on');       

    
if filename ~= 0 
    
    sp = strsplit(filename,'.');
    nameDataFile = sp(1);
    

%Kikby's Model Inputs
[fac,R] = arcgridread([pathname,filename]); %Raster of flow accumulation
figure
imfac = image(fac);
imfac.CDataMapping = 'scaled';
colorbar;
axis 'equal'
axis([0 size(fac,2) 0 size(fac,1)])
title('Flow accumulation map')

inp_fac_ungauged = 1;
handles.axes3.Visible = 'on';
axes(handles.axes3)
matlabImage = imread('tick.png');
imshow(matlabImage)
axis off
axis image

if isdir('data\data_base\Ungauged\temp\')==0
    mkdir('data\data_base\Ungauged\temp\');
end
save('data\data_base\Ungauged\temp\fac','fac'); save('data\data_base\Ungauged\temp\R','R');

else 

filtroquest = questdlg(['Data file was not imported. Do you want to do the procedure again? '], ...
	'Data file', ...
	'Open file','Exit','Exit');
switch filtroquest    
    case 'Open file'        
    input_f_accumulation_Callback(hObject, eventdata, handles);
    case 'Exit'        
end
end
handles.output = hObject;   
%imshow(handles.images{index});
guidata(hObject, handles);


% --- Executes on button press in input_f_direction.
function input_f_direction_Callback(hObject, eventdata, handles)
% hObject    handle to input_f_direction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes4);
handles.axes4.Visible = 'off';
% Hint: get(hObject,'Value') returns toggle state of input_f_direction
global inp_fdr_ungauged calib_flag valid_flag ungauged_flag;
inp_fdr_ungauged = 0;
calib_flag =0;
valid_flag =1;
ungauged_flag = 0;

[filename, pathname, filterindex] = uigetfile( ...
       {'*.txt*','text editor (*.txt)'}, ...
        'Pick a file', ...
        'MultiSelect', 'on');       

if filename ~= 0 
    
    sp = strsplit(filename,'.');
    nameDataFile = sp(1);
    
% Kikby's Model Inputs
[fdr] = arcgridread([pathname,filename]);   %Raster of flow direction
figure
imfdr=image(fdr);
imfdr.CDataMapping = 'scaled';
colorbar;
axis 'equal'
axis([0 size(fdr,2) 0 size(fdr,1)])
title('Flow direction map')

inp_fdr_ungauged = 1;
handles.axes4.Visible = 'on';
axes(handles.axes4)
matlabImage = imread('tick.png');
imshow(matlabImage)
axis off
axis image

if isdir('data\data_base\Ungauged\temp\')==0
    mkdir('data\data_base\Ungauged\temp\');
end
save('data\data_base\Ungauged\temp\fdr','fdr'); 

else 

filtroquest = questdlg(['Data file was not imported. Do you want to do the procedure again? '], ...
	'Data file', ...
	'Open file','Exit','Exit');
switch filtroquest    
    case 'Open file'        
    input_f_direction_Callback(hObject, eventdata, handles);
    case 'Exit'        
end
end
handles.output = hObject;   
%imshow(handles.images{index});
guidata(hObject, handles);


function ungauged_param1_in_Callback(hObject, eventdata, handles)
% hObject    handle to ungauged_param1_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ungauged_param1_in as text
%        str2double(get(hObject,'String')) returns contents of ungauged_param1_in as a double


% --- Executes during object creation, after setting all properties.
function ungauged_param1_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ungauged_param1_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ungauged_param2_in_Callback(hObject, eventdata, handles)
% hObject    handle to ungauged_param2_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ungauged_param2_in as text
%        str2double(get(hObject,'String')) returns contents of ungauged_param2_in as a double


% --- Executes during object creation, after setting all properties.
function ungauged_param2_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ungauged_param2_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function base_time_param_Callback(hObject, eventdata, handles)
% hObject    handle to base_time_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of base_time_param as text
%        str2double(get(hObject,'String')) returns contents of base_time_param as a double


% --- Executes during object creation, after setting all properties.
function base_time_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to base_time_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CN_param_Callback(hObject, eventdata, handles)
% hObject    handle to CN_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CN_param as text
%        str2double(get(hObject,'String')) returns contents of CN_param as a double


% --- Executes during object creation, after setting all properties.
function CN_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CN_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure_ungauged.
function figure_ungauged_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_ungauged (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BF_temp BF_flag;
BF_flag = BF_temp;
% Hint: delete(hObject) closes the figure
delete(hObject);
