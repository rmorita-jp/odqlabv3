function varargout = system_setup_G(varargin)
% SYSTEM_SETUP_G M-file for system_setup_G.fig
%      SYSTEM_SETUP_G, by itself, creates a new SYSTEM_SETUP_G or raises the existing
%      singleton*.
%
%      H = SYSTEM_SETUP_G returns the handle to a new SYSTEM_SETUP_G or the handle to
%      the existing singleton*.
%
%      SYSTEM_SETUP_G('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYSTEM_SETUP_G.M with the given input arguments.
%
%      SYSTEM_SETUP_G('Property','Value',...) creates a new SYSTEM_SETUP_G or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before system_setup_G_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to system_setup_G_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help system_setup_G

% Last Modified by GUIDE v2.5 08-Jan-2010 18:00:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @system_setup_G_OpeningFcn, ...
                   'gui_OutputFcn',  @system_setup_G_OutputFcn, ...
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


% --- Executes just before system_setup_G is made visible.
function system_setup_G_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to system_setup_G (see VARARGIN)

% Choose default command line output for system_setup_G
handles.output = hObject;

odqgui_input = find(strcmp(varargin, 'ODQ_Designer'));
if ~isempty(odqgui_input)
    handles.odq_design = varargin{odqgui_input+1};
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes system_setup_G wait for user response (see UIRESUME)
% uiwait(handles.systemG);
odqdata=get(handles.odq_design,'UserData');
if isfield(odqdata,'G')
    G=odqdata.G;
    if isstruct(G)
        textG=odqdata.textG;
        if isfield(G,'a')
            set(handles.edit_A ,'String',textG.a);
        end
        if isfield(G,'b1')
            set(handles.edit_B1,'String',textG.b1);
        end
        if isfield(G,'b2')
            set(handles.edit_B2,'String',textG.b2);
        end
        if isfield(G,'c1')
            set(handles.edit_C1,'String',textG.c1);
        end
        if isfield(G,'c2')
            set(handles.edit_C2,'String',textG.c2);
        end
        if isfield(G,'d1')
            set(handles.edit_D1,'String',textG.d1);
        end
        if isfield(G,'d2')
            set(handles.edit_D2,'String',textG.d2);
        end
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = system_setup_G_OutputFcn(hObject, eventdata, handles) 
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
tmp_para.c1=get(handles.edit_C1,'String');
tmp_para.c2=get(handles.edit_C2,'String');
tmp_para.d1=get(handles.edit_D1,'String');
tmp_para.d2=get(handles.edit_D2,'String');

parameters.a =evalin('base',tmp_para.a);
parameters.b1=evalin('base',tmp_para.b1);
parameters.b2=evalin('base',tmp_para.b2);
parameters.c1=evalin('base',tmp_para.c1);
parameters.c2=evalin('base',tmp_para.c2);
parameters.d1=evalin('base',tmp_para.d1);
parameters.d2=evalin('base',tmp_para.d2);
odqdata.G=parameters;
odqdata.textG=tmp_para;
set(handles.odq_design,'UserData',odqdata)
close


% --- Executes on button press in cancel_button.
function cancel_button_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odqdata=get(handles.odq_design,'UserData');
if ~isfield(odqdata,'G')
    odqdata.G='canceled';
end
set(handles.odq_design,'UserData',odqdata)
close
