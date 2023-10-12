function varargout = Calibration_guide(varargin)
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

% CALIBRATION_GUIDE MATLAB code for Calibration_guide.fig
%      CALIBRATION_GUIDE, by itself, creates a new CALIBRATION_GUIDE or raises the existing
%      singleton*.
%
%      H = CALIBRATION_GUIDE returns the handle to a new CALIBRATION_GUIDE or the handle to
%      the existing singleton*.
%
%      CALIBRATION_GUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATION_GUIDE.M with the given input arguments.
%
%      CALIBRATION_GUIDE('Property','Value',...) creates a new CALIBRATION_GUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calibration_guide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calibration_guide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Calibration_guide

% Last Modified by GUIDE v2.5 01-Jul-2020 20:37:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calibration_guide_OpeningFcn, ...
                   'gui_OutputFcn',  @Calibration_guide_OutputFcn, ...
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


% --- Executes just before Calibration_guide is made visible.
function Calibration_guide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calibration_guide (see VARARGIN)


% handles.input_f_accumulation.Visible = 'off';
% handles.input_f_direction.Visible = 'off';
% handles.SUH_param1_text.Enable = 'off';
% handles.SUH_param1.Enable = 'off';
% handles.SUH_param2_text.Enable = 'off';
% handles.SUH_param2.Enable = 'off';
% handles.SUH_param3_text.Enable = 'off';
% handles.SUH_param3.Enable = 'off';
% handles.SUH_param4_text.Enable = 'off';
% handles.SUH_param4.Enable = 'off';

global SUH_method sum_action BF_method BF_flag inp_event inp_fac inp_fdr calib_flag valid_flag ungauged_flag;
handles.view_results_button.Enable = 'off';

calib_flag = 0;
valid_flag = 0;
ungauged_flag = 0;

cla(handles.axes2);inp_event = 0;
handles.axes2.Visible = 'off';
cla(handles.axes3);inp_fac = 0;
handles.axes3.Visible = 'off';
cla(handles.axes4);inp_fdr = 0;
handles.axes4.Visible = 'off';

% Selection enable paramiters to baseflow methods
if BF_flag == 1
    if BF_method == 2
        handles.BF_uipanel.Title = 'Baseflow parameters - Lyne and Hollick method';
        handles.BF_bfi_param.Enable = 'off';
        handles.BF_bfi_param_text.Enable = 'off';
        handles.BF_a_param.Enable = 'on';
        handles.BF_a_param_text.Enable = 'on';
        handles.BF_a_param_text.TooltipString = 'a: baseflow recession constant';
    elseif BF_method == 3
        handles.BF_uipanel.Title = 'Baseflow parameters - Chapman and Maxwell method';
        handles.BF_bfi_param.Enable = 'off';
        handles.BF_bfi_param_text.Enable = 'off';
        handles.BF_a_param.Enable = 'on';
        handles.BF_a_param_text.Enable = 'on';
        handles.BF_a_param_text.TooltipString = 'a: baseflow recession constant';
    elseif BF_method == 4
        handles.BF_uipanel.Title = 'Baseflow parameters - Eckhardt method';
        handles.BF_bfi_param.Enable = 'on';
        handles.BF_bfi_param_text.Enable = 'on';
        handles.BF_bfi_param_text.TooltipString = ['BFImax: Maximum base flow index',char(10)...
                                                  ,'BFImax = 0.8 (Perennial stream)',char(10)...
                                                  ,'BFImax = 0.5 (Ephemeral stream)'];
        handles.BF_a_param.Enable = 'on';
        handles.BF_a_param_text.Enable = 'on';
        handles.BF_a_param_text.TooltipString = 'a: baseflow recession constant';
    end
else
    handles.BF_uipanel.Title = 'Baseflow parameters (not applicable)';
    
    handles.BF_bfi_param.Enable = 'off';
    handles.BF_bfi_param_text.Enable = 'off';
    handles.BF_a_param.Enable = 'off';
    handles.BF_a_param_text.Enable = 'off';
    
end

% Next action of tha interface
if sum_action == 1
    handles.next_button.String = 'Close';
else
    handles.next_button.String = 'Next';    
    handles.next_button.Enable = 'off';
end


