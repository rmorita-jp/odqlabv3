function varargout = odqlab(varargin)
%ODQLAB M-file for odqlab.fig
%      ODQLAB, by itself, creates a new ODQLAB or raises the existing
%      singleton*.
%
%      H = ODQLAB returns the handle to a new ODQLAB or the handle to
%      the existing singleton*.
%
%      ODQLAB('Property','Value',...) creates a new ODQLAB using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to odqlab_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      ODQLAB('CALLBACK') and ODQLAB('CALLBACK',hObject,...) call the
%      local function named CALLBACK in ODQLAB.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help odqlab

% Last Modified by GUIDE v2.5 29-Nov-2024 16:18:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @odqlab_OpeningFcn, ...
                   'gui_OutputFcn',  @odqlab_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before odqlab is made visible.
function odqlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for odqlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes odqlab wait for user response (see UIRESUME)
% uiwait(handles.odq_design);
odqdata.flg.ODQopen=1;
odqdata.connection='ff';
set(handles.odq_design,'UserData',odqdata);


% --- Outputs from this function are returned to the command line.
function varargout = odqlab_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit_T_Callback(hObject, eventdata, handles)
% hObject    handle to edit_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_T as text
%        str2double(get(hObject,'String')) returns contents of edit_T as a double
T=str2double(get(hObject,'String'));
set(handles.slider_T,'Value',T)
set(hObject,'UserData',T)


function edit_d_Callback(hObject, eventdata, handles)
% hObject    handle to edit_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_d as text
%        str2double(get(hObject,'String')) returns contents of edit_d as a double
d=str2double(get(hObject,'String'));
set(handles.slider_d,'Value',d)
set(hObject,'UserData',d)


function edit_uv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_uv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_uv as text
%        str2double(get(hObject,'String')) returns contents of edit_uv as a double
gamma.uv=str2double(get(hObject,'String'));
set(hObject,'UserData',gamma.uv)


% --- Executes during object creation, after setting all properties.
function edit_uv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_uv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
gamma.uv=inf;
set(hObject,'string',gamma.uv,'UserData',gamma.uv);


function edit_wv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_wv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_wv as text
%        str2double(get(hObject,'String')) returns contents of edit_wv as a double
gamma.wv=str2double(get(hObject,'String'));
set(hObject,'UserData',gamma.wv)


% --- Executes during object creation, after setting all properties.
function edit_wv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_wv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
gamma.wv=inf;
set(hObject,'string',gamma.wv,'UserData',gamma.wv);


% --- Executes when selected object is changed in connection.
function connection_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in connection 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
odqdata=get(handles.odq_design,'UserData');
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton_ff'
        con='ff';
    case 'radiobutton_fbiq'
        con='fbiq';
    case 'radiobutton_fboq'
        con='fboq';
    case 'radiobutton_GQ'
        con='GQ';
    % Continue with more cases as necessary.
    otherwise
       con='null';
end
odqdata.connection=con;
set(handles.connection,'UserData',con) %remove the case "hObject=radiobuttonx"
set(handles.odq_design,'UserData',odqdata)


% --- Executes during object creation, after setting all properties.
function connection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to connection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
con='ff';
set(hObject,'UserData',con)


% --- Executes on button press in excute_button.
function excute_button_Callback(hObject, eventdata, handles)
% hObject    handle to excute_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odqdata=get(handles.odq_design,'UserData');
flg=odqdata.flg;
if isfield(flg,'DQopen')==1
    if flg.DQopen==1
        delete(handles.DQ)
        flg.DQopen=0;
    end
end
con=get(handles.connection,'UserData');
if strcmp(con,'GQ')
    % G=get(handles.import_G,'UserData');
    G=odqdata.G;
else
    P=odqdata.P;
    % P=get(handles.import_P,'UserData');
    if strcmp(con,'ff')
        K=[];
    else
        % K=get(handles.import_K,'UserData');
        K=odqdata.K;
    end
    G=compg(P,K,con);
