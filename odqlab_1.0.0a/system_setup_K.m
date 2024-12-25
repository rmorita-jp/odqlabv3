function varargout = system_setup_K(varargin)
% SYSTEM_SETUP_K M-file for system_setup_K.fig
%      SYSTEM_SETUP_K, by itself, creates a new SYSTEM_SETUP_K or raises the existing
%      singleton*.
%
%      H = SYSTEM_SETUP_K returns the handle to a new SYSTEM_SETUP_K or the handle to
%      the existing singleton*.
%
%      SYSTEM_SETUP_K('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYSTEM_SETUP_K.M with the given input arguments.
%
%      SYSTEM_SETUP_K('Property','Value',...) creates a new SYSTEM_SETUP_K or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before system_setup_K_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to system_setup_K_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help system_setup_K

% Last Modified by GUIDE v2.5 08-Jan-2010 21:31:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @system_setup_K_OpeningFcn, ...
                   'gui_OutputFcn',  @system_setup_K_OutputFcn, ...
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


% --- Executes just before system_setup_K is made visible.
function system_setup_K_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to system_setup_K (see VARARGIN)

% Choose default command line output for system_setup_K
handles.output = hObject;

odqgui_input = find(strcmp(varargin, 'ODQ_Designer'));
if ~isempty(odqgui_input)
    handles.odq_design = varargin{odqgui_input+1};
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes system_setup_K wait for user response (see UIRESUME)
% uiwait(handles.systemG);
odqdata=get(handles.odq_design,'UserData');
if isfield(odqdata,'K')
    K=odqdata.K;
    if isstruct(K)
        textK=odqdata.textK;
        if isfield(K,'a')
            set(handles.edit_A ,'String',textK.a);
        end
        if isfield(K,'b1')
            set(handles.edit_B1,'String',textK.b1);
        end
        if isfield(K,'b2')
            set(handles.edit_B2,'String',textK.b2);
        end
        if isfield(K,'c')
            set(handles.edit_C ,'String',textK.c);
        end
        if isfield(K,'d1')
            set(handles.edit_D1,'String',textK.d1);
        end
        if isfield(K,'d2')
            set(handles.edit_D2,'String',textK.d2);
        end
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = system_setup_K_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odqdata=get(handles.odq_design,'UserData');

tmp_para.a =get(handles.edit_A ,'String');
tmp_para.b1=get(handles.edit_B1,'String');
tmp_para.b2=get(handles.edit_B2,'String');
tmp_para.c =get(handles.edit_C,'String');
tmp_para.d1=get(handles.edit_D1,'String');
tmp_para.d2=get(handles.edit_D2,'String');

parameters.a =evalin('base',tmp_para.a);
parameters.b1=evalin('base',tmp_para.b1);
parameters.b2=evalin('base',tmp_para.b2);
parameters.c =evalin('base',tmp_para.c);
parameters.d1=evalin('base',tmp_para.d1);
parameters.d2=evalin('base',tmp_para.d2);
odqdata.K=parameters;
odqdata.textK=tmp_para;
set(handles.odq_design,'UserData',odqdata)
close


% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odqdata=get(handles.odq_design,'UserData');
if ~isfield(odqdata,'K')
    odqdata.K='canceled';
end
set(handles.odq_design,'UserData',odqdata)
close