if SUH_method == 2
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_calibration.Name = 'SUnHyT - Calibration - Mockus method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    
    handles.initi_param1.Enable = 'on';
    handles.initi_param2.Enable = 'on';
    handles.initi_param1_text.Enable = 'on';
    handles.initi_param2_text.Enable = 'on';
    handles.initi_param1_text.String = 'tc0:';  
    handles.initi_param1_text.TooltipString = ['tc0: first value for concentration time [dt]',char(10)...
                                               ,'(e.g. if dt = 3600s, then tc0 = 1 is equivalent to 3600s)' ]; %help text
   
    handles.initi_param2_text.String = 'm0:';
    handles.initi_param2_text.TooltipString = 'm0: first value of parameter m [dimenssionless]'; %help text
    
    % Calibration intervals
    handles.p2_uipanel.Visible = 'on';
    
    handles.calib_param1_text.String = 'tc:';
    handles.calib_param1_text.TooltipString = ['tc: time of concentration [dt]',char(10)...
                                               ,'(e.g. if dt = 3600s, then tc = 1 is equivalent to 3600s)']; %help text
    handles.calib_param2_text.String = 'm:';
    handles.calib_param2_text.TooltipString = 'm: dimensionless parameter'; %help text
    

elseif SUH_method == 3
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Physical parameters - Snyder`s method';
    handles.figure_calibration.Name = 'SUnHyT - Calibration - Snyder`s method';
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
    handles.initi_param1.Enable = 'on';
    handles.initi_param2.Enable = 'on';
    handles.initi_param1_text.Enable = 'on';
    handles.initi_param2_text.Enable = 'on';
    handles.initi_param1_text.String = 'Ct0:';
    handles.initi_param1_text.TooltipString = 'Ct0: first value of parameter Ct [dimenssionless]'; %help text
    handles.initi_param2_text.String = 'Cp0:';
    handles.initi_param2_text.TooltipString = 'Cp0: first value of parameter Cp [dimenssionless]'; %help text
    
    % Calibration intervals
    handles.p2_uipanel.Visible = 'on';
    
    handles.calib_param1_text.String = 'Ct:';
    handles.calib_param1_text.TooltipString = 'Ct: dimenssionless parameter'; %help text
    handles.calib_param2_text.String = 'Cp:';
    handles.calib_param2_text.TooltipString = 'Cp: dimenssionless parameter'; %help text  
    
elseif SUH_method == 4
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_calibration.Name = 'SUnHyT - Calibration - Zoch`s method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    
    handles.initi_param1.Enable = 'on';
    handles.initi_param2.Enable = 'off';
    handles.initi_param1_text.Enable = 'on';
    handles.initi_param2_text.Enable = 'off';
    handles.initi_param1_text.String = 'k0:';
    handles.initi_param1_text.TooltipString = ['k0: first value for reservoir decay [dt]',char(10)...
                                               ,'(e.g. if dt = 3600s, then k0 = 1 is equivalent to 3600s)']; %help text
    
    % Calibration intervals
    handles.p2_uipanel.Visible = 'off';
    handles.calib_param1_text.String = 'k:';
    handles.calib_param1_text.TooltipString = ['k: reservoir decay [dt]',char(10)...
                                               ,'(e.g. if dt = 3600s, then k = 1 is equivalent to 3600s)']; %help text
    
elseif SUH_method == 5
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_calibration.Name = 'SUnHyT - Calibration - Nash`s method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    
    handles.initi_param1.Enable = 'on';
    handles.initi_param2.Enable = 'on';
    handles.initi_param1_text.Enable = 'on';
    handles.initi_param2_text.Enable = 'on';
    handles.initi_param1_text.String = 'n0:';
    handles.initi_param1_text.TooltipString = 'n0: first value for number of reservoirs'; %help text
    handles.initi_param2_text.String = 'k0:';
    handles.initi_param2_text.TooltipString = ['k0: first value for reservoir decay [dt]',char(10)...
                                               ,'(e.g. if dt = 3600s, then k0 = 1 is equivalent to 3600s)']; %help text
    
    % Calibration intervals
    handles.p2_uipanel.Visible = 'on';
    
    handles.calib_param1_text.String = 'n:';
    handles.calib_param1_text.TooltipString = 'n: number of reservoirs'; %help text
    handles.calib_param2_text.String = 'k:';
    handles.calib_param2_text.TooltipString = ['k: reservoir decay [dt]',char(10)...
                                               ,'(e.g. if dt = 3600s, then k0 = 1 is equivalent to 3600s)']; %help text
    