end
T=get(handles.edit_T,'UserData');
d=get(handles.edit_d,'UserData');
dim=get(handles.edit_sv,'UserData');
gamma.wv=get(handles.edit_wv,'UserData');
solver=get(handles.solvers,'UserData');
if size(G.c1*G.b2,2)<size(G.c1*G.b2,1) && T==inf
    hint=textwrap(handles.message_area,{'Could not derive analytic solution.',...
        'Please set Evaluation time for numerical optimization'});
    set(handles.message_area,'string',hint);
else
    if isnan(dim)
    [Q E Hk gain]=odq(G,T,d,gamma,[],solver);
    else
    [Q E Hk gain]=odq(G,T,d,gamma,dim,solver);
    end
    stb=odqstb(Q);
    odqdata.Q=Q;
    odqdata.E=E;
    odqdata.Hk=Hk;
    odqdata.gain=gain;
    odqdata.G=G;
    odqdata.d=d;
    set(handles.odq_design,'UserData',odqdata)

    if stb==0
        hint=textwrap(handles.message_area,{'Optimal quantizer is NOT stable.',...
        'Please set Evaluation time for numerical optimization'});
        set(handles.message_area,'string',hint)
        
    elseif size(Q.a,1)>size(G.a,1)
        hint=textwrap(handles.message_area,{'The Dimension of the quantizer is maybe too large.',...
            'The following two approaches are usefull to reduce dimention:',...
            '1. Set small evaluation time  OR',...
            '2. Truncate small singular values.'});
        set(handles.message_area,'string',hint)
    end
    
    handles.DQ=DQ('ODQ_Designer',handles.odq_design);
    flg.DQopen=1;
end
odqdata.flg=flg;
set(handles.odq_design,'UserData',odqdata)
guidata(hObject,handles);


% --- Executes on button press in import_K.
function import_K_Callback(hObject, eventdata, handles)
% hObject    handle to import_K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.systemK=system_setup_K('ODQ_Designer',handles.odq_design);
uiwait(handles.systemK)
guidata(hObject,handles);
odqdata=get(handles.odq_design,'UserData');
if isfield(odqdata,'K')
    K=odqdata.K;
    if isstruct(K)
        plantdata=get(handles.plant_table,'DATA');
        plantdata(2,1)={size(K.a,1)};
        plantdata(2,2)={size(K.b1,2)};
        plantdata(2,3)={size(K.c,1)};
        set(handles.plant_table,'DATA',plantdata)
    end
end
% global odq_plant
% load_dialog=odqloadplant;
% uiwait(load_dialog)
% if isstruct(odq_plant)==1
%     K=odq_plant;
%     plantdata=get(handles.plant_table,'DATA');
%     plantdata(2,1)={size(K.a,1)};
%     plantdata(2,2)={size(K.b1,2)};
%     plantdata(2,3)={size(K.c,1)};
%     set(handles.plant_table,'DATA',plantdata)
%     set(hObject,'UserData',K)
% end