elseif SUH_method == 6
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_calibration.Name = 'SUnHyT - Calibration - TwoParLn method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    
    handles.initi_param1.Enable = 'on';
    handles.initi_param2.Enable = 'on';
    handles.initi_param1_text.Enable = 'on';
    handles.initi_param2_text.Enable = 'on';
    handles.initi_param1_text.String = 'p1_0:';
    handles.initi_param1_text.TooltipString = ['p1_0: first value for shape parameter',char(10)...
                                              ,'(is the standard deviation of the log of the distribution)(p1_0>0)'];
    handles.initi_param2_text.String = 'p2_0:';
    handles.initi_param2_text.TooltipString = ['p2_0: first value for mean of the',char(10)...
                                              ,'log of the distribution'];
    
    % Calibration intervals
    handles.p2_uipanel.Visible = 'on';
    
    handles.calib_param1_text.String = 'p1:';
    handles.calib_param1_text.TooltipString = ['p1: shape parameter',char(10)...
                                              ,'(is the standard deviation of the log of the distribution)(p1>0)'];
    handles.calib_param2_text.String = 'p2:';
    handles.calib_param2_text.TooltipString = ['p2: mean of the log of the distribution'];
    
elseif SUH_method == 7
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Not applicable';
    handles.figure_calibration.Name = 'SUnHyT - Calibration - TwoParGama method';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';
    
    handles.initi_param1.Enable = 'on';
    handles.initi_param2.Enable = 'on';
    handles.initi_param1_text.Enable = 'on';
    handles.initi_param2_text.Enable = 'on';
    handles.initi_param1_text.String = 'p1_0:';
    handles.initi_param1_text.TooltipString = 'p1_0: first value for scale parameter';
    handles.initi_param2_text.String = 'p2_0:';
    handles.initi_param2_text.TooltipString = 'p2_0: first value for shape parameter (p2_0>0)';
    
    % Calibration intervals
    handles.p2_uipanel.Visible = 'on';
    
    handles.calib_param1_text.String = 'p1:';
    handles.calib_param1_text.TooltipString = 'p1: scale parameter'; 
    handles.calib_param2_text.String = 'p2:';
    handles.calib_param2_text.TooltipString = 'p2: shape parameter (p2>0)';
    
elseif SUH_method == 8
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Geomorphological properties';
    handles.figure_calibration.Name = 'SUnHyT - Calibration - Rodriguez-Iturbé`s method';
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
    
    handles.initi_param1.Enable = 'on';
    handles.initi_param2.Enable = 'off';
    handles.initi_param1_text.Enable = 'on';
    handles.initi_param2_text.Enable = 'off';
    handles.initi_param1_text.String = 'v0:';
    handles.initi_param1_text.TooltipString = ['v0: first value for hydrodynamic factor flow velocity [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a v0 = 1 is equivalent to 1/3600 = 0.00028 m/s'];
    
      % Calibration intervals
    handles.p2_uipanel.Visible = 'off';
    
    handles.calib_param1_text.String = 'v:';
    handles.calib_param1_text.TooltipString = ['v: hydrodynamic factor flow velocity [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a v = 1 is equivalent to 1/3600 = 0.00028 m/s'];
    
elseif SUH_method == 9
    handles.input_f_accumulation.Visible = 'off';
    handles.input_f_direction.Visible = 'off';
    handles.SUH_title_uipanel.Title = 'Geomorphological properties';
    handles.figure_calibration.Name = 'SUnHyT - Calibration - Rosso`s method';
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
    
    handles.initi_param1.Enable = 'on';
    handles.initi_param2.Enable = 'off';
    handles.initi_param1_text.Enable = 'on';
    handles.initi_param2_text.Enable = 'off';
    handles.initi_param1_text.String = 'v0:';
    handles.initi_param1_text.TooltipString = ['v0: first value for hydrodynamic factor flow velocity [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a v0 = 1 is equivalent to 1/3600 = 0.00028 m/s'];
    
      % Calibration intervals
    handles.p2_uipanel.Visible = 'off';
    
    handles.calib_param1_text.String = 'v:';
    handles.calib_param1_text.TooltipString = ['v: hydrodynamic factor flow velocity [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a v = 1 is equivalent to 1/3600 = 0.00028 m/s'];
    
elseif SUH_method == 10
    handles.input_f_accumulation.Visible = 'on';
    handles.input_f_direction.Visible = 'on';
    handles.figure_calibration.Name = 'SUnHyT - Calibration - Kirkby`s method';
    handles.SUH_title_uipanel.Title = 'Not applicable';