% --- Executes on button press in import_G.
function import_G_Callback(hObject, eventdata, handles)
% hObject    handle to import_G (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.systemG=system_setup_G('ODQ_Designer',handles.odq_design);
uiwait(handles.systemG)
guidata(hObject,handles);
odqdata=get(handles.odq_design,'UserData');
if isfield(odqdata,'G')
    G=odqdata.G;
    if isstruct(G)
        plantdata=get(handles.plant_table,'DATA');
        plantdata(3,1)={size(G.a,1)};
        plantdata(3,2)={size(G.b1,2)};
        plantdata(3,3)={size(G.c1,1)};
        set(handles.plant_table,'DATA',plantdata)
    end
end
% global odq_plant
% load_dialog=odqloadplant;
% uiwait(load_dialog)
% if isstruct(odq_plant)==1
%     G=odq_plant;
%     plantdata=get(handles.plant_table,'DATA');
%     plantdata(3,1)={size(G.a,1)};
%     plantdata(3,2)={size(G.b1,2)};
%     plantdata(3,3)={size(G.c1,1)};
%     set(handles.plant_table,'DATA',plantdata)
%     set(hObject,'UserData',G)
% end


% --- Executes on button press in import_P.
function import_P_Callback(hObject, eventdata, handles)
% hObject    handle to import_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.systemP=system_setup_P('ODQ_Designer',handles.odq_design);
uiwait(handles.systemP)
guidata(hObject,handles);
odqdata=get(handles.odq_design,'UserData');
if isfield(odqdata,'P')
    P=odqdata.P;
    if isstruct(P)
        plantdata=get(handles.plant_table,'DATA');
        plantdata(1,1)={size(P.a,1)};
        plantdata(1,2)={size(P.b,2)};
        plantdata(1,3)={size(P.c1,1)};
        set(handles.plant_table,'DATA',plantdata)
    end
end
% global odq_plant
% load_dialog=odqloadplant;
% uiwait(load_dialog)
% if isstruct(odq_plant)==1
%     P=odq_plant;
%     plantdata=get(handles.plant_table,'DATA');
%     plantdata(1,1)={size(P.a,1)};
%     plantdata(1,2)={size(P.b,2)};
%     plantdata(1,3)={size(P.c1,1)};
%     set(handles.plant_table,'DATA',plantdata)
%     set(hObject,'UserData',P)
% end


% --- Executes during object creation, after setting all properties.
function axes_ff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_ff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_ff
axis([1 11 4 9]);
block=create_ff_block;
set(hObject,'UserData',block,'Visible','off')


% --- Executes during object creation, after setting all properties.
function axes_fbiq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_fbiq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_fbiq
axis([0 12 3 8]);
block=create_fbiq_block;
set(hObject,'UserData',block,'Visible','off')


% --- Executes during object creation, after setting all properties.
function axes_fboq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_fboq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_fboq
axis([0 12 3 8]);
block=create_fboq_block;
set(hObject,'UserData',block,'Visible','off')


% --- Executes during object creation, after setting all properties.
function axes_GQ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_GQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_GQ
axis([1 11 3 8]);
block=create_GQ_block;
set(hObject,'UserData',block,'Visible','off')


function block=create_ff_block
block.P=rectangle('position',[7 6 2 1.5],'facecolor',[0.7 0.3 1.0]);
block.Q=rectangle('position',[3 6 2 1.5],'facecolor',[1.0 1.0 0.0]);
block.textP=text(7.6,6.75,'$P$','fontsize',16,'interpreter','latex','color',[1 1 1]);
block.textQ=text(3.6,6.75,'$Q$','fontsize',16,'interpreter','latex','color',[0 0 0]);
block.z(1)=line([10.5 11.0],[7.00 6.75],'linewidth',2,'color',[0 0 0]);
block.z(2)=line([10.5 11.0],[6.50 6.75],'linewidth',2,'color',[0 0 0]);
block.z(3)=line([9.0 11.0],[6.75 6.75],'linewidth',2,'color',[0 0 0]);
block.v(1)=line([6.5 7.0],[7.00 6.75],'linewidth',2,'color',[1 0 0]);
block.v(2)=line([6.5 7.0],[6.50 6.75],'linewidth',2,'color',[1 0 0]);
block.v(3)=line([5.0 7.0],[6.75 6.75],'linewidth',2,'color',[1 0 0]);
block.u(1)=line([2.5 3.0],[7.00 6.75],'linewidth',2,'color',[0 0 1]);
block.u(2)=line([2.5 3.0],[6.50 6.75],'linewidth',2,'color',[0 0 1]);
block.u(3)=line([1.0 3.0],[6.75 6.75],'linewidth',2,'color',[0 0 1]);


function block=create_fbiq_block
block.P=rectangle('position',[8 6 2 1.5],'facecolor',[0.7 0.3 1.0]);
block.K=rectangle('position',[2 6 2 1.5],'facecolor',[0.0 0.7 0.3]);
block.Q=rectangle('position',[5 6 2 1.5],'facecolor',[1.0 1.0 0.0]);
block.textP=text(8.6,6.75,'$P$','fontsize',16,'interpreter','latex','color',[1 1 1]);
block.textK=text(2.6,6.75,'$K$','fontsize',16,'interpreter','latex','color',[1 1 1]);
block.textQ=text(5.6,6.75,'$Q$','fontsize',16,'interpreter','latex','color',[0 0 0]);
block.r(1)=line([ 1.50  2.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
block.r(2)=line([ 1.50  2.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
block.r(3)=line([ 0.00  2.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
block.u(1)=line([ 4.50  5.00],[7.00 6.75],'linewidth',2,'color',[0 0 1]);
block.u(2)=line([ 4.50  5.00],[6.50 6.75],'linewidth',2,'color',[0 0 1]);
block.u(3)=line([ 4.00  5.00],[6.75 6.75],'linewidth',2,'color',[0 0 1]);
block.v(1)=line([ 7.50  8.00],[7.00 6.75],'linewidth',2,'color',[1 0 0]);
block.v(2)=line([ 7.50  8.00],[6.50 6.75],'linewidth',2,'color',[1 0 0]);
block.v(3)=line([ 7.00  8.00],[6.75 6.75],'linewidth',2,'color',[1 0 0]);
block.z(1)=line([11.50 12.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
block.z(2)=line([11.50 12.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
block.z(3)=line([10.00 12.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
block.y(1)=line([ 1.50  2.00],[6.75 6.50],'linewidth',2,'color',[0 0 0]);
block.y(2)=line([ 1.50  2.00],[6.25 6.50],'linewidth',2,'color',[0 0 0]);
block.y(3)=line([10.00 10.50 10.50 1.25 1.25 2.00],...
          [ 6.50  6.50  5.00 5.00 6.50 6.50],'linewidth',2,'color',[0 0 0]);


function block=create_fboq_block
block.P=rectangle('position',[8 6 2 1.5],'facecolor',[0.7 0.3 1.0]);
block.K=rectangle('position',[2 6 2 1.5],'facecolor',[0.0 0.7 0.3]);
block.Q=rectangle('position',[5 4.25 2 1.5],'facecolor',[1.0 1.0 0.0]);
block.textP=text(8.6,6.75,'$P$','fontsize',16,'interpreter','latex','color',[1 1 1]);
block.textK=text(2.6,6.75,'$K$','fontsize',16,'interpreter','latex','color',[1 1 1]);
block.textQ=text(5.6,5.00,'$Q$','fontsize',16,'interpreter','latex','color',[0 0 0]);
block.r(1)=line([ 1.50  2.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
block.r(2)=line([ 1.50  2.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
block.r(3)=line([ 0.00  2.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
block.u(1)=line([ 7.00  7.50],[5.00 5.25],'linewidth',2,'color',[0 0 1]);
block.u(2)=line([ 7.00  7.50],[5.00 4.75],'linewidth',2,'color',[0 0 1]);
block.u(3)=line([10.00 10.50 10.50  7.00],...
          [ 6.50  6.50  5.00  5.00],'linewidth',2,'color',[0 0 1]);
block.v(1)=line([ 1.50  2.00],[6.75 6.50],'linewidth',2,'color',[1 0 0]);
block.v(2)=line([ 1.50  2.00],[6.25 6.50],'linewidth',2,'color',[1 0 0]);
block.v(3)=line([ 5.00  1.25  1.25  2.00],...
           [5.00  5.00  6.50  6.50],'linewidth',2,'color',[1 0 0]);
block.z(1)=line([11.50 12.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
block.z(2)=line([11.50 12.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
block.z(3)=line([10.00 12.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
block.w(1)=line([ 7.50  8.00],[7.00 6.75],'linewidth',2,'color',[0 0 0]);
block.w(2)=line([ 7.50  8.00],[6.50 6.75],'linewidth',2,'color',[0 0 0]);
block.w(3)=line([ 4.00  8.00],[6.75 6.75],'linewidth',2,'color',[0 0 0]);


function block=create_GQ_block
block.G=rectangle('position',[5 6 2 1.5],'facecolor',[0.0 0.7 0.3]);
block.Q=rectangle('position',[5 4.25 2 1.5],'facecolor',[1.0 1.0 0.0]);
block.textG=text(5.6,6.75,'$G$','fontsize',16,'interpreter','latex','color',[1 1 1]);
block.textQ=text(5.6,5.00,'$Q$','fontsize',16,'interpreter','latex','color',[0 0 0]);
block.r(1)=line([ 4.50  5.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
block.r(2)=line([ 4.50  5.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
block.r(3)=line([ 1.00  5.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
block.u(1)=line([ 7.00  7.50],[5.00 5.25],'linewidth',2,'color',[0 0 1]);
block.u(2)=line([ 7.00  7.50],[5.00 4.75],'linewidth',2,'color',[0 0 1]);
block.u(3)=line([7.00 9.00 9.00 7.00],...
          [ 6.50  6.50  5.00  5.00],'linewidth',2,'color',[0 0 1]);
block.v(1)=line([ 4.50  5.00],[6.75 6.50],'linewidth',2,'color',[1 0 0]);
block.v(2)=line([ 4.50  5.00],[6.25 6.50],'linewidth',2,'color',[1 0 0]);
block.v(3)=line([ 5.00  3.00  3.00  5.00],...
           [5.00  5.00  6.50  6.50],'linewidth',2,'color',[1 0 0]);
block.z(1)=line([10.50 11.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
block.z(2)=line([10.50 11.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
block.z(3)=line([7.00 11.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);


% --- Executes on slider movement.
function slider_d_Callback(hObject, eventdata, handles)
% hObject    handle to slider_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
d=get(hObject,'Value');
set(handles.edit_d,'String',d,'UserData',d)


% --- Executes during object creation, after setting all properties.
function slider_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_T_Callback(hObject, eventdata, handles)
% hObject    handle to slider_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
T=get(hObject,'Value');
set(handles.edit_T,'String',T,'UserData',T)


% --- Executes during object creation, after setting all properties.
function slider_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function plant_table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plant_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
plantdata=cell(3,3);
set(hObject,'DATA',plantdata)


function edit_sv_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sv as text
%        str2double(get(hObject,'String')) returns contents of edit_sv as a double
dim=str2double(get(hObject,'string'));
set(hObject,'UserData',dim);


% --- Executes during object creation, after setting all properties.
function edit_sv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
T=inf;
set(hObject,'string',T,'UserData',T);


% --- Executes during object creation, after setting all properties.
function edit_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
d=1;
set(hObject,'UserData',d);


% --- Executes during object creation, after setting all properties.
function solvers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to solvers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
solver='linprog';
set(hObject,'UserData',solver)


% --- Executes when selected object is changed in solvers.
function solvers_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in solvers 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton_linprog'
        solver='linprog';
    case 'radiobutton_cplex'
        solver='cplex';
    case 'radiobutton_sdpt3'
        solver='cvx';
    % Continue with more cases as necessary.
%     otherwise
%        con='null';
end
set(handles.solvers,'UserData',solver) %remove the case "hObject=radiobuttonx"


% --- Executes on button press in re_design_button.
function re_design_button_Callback(hObject, eventdata, handles)
% hObject    handle to re_design_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global Q E Hk gain G d
odqdata=get(handles.odq_design,'UserData');
flg=odqdata.flg;
if isfield(flg,'DQopen')==1
    if flg.DQopen==1
        delete(handles.DQ)
        flg.DQopen=0;
    end
end
con=get(handles.connection,'UserData');
if strcmp(con,'GQ')
    % G=get(handles.import_G,'UserData');
    G=odqdata.G;
else
    P=odqdata.P;
    % P=get(handles.import_P,'UserData');
    if strcmp(con,'ff')
        K=[];
    else
        % K=get(handles.import_K,'UserData');
        K=odqdata.K;
    end
    G=compg(P,K,con);
end
T = get(handles.edit_T,   'UserData');
d = get(handles.edit_d,   'UserData');
dim = get(handles.edit_sv,'UserData');
gamma.wv = get(handles.edit_wv,'UserData');
Hk = odqdata.Hk;
[Q Hk] = odqreal(G,Hk,dim);
E = odqcost(G,Q,d,T);
gain = odqgain(Q,T);
stb=odqstb(Q);
if stb==0
    hint=textwrap(handles.message_area,{'Please set T and gamma',...
        'for numerical optimization'});
    set(handles.message_area,'string',hint)
end
odqdata.Q=Q;
odqdata.E=E;
odqdata.Hk=Hk;
odqdata.gain=gain;
odqdata.G=G;
odqdata.d=d;
set(handles.odq_design,'UserData',odqdata)
handles.DQ=DQ('ODQ_Designer',handles.odq_design);
flg.DQopen=1;
odqdata.flg=flg;
set(handles.odq_design,'UserData',odqdata)
guidata(hObject,handles);