%     handles.SUH_param1_text.Visible = 'on';
%     handles.SUH_param1.Visible = 'on';
%     handles.SUH_param2_text.Visible = 'on';
%     handles.SUH_param2.Visible = 'on';
%     handles.SUH_param3_text.Visible = 'on';
%     handles.SUH_param3.Visible = 'on';
%     handles.SUH_param4_text.Visible = 'on';
%     handles.SUH_param4.Visible = 'on';
    handles.SUH_param1_text.Enable = 'off';
    handles.SUH_param1.Enable = 'off';
    handles.SUH_param2_text.Enable = 'off';
    handles.SUH_param2.Enable = 'off';
    handles.SUH_param3_text.Enable = 'off';
    handles.SUH_param3.Enable = 'off';
    handles.SUH_param4_text.Enable = 'off';
    handles.SUH_param4.Enable = 'off';    
    
    handles.initi_param1.Enable = 'on';
    handles.initi_param2.Enable = 'on';
    handles.initi_param1_text.Enable = 'on';
    handles.initi_param2_text.Enable = 'on';
    
    handles.initi_param1_text.String = 'vr0:';
    handles.initi_param1_text.TooltipString = ['vr0: first value for average velocity of river [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a vr0 = 1 is equivalent to 1/3600 = 0.00028 m/s'];
    handles.initi_param2_text.String = 'vh0:';
    handles.initi_param2_text.TooltipString = ['vh0: first value for average velocity of hillslope [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a vh0 = 1 is equivalent to 1/3600 = 0.00028 m/s'];
    
    % Calibration intervals
    handles.p2_uipanel.Visible = 'on';
    
    handles.calib_param1_text.String = 'vr:';
    handles.calib_param1_text.TooltipString = ['vr: average velocity of river [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a vr = 1 is equivalent to 1/3600 = 0.00028 m/s'];
    handles.calib_param2_text.String = 'vh:';
    handles.calib_param2_text.TooltipString = ['vh: average velocity of hillslope [m/dt]',char(10)...
                                               ,'(e.g. if dt = 3600 then a vh = 1 is equivalent to 1/3600 = 0.00028 m/s'];
  
end
% Choose default command line output for Calibration_guide
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Calibration_guide wait for user response (see UIRESUME)
% uiwait(handles.figure_calibration);


% --- Outputs from this function are returned to the command line.
function varargout = Calibration_guide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_calib_button.
function start_calib_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_calib_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of start_calib_button
global CN_calib Ia_calib SUH_method BF_flag BF_method BF_a BF_bfi area dt stat x_par obj_val P1_text P2_text bt inp_event inp_fac inp_fdr calib_flag valid_flag ungauged_flag;

calib_flag = 1;
valid_flag = 0;
ungauged_flag = 0;

if inp_event == 0 && SUH_method ~= 10
    msgbox('Make sure you have loaded the input data');
    return
end

handles.view_results_button.Enable = 'off';
load('data\data_base\Calibration\temp\Evento_calib','Evento');

%Baseflow separation filter
%x = -9999999999;

if BF_flag == 1
    if BF_method == 2      % Lyne and Hollick method
        if isempty(handles.BF_a_param.String)==0
            a = str2num(handles.BF_a_param.String); % Parameter
            BF_a = handles.BF_a_param.String;
            Evento(1,3)=Evento(1,2);
            for ii=2:size(Evento,1)
                if isnan(Evento(ii,2))
                    Evento(ii,3) = NaN;
                else
                    value = ((a*Evento(ii-1,3))+(((1-a)./2)*(Evento(ii,2)+Evento(ii-1,2))));
                    if value <= Evento(ii,2)
                        Evento(ii,3)=value;
                    else
                        Evento(ii,3)=Evento(ii,2);
                    end
                end
                Evento(:,4)=Evento(:,2)-Evento(:,3);
            end
        else
            msgbox('Make sure you have entered the "a" parameter.')
            return;
        end
        
    elseif BF_method == 3  % Chapman and Maxwell method
        if isempty(handles.BF_a_param.String)==0 
            a = str2num(handles.BF_a_param.String); % a - Parameter
            BF_a = handles.BF_a_param.String;
            Evento(1,3)=Evento(1,2);
            for i1 = 2:size(Evento,1)
                if isnan(Evento(i1,2))
                    Evento(i1,3) = NaN;
                else
                    value = (a/(2-a))*Evento(i1-1,3) + ((1-a)/(2-a))*Evento(i1,2);
                    if value <= Evento(i1,2)
                        Evento(i1,3)=value;
                    else
                        Evento(i1,3)=Evento(i1,2);
                    end
                end
                Evento(:,4)=Evento(:,2)-Evento(:,3);
            end
        else
            msgbox('Make sure you have entered the "a" parameter.')
            return;
        end
        
    elseif BF_method == 4  % Eckhardt method
                
        if isempty(handles.BF_a_param.String)==0 && isempty(handles.BF_bfi_param.String)==0
        %ECKHARDT, K. How to construct recursive digital filters for baseflow separation.
        %Hydrological Processes, v. 19, n. 1, p. 507–515, 2005.
        a = str2num(handles.BF_a_param.String);     % a - Parameter
        BFI = str2num(handles.BF_bfi_param.String); % BFI - parameter
        BF_a = handles.BF_a_param.String;
        BF_bfi = handles.BF_bfi_param.String;
        Evento(1,3)= Evento(1,2);
        for i=2:size(Evento,1)
            value=(((1-BFI)*a*Evento(i-1,3))+((1-a)*BFI*Evento(i,2)))/(1-(a*BFI));
            if value<=Evento(i,2)
                Evento(i,3)=value;
            else
                Evento(i,3)=Evento(i,2);
            end
        end
        Evento(:,4)=Evento(:,2)-Evento(:,3);
        else
        msgbox('Make sure you have entered the "a" and "BFI" parameters.')
        return;
        end        
    end
else
    Evento(:,3) = 0;%Evento(:,2);
    Evento(:,4) = Evento(:,2)-Evento(1,2);
end

[bt]=basetime(Evento);

[CN_calib,Ia_calib,PMatrix,Evento]=CN_(Evento,area,dt);

if isdir('data\data_base\Calibration\temp\')==0
    mkdir('data\data_base\Calibration\temp\');
end

save('data\data_base\Calibration\temp\PMatrix','PMatrix');
save('data\data_base\Calibration\temp\Evento','Evento');

if SUH_method==2
    if isempty(handles.initi_param1.String)==1 || isempty(handles.initi_param2.String)==1 || isempty(handles.calib_param1_in.String)==1 || isempty(handles.calib_param1_fin.String)==1 || isempty(handles.calib_param2_in.String)==1 || isempty(handles.calib_param2_fin.String)==1
        msgbox('Make sure you have entered the calibration range')
        return;
    end
    P1_text = handles.calib_param1_text.String;
    P2_text = handles.calib_param2_text.String;
    
    stat = [];
    p1m = str2num(handles.initi_param1.String);
    p2m = str2num(handles.initi_param2.String);
    Pa = [p1m p2m];%
    [x,fval] = fminsearchbnd('Mockus',Pa,[str2num(handles.calib_param1_in.String) str2num(handles.calib_param2_in.String)],[str2num(handles.calib_param1_fin.String) str2num(handles.calib_param2_fin.String)]);
    
elseif SUH_method==3
    if isempty(handles.initi_param1.String)==1 || isempty(handles.initi_param2.String)==1 || isempty(handles.calib_param1_in.String)==1 || isempty(handles.calib_param1_fin.String)==1 || isempty(handles.calib_param2_in.String)==1 || isempty(handles.calib_param2_fin.String)==1
        msgbox('Make sure you have entered the calibration range')
        return;
    end
    if isempty(handles.SUH_param1.String)==0 && isempty(handles.SUH_param2.String)==0
        P1_text = handles.calib_param1_text.String;
        P2_text = handles.calib_param2_text.String;
        
        stat = [];
        p1m = str2num(handles.initi_param1.String);
        p2m = str2num(handles.initi_param2.String);
        Pa = [p1m p2m];%
        P_Fisi=[str2num(handles.SUH_param1.String) str2num(handles.SUH_param2.String)]; %Physical parameters=[L Lc]
        if isdir('data\data_base\Calibration\temp\')==0
            mkdir('data\data_base\Calibration\temp\');
        end
        save('data\data_base\Calibration\temp\P_Fisi','P_Fisi');
        [x,fval] = fminsearchbnd('Snyder',Pa,[str2num(handles.calib_param1_in.String) str2num(handles.calib_param2_in.String)],[str2num(handles.calib_param1_fin.String) str2num(handles.calib_param2_fin.String)]);
    else
        msgbox('Make sure you have entered all the physical parameters.')
        return;
    end
elseif SUH_method==4
    if isempty(handles.initi_param1.String)==1 || isempty(handles.calib_param1_in.String)==1 || isempty(handles.calib_param1_fin.String)==1 
        msgbox('Make sure you have entered the calibration range')
        return;
    end
    P1_text = handles.calib_param1_text.String;
    
    stat = [];
    p1m = str2num(handles.initi_param1.String);
    Pa = [p1m];%
    [x,fval] = fminsearchbnd('Zoch',Pa,str2num(handles.calib_param1_in.String),str2num(handles.calib_param1_fin.String));
elseif SUH_method==5
    if isempty(handles.initi_param1.String)==1 || isempty(handles.initi_param2.String)==1 || isempty(handles.calib_param1_in.String)==1 || isempty(handles.calib_param1_fin.String)==1 || isempty(handles.calib_param2_in.String)==1 || isempty(handles.calib_param2_fin.String)==1
        msgbox('Make sure you have entered the calibration range')
        return;
    end
    P1_text = handles.calib_param1_text.String;
    P2_text = handles.calib_param2_text.String;
    
    stat = [];
    p1m = str2num(handles.initi_param1.String);
    p2m = str2num(handles.initi_param2.String);
    Pa = [p1m p2m];%
    [x,fval] = fminsearchbnd('Nash',Pa,[str2num(handles.calib_param1_in.String) str2num(handles.calib_param2_in.String)],[str2num(handles.calib_param1_fin.String) str2num(handles.calib_param2_fin.String)]);
elseif SUH_method==6
    if isempty(handles.initi_param1.String)==1 || isempty(handles.initi_param2.String)==1 || isempty(handles.calib_param1_in.String)==1 || isempty(handles.calib_param1_fin.String)==1 || isempty(handles.calib_param2_in.String)==1 || isempty(handles.calib_param2_fin.String)==1
        msgbox('Make sure you have entered the calibration range')
        return;
    end
    P1_text = handles.calib_param1_text.String;
    P2_text = handles.calib_param2_text.String;
    
    stat = [];
    p1m = str2num(handles.initi_param1.String);
    p2m = str2num(handles.initi_param2.String);
    Pa = [p1m p2m];%
    [x,fval] = fminsearchbnd('TwoParLn',Pa,[str2num(handles.calib_param1_in.String) str2num(handles.calib_param2_in.String)],[str2num(handles.calib_param1_fin.String) str2num(handles.calib_param2_fin.String)]);
elseif SUH_method==7    
    if isempty(handles.initi_param1.String)==1 || isempty(handles.initi_param2.String)==1 || isempty(handles.calib_param1_in.String)==1 || isempty(handles.calib_param1_fin.String)==1 || isempty(handles.calib_param2_in.String)==1 || isempty(handles.calib_param2_fin.String)==1
        msgbox('Make sure you have entered the calibration range')
        return;
    end
    
    P1_text = handles.calib_param1_text.String;
    P2_text = handles.calib_param2_text.String;
    
    stat = [];
    p1m = str2num(handles.initi_param1.String);
    p2m = str2num(handles.initi_param2.String);
    Pa =  [p1m p2m];%
    [x,fval] = fminsearchbnd('TwoParGamma',Pa,[str2num(handles.calib_param1_in.String) str2num(handles.calib_param2_in.String)],[str2num(handles.calib_param1_fin.String) str2num(handles.calib_param2_fin.String)]);
elseif SUH_method==8
    if isempty(handles.initi_param1.String)==1 || isempty(handles.calib_param1_in.String)==1 || isempty(handles.calib_param1_fin.String)==1 
        msgbox('Make sure you have entered the calibration range')
        return;
    end
    if isempty(handles.SUH_param1.String)==0 && isempty(handles.SUH_param2.String)==0 && isempty(handles.SUH_param3.String)==0 && isempty(handles.SUH_param4.String)==0
        
        P1_text = handles.calib_param1_text.String;
        
        stat = [];
        p1m = str2num(handles.initi_param1.String);
        Pa = [p1m];%
        Law=[str2num(handles.SUH_param1.String) str2num(handles.SUH_param2.String) str2num(handles.SUH_param3.String) str2num(handles.SUH_param4.String)];        %Geomorphological informations=[L Rl Rb Ra];
        if isdir('data\data_base\Calibration\temp\')==0
            mkdir('data\data_base\Calibration\temp\');
        end
        save('data\data_base\Calibration\temp\Law','Law');
        [x,fval] = fminsearchbnd('Rodriguez',Pa,str2num(handles.calib_param1_in.String),str2num(handles.calib_param1_fin.String));
    else
        msgbox('Make sure you have entered all the geomorphological properties.')
        return;
    end
elseif SUH_method==9
    if isempty(handles.initi_param1.String)==1 || isempty(handles.calib_param1_in.String)==1 || isempty(handles.calib_param1_fin.String)==1 
        msgbox('Make sure you have entered the calibration range')
        return;
    end
    if isempty(handles.SUH_param1.String)==0 && isempty(handles.SUH_param2.String)==0 && isempty(handles.SUH_param3.String)==0 && isempty(handles.SUH_param4.String)==0
        P1_text = handles.calib_param1_text.String;
        
        stat = [];
        p1m = str2num(handles.initi_param1.String);
        Pa = [p1m];%
        Law=[str2num(handles.SUH_param1.String) str2num(handles.SUH_param2.String) str2num(handles.SUH_param3.String) str2num(handles.SUH_param4.String)];        %Geomorphological informations=[L Rl Rb Ra];
        if isdir('data\data_base\Calibration\temp\')==0
            mkdir('data\data_base\Calibration\temp\');
        end
        save('data\data_base\Calibration\temp\Law','Law');
        [x,fval] = fminsearchbnd('Rosso',Pa,str2num(handles.calib_param1_in.String),str2num(handles.calib_param1_fin.String));
        
    else
        msgbox('Make sure you have entered all the geomorphological properties.')
        return;
    end
elseif SUH_method==10
    if isempty(handles.initi_param1.String)==1 || isempty(handles.initi_param2.String)==1 || isempty(handles.calib_param1_in.String)==1 || isempty(handles.calib_param1_fin.String)==1 || isempty(handles.calib_param2_in.String)==1 || isempty(handles.calib_param2_fin.String)==1
        msgbox('Make sure you have entered the calibration range')
        return;
    end
    if inp_event == 1 && inp_fac == 1 && inp_fdr == 1
        P1_text = handles.calib_param1_text.String;
        P2_text = handles.calib_param2_text.String;
        
        stat = [];
        prompt = {'Enter Treshold of area (number of cells) to drainage formation'};
        dlgtitle = 'Input';
        dims = [1 35];
        %definput = {'20','hsv'};
        answer = inputdlg(prompt,dlgtitle,dims);%,definput)
        if isempty(answer)==0 && isequal(answer,{''}) == 0
            tr = str2num(char(answer));
            if isdir('data\data_base\Calibration\temp\')==0
                mkdir('data\data_base\Calibration\temp\');
            end
            save('data\data_base\Calibration\temp\tr','tr');
            [river,hill]=distance;                %Define river and hillslope
            save('data\data_base\Calibration\temp\river','river'); save('data\data_base\Calibration\temp\hill','hill');
            
            p1m = str2num(handles.initi_param1.String);
            p2m = str2num(handles.initi_param2.String);
            Pa = [p1m p2m];%
            [x,fval] = fminsearchbnd('Kirkby',Pa,[str2num(handles.calib_param1_in.String) str2num(handles.calib_param2_in.String)],[str2num(handles.calib_param1_fin.String) str2num(handles.calib_param2_fin.String)]);
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
    load('data\data_base\Calibration\temp\Hidrograma','Hidrograma')%[mm]
    [Evento,Hidrograma] = unit_converter(Evento,Hidrograma,area,dt); % outputs: [L/s]
    
    if BF_flag == 0
        Hidrograma = Hidrograma+Evento(1,2);
    end    
    Evento(:,4) = Hidrograma;
    
    if isdir('data\data_base\Calibration\Results\')==0
        mkdir('data\data_base\Calibration\Results\');
    end
    
    save('data\data_base\Calibration\Results\Evento','Evento');
    save('data\data_base\Calibration\Results\Hidrograma','Hidrograma');
    
    x_par = x;
    obj_val = -fval;
%end




% --- Executes on button press in view_results_button.
function view_results_button_Callback(hObject, eventdata, handles)
% hObject    handle to view_results_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global calib_flag valid_flag ungauged_flag; 
calib_flag = 1;
valid_flag = 0;
ungauged_flag = 0;

guide_results;
% Hint: get(hObject,'Value') returns toggle state of view_results_button



% --- Executes on button press in next_button.
function next_button_Callback(hObject, eventdata, handles)
% hObject    handle to next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of next_button
global sum_action check_ungauged check_valid;

if sum_action > 1
    if check_valid == 1
        Validation_guide;
    elseif check_ungauged == 1
        Ungauged_guide;
    end 
    
elseif sum_action == 1
    close();    
end



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



function BF_bfi_param_Callback(hObject, eventdata, handles)
% hObject    handle to BF_bfi_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BF_bfi_param as text
%        str2double(get(hObject,'String')) returns contents of BF_bfi_param as a double


% --- Executes during object creation, after setting all properties.
function BF_bfi_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BF_bfi_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BF_a_param_Callback(hObject, eventdata, handles)
% hObject    handle to BF_a_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BF_a_param as text
%        str2double(get(hObject,'String')) returns contents of BF_a_param as a double


% --- Executes during object creation, after setting all properties.
function BF_a_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BF_a_param (see GCBO)
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
global inp_event calib_flag valid_flag ungauged_flag;
inp_event = 0;

calib_flag = 1;
valid_flag = 0;
ungauged_flag = 0;

[filename, pathname, filterindex] = uigetfile( ...
       {'*.txt*','text editor (*.txt)'}, ...
        'Pick a file', ...
        'MultiSelect', 'on');       
 
if filename ~= 0 
    
    sp = strsplit(filename,'.');
    nameDataFile = sp(1);
     
    %Evento = textread([pathname,filename],'headerlines',2);
    
    event_open = fopen([pathname filename], 'rt');
    cell_event = textscan(event_open, '%f %f%*[^\n]', 'headerlines', 1);
    Evento =[cell_event{1} cell_event{2}];    
    fclose(event_open);
    
    if isdir('data\data_base\Calibration\temp\')==0
        mkdir('data\data_base\Calibration\temp\');
    end   
    
    save('data\data_base\Calibration\temp\Evento_calib','Evento');    
    f = figure('Name','Input data','Position',[400 50 300 550]);
    t = uitable(f,'ColumnName', {'Rainfall [mm]' 'Runoff [m^3/s]'},'ColumnWidth',{110},'Position',[10 10 290 540]);
    set(t,'data',Evento(:,1:2))
    
    handles.axes2.Visible = 'on';
    axes(handles.axes2)
    matlabImage = imread('tick.png');
    imshow(matlabImage)
    axis off
    axis image
    inp_event = 1;


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
global inp_fac valid_flag calib_flag ungauged_flag;
inp_fac = 0;
valid_flag = 0;
calib_flag = 1;
ungauged_flag = 0;
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

inp_fac = 1;
handles.axes3.Visible = 'on';
axes(handles.axes3)
matlabImage = imread('tick.png');
imshow(matlabImage)
axis off
axis image

if isdir('data\data_base\Calibration\temp\')==0
    mkdir('data\data_base\Calibration\temp\');
end
save('data\data_base\Calibration\temp\fac','fac'); save('data\data_base\Calibration\temp\R','R');

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
global inp_fdr valid_flag calib_flag ungauged_flag;
inp_fdr = 0;
valid_flag = 0;
calib_flag = 1;
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

inp_fdr = 1;
handles.axes4.Visible = 'on';
axes(handles.axes4)
matlabImage = imread('tick.png');
imshow(matlabImage)
axis off
axis image

if isdir('data\data_base\Calibration\temp\')==0
    mkdir('data\data_base\Calibration\temp\');
end
save('data\data_base\Calibration\temp\fdr','fdr'); 

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



function calib_param2_fin_Callback(hObject, eventdata, handles)
% hObject    handle to calib_param2_fin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calib_param2_fin as text
%        str2double(get(hObject,'String')) returns contents of calib_param2_fin as a double


% --- Executes during object creation, after setting all properties.
function calib_param2_fin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calib_param2_fin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function calib_param2_in_Callback(hObject, eventdata, handles)
% hObject    handle to calib_param2_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calib_param2_in as text
%        str2double(get(hObject,'String')) returns contents of calib_param2_in as a double


% --- Executes during object creation, after setting all properties.
function calib_param2_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calib_param2_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function calib_param1_in_Callback(hObject, eventdata, handles)
% hObject    handle to calib_param1_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calib_param1_in as text
%        str2double(get(hObject,'String')) returns contents of calib_param1_in as a double


% --- Executes during object creation, after setting all properties.
function calib_param1_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calib_param1_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function calib_param1_fin_Callback(hObject, eventdata, handles)
% hObject    handle to calib_param1_fin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calib_param1_fin as text
%        str2double(get(hObject,'String')) returns contents of calib_param1_fin as a double


% --- Executes during object creation, after setting all properties.
function calib_param1_fin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calib_param1_fin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initi_param2_Callback(hObject, eventdata, handles)
% hObject    handle to initi_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initi_param2 as text
%        str2double(get(hObject,'String')) returns contents of initi_param2 as a double


% --- Executes during object creation, after setting all properties.
function initi_param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initi_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initi_param1_Callback(hObject, eventdata, handles)
% hObject    handle to initi_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initi_param1 as text
%        str2double(get(hObject,'String')) returns contents of initi_param1 as a double


% --- Executes during object creation, after setting all properties.
function initi_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initi_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
