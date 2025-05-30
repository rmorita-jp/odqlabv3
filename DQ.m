function varargout = DQ(varargin)
% DQ M-file for DQ.fig
%      DQ, by itself, creates a new DQ or raises the existing
%      singleton*.
%
%      H = DQ returns the handle to a new DQ or the handle to
%      the existing singleton*.
%
%      DQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DQ.M with the given input arguments.
%
%      DQ('Property','Value',...) creates a new DQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DQ_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DQ_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DQ

% Last Modified by GUIDE v2.5 13-Feb-2010 22:00:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DQ_OpeningFcn, ...
                   'gui_OutputFcn',  @DQ_OutputFcn, ...
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


% --- Executes just before DQ is made visible.
function DQ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DQ (see VARARGIN)

% Choose default command line output for DQ
handles.output = hObject;

odqgui_input = find(strcmp(varargin, 'ODQ_Designer'));
if ~isempty(odqgui_input)
    handles.odq_design = varargin{odqgui_input+1};
else
    errordlg('Please design optimal dynamic quantizer','ERROR','modal');
    error('ODQ ERROR')
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DQ wait for user response (see UIRESUME)
% uiwait(handles.figure1);

odqdata=get(handles.odq_design,'UserData');
G    = odqdata.G;
Q    = odqdata.Q;
d    = odqdata.d;
gain = odqdata.gain;
E    = odqdata.E;
Hk   = odqdata.Hk;
con  = odqdata.con;

stb=odqstb(Q);
if size(Q.a,1)>1000
    Einf='skipped';
else
    Einf = odqcost(G,Q,d,inf);
end
staticQ.a  = 0;
staticQ.b1 = zeros(1,size(G.c2,1));
staticQ.b2 = zeros(1,size(G.c2,1));
staticQ.c  = zeros(size(G.c2,1),1);
E_upper = odqcost(G,staticQ,d,inf);

%{
if strcmpi(con,'fbiq')
    E_low   = norm(G.c1*G.b2,inf)*d/2;
elseif strcmpi(con,'ff')
    E_low   = norm(G.c1*G.b2,inf)*d/2;
elseif strcmpi(con,'GQ')
    
else 
    error('error whitch block');
end
%}

E_low   = norm(G.c1*G.b2,inf)*d/2;

if stb==1
    set(handles.val_stability,'string','STABLE')
else
    set(handles.val_stability,'string','UNSTABLE')
end
set(handles.val_gain_wv,'string',gain.wv)
set(handles.val_dim ,'string',size(Q.a,1));
set(handles.val_ET  ,'string',E);
set(handles.val_Einf,'string',Einf);
set(handles.val_LE  ,'string',E_low);
set(handles.val_UE  ,'string',E_upper)
singular_xrange=0:size(Hk.S,1)-1;
stairs(handles.axes_hnkl,singular_xrange,diag(Hk.S),'LineWidth',2);
set(handles.axes_hnkl,'Yscale','log','YGrid','on');
redline=zeros(1,size(Hk.S,1));
for k=1:size(Hk.S,1)-1
    if Hk.S(k+1,k+1)/Hk.S(k,k)<0.1
        redline(k)=1;
    end
end
if max(redline)==1
axes(handles.axes_hnkl)
singular_yrange=get(gca,'YLim');
    xredline=find(redline);
    for k=1:length(xredline)
        line([xredline(k) xredline(k)],singular_yrange,'color',[1 0 0])
    end
set(gca,'XTick',xredline,'XTickLabel',xredline);
set(gcf,'menubar','none','toolbar','none')
%set(gcf,'menubar','figure','toolbar','figure')
end
ylabel(handles.axes_u   ,'Quantizer input'  ,'FontSize',10)
ylabel(handles.axes_v   ,'Quantizer output' ,'FontSize',10)
ylabel(handles.axes_zQ  ,'Output','FontSize',10)
ylabel(handles.axes_diff,'Output difference','FontSize',10)

if strcmp(odqdata.connection,'ff') || strcmp(odqdata.connection,'GQ')
    set(handles.edit_x0_2,'enable','off');
end

axes(handles.axes_block);
if strcmp(odqdata.connection,'ff')
    create_ff_block;
elseif strcmp(odqdata.connection,'fbiq')
    create_fbiq_block;
elseif strcmp(odqdata.connection,'fboq')
    create_fboq_block;
elseif strcmp(odqdata.connection,'GQ')
    create_GQ_block;
end


% --- Outputs from this function are returned to the command line.
function varargout = DQ_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit_ref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string','sin(k)+0.5*cos(k)','UserData','sin(k)+0.5*cos(k)')


% --- Executes during object creation, after setting all properties.
function edit_x0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string','[0;0]')


% --- Executes during object creation, after setting all properties.
function edit_x0_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x0_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'string','[0;0]')


% --- Executes on button press in start_sim.
function start_sim_Callback(hObject, eventdata, handles)
% hObject    handle to start_sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odqdata = get(handles.odq_design,'UserData');
G = odqdata.G;
Q = odqdata.Q;
d = odqdata.d;

Rt=get(handles.edit_ref,'string');
x0_P=get(handles.edit_x0,'string');
x0_K=get(handles.edit_x0_2,'string');
kFinal=str2double(get(handles.edit_finaltime,'string'));
x  = zeros( size(G.a ,1) , kFinal+1 );
xQ = zeros( size(G.a ,1) , kFinal+1 );
z  = zeros( size(G.c1,1) , kFinal+1 );
zQ = zeros( size(G.c1,1) , kFinal+1 );
u  = zeros( size(G.c2,1) , kFinal+1 );
uQ = zeros( size(G.c2,1) , kFinal+1 );
xi = zeros( size(Q.a ,1) , kFinal+1 );
v  = zeros( size(Q.c ,1) , kFinal+1 );

k = 0:kFinal;
flg.r_work  = 0;
flg.x0_P_work = 0;
flg.x0_K_work = 0;
work_val = evalin('base','who');
for i = 1:size(work_val)
    if strcmp(work_val(i,:),Rt)==1
        r=evalin('base',Rt);
        flg.r_work=1;
    end
    if strcmp(work_val(i,:),x0_P)==1
        x0_P=evalin('base',x0_K);
        flg.x0_P_work=1;
    end
    if strcmp(work_val(i,:),x0_K)==1
        x0_K=evalin('base',x0_K);
        flg.x0_K_work=1;
    end
end
if flg.r_work==0
    r = eval(Rt);
end
if isscalar(r)==1
    r = r*ones(1,kFinal+1);
end
if flg.x0_P_work==1;
    x0_P2 = x0_P;
else
    x0_P2 = eval(x0_P);
end
if flg.x0_K_work==1;
    x0_K2 = x0_K;
else
    x0_K2 = eval(x0_K);
end
if strcmp(odqdata.connection,'ff') || strcmp(odqdata.connection,'GQ')
    x(:,1)  = x0_P2;
    xQ(:,1) = x0_P2;
else
    x(:,1)  = [x0_P2;x0_K2];
    xQ(:,1) = [x0_P2;x0_K2];
end

%%% start simulation %%%
for i=1:kFinal+1
    z(:,i)  = G.c1*x(:,i)  + G.d1*r(:,i);
    zQ(:,i) = G.c1*xQ(:,i) + G.d1*r(:,i);
    u(:,i)  = G.c2*x(:,i)  + G.d2*r(:,i);
    uQ(:,i) = G.c2*xQ(:,i) + G.d2*r(:,i);
    v(:,i)  = d*round( ( Q.c*xi(:,i) + uQ(:,i) )/d );
    xi(:,i+1) = Q.a*xi(:,i) + Q.b1*uQ(:,i) + Q.b2*v(:,i);
    x(:,i+1)  = G.a*x(:,i)  + G.b1*r(:,i) + G.b2*u(:,i);
    xQ(:,i+1) = G.a*xQ(:,i) + G.b1*r(:,i) + G.b2*v(:,i);
end
stairs(handles.axes_u   ,k,u'    );
%axis(handles.axes_u,[0 kFinal min(u) max(u)])
stairs(handles.axes_v   ,k,v'    );
stairs(handles.axes_zQ  ,k,zQ'   );
stairs(handles.axes_diff,k,zQ'-z');
ylabel(handles.axes_u   ,'Quantizer input'  ,'FontSize',10)
ylabel(handles.axes_v   ,'Quantizer output' ,'FontSize',10)
ylabel(handles.axes_zQ  ,'Output'           ,'FontSize',10)
ylabel(handles.axes_diff,'Output difference','FontSize',10)
set(handles.axes_u   ,'XGrid','on','YGrid','on')
set(handles.axes_v   ,'XGrid','on','YGrid','on')
set(handles.axes_zQ  ,'XGrid','on','YGrid','on')
set(handles.axes_diff,'XGrid','on','YGrid','on')


% --- Executes on slider movement.
function slider_finaltime_Callback(hObject, eventdata, handles)
% hObject    handle to slider_finaltime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
kFinal=get(hObject,'Value');
set(handles.edit_finaltime,'String',kFinal,'UserData',kFinal)


% --- Executes during object creation, after setting all properties.
function slider_finaltime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_finaltime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',100)


function edit_finaltime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_finaltime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_finaltime as text
%        str2double(get(hObject,'String')) returns contents of edit_finaltime as a double
kFinal=str2double(get(hObject,'String'));
set(handles.slider_finaltime,'Value',kFinal)
set(hObject,'UserData',kFinal)


% --- Executes during object creation, after setting all properties.
function edit_finaltime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_finaltime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
kFinal=100;
set(hObject,'string',kFinal,'UserData',kFinal);


% --- Executes on button press in save_WS.
function save_WS_Callback(hObject, eventdata, handles)
% hObject    handle to save_WS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odqdata=get(handles.odq_design,'UserData');
val_name=inputdlg('Variable name in workspace');
if ~isempty(val_name{1})
    assignin('base',val_name{1},odqdata.Q)
    fprintf('Quantizer exported in Workspace!\n');
end


% --- Executes on button press in save_file.
function save_file_Callback(hObject, eventdata, handles)
% hObject    handle to save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odqdata=get(handles.odq_design,'UserData');
val_name=inputdlg('Variable name in workspace');
if ~isempty(val_name{1})
    eval([val_name{1} '=' 'odqdata.Q']);
    uisave(val_name{1})
end

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
odqdata=get(handles.odq_design,'UserData');
odqdata.flg.DQopen=0;
set(handles.odq_design,'UserData',odqdata);
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function axes_hnkl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_hnkl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_hnkl


% --- Executes during object creation, after setting all properties.
function axes_block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_block
axis([0 12 3 8]);
set(hObject,'Visible','off')


function block=create_ff_block
block.P=rectangle('position',[7 5 2 1.5],'facecolor',[0.7 0.3 1.0]);
block.Q=rectangle('position',[3 5 2 1.5],'facecolor',[1.0 1.0 0.0]);
block.textP=text(7.5,5.75,'$P$','fontsize',14,'interpreter','latex','color',[1 1 1]);
block.textQ=text(3.5,5.75,'$Q$','fontsize',14,'interpreter','latex','color',[0 0 0]);
block.z(1)=line([10.5 11.0],[6.00 5.75],'linewidth',1,'color',[0 0 0]);
block.z(2)=line([10.5 11.0],[5.50 5.75],'linewidth',1,'color',[0 0 0]);
block.z(3)=line([9.0 11.0],[5.75 5.75] ,'linewidth',1,'color',[0 0 0]);
block.v(1)=line([6.5 7.0] ,[6.00 5.75] ,'linewidth',1,'color',[1 0 0]);
block.v(2)=line([6.5 7.0] ,[5.50 5.75] ,'linewidth',1,'color',[1 0 0]);
block.v(3)=line([5.0 7.0] ,[5.75 5.75] ,'linewidth',1,'color',[1 0 0]);
block.u(1)=line([2.5 3.0] ,[6.00 5.75] ,'linewidth',1,'color',[0 0 1]);
block.u(2)=line([2.5 3.0] ,[5.50 5.75] ,'linewidth',1,'color',[0 0 1]);
block.u(3)=line([1.0 3.0] ,[5.75 5.75] ,'linewidth',1,'color',[0 0 1]);
rectangle('Position',[9.5 5.375 0.75 0.75],'Curvature',[1,1], ...
    'linewidth',1) 
line([9.875,9.875,11],[6.125,6.5,8],'linewidth',1,'color',[0 0 0])
rectangle('position',[5.5 5.375 0.75 0.75],'Curvature',[1,1], ...
    'linewidth',1,'EdgeColor',[1 0 0]) 
line([5.875,5.875,2],[5.375,4,3],'linewidth',1,'color',[1 0 0])
rectangle('position',[1.5 5.375 0.75 0.75],'Curvature',[1,1], ...
    'linewidth',1,'EdgeColor',[0 0 1]) 
line([1.875,1.875,1.5],[6.125,6.5,8],'linewidth',1,'color',[0 0 1])


function block=create_fbiq_block
block.P=rectangle('position',[8 5.5 2 1.5],'facecolor',[0.7 0.3 1.0]);
block.K=rectangle('position',[2 5.5 2 1.5],'facecolor',[0.0 0.7 0.3]);
block.Q=rectangle('position',[5 5.5 2 1.5],'facecolor',[1.0 1.0 0.0]);
block.textP=text(8.5,6.25,'$P$','fontsize',14,'interpreter','latex','color',[1 1 1]);
block.textK=text(2.5,6.25,'$K$','fontsize',14,'interpreter','latex','color',[1 1 1]);
block.textQ=text(5.5,6.25,'$Q$','fontsize',14,'interpreter','latex','color',[0 0 0]);
block.r(1)=line([ 1.50  2.00],[6.75 6.50],'linewidth',1,'color',[0 0 0]);
block.r(2)=line([ 1.50  2.00],[6.25 6.50],'linewidth',1,'color',[0 0 0]);
block.r(3)=line([ 0.00  2.00],[6.50 6.50],'linewidth',1,'color',[0 0 0]);
block.u(1)=line([ 4.50  5.00],[6.50 6.25],'linewidth',1,'color',[0 0 1]);
block.u(2)=line([ 4.50  5.00],[6.00 6.25],'linewidth',1,'color',[0 0 1]);
block.u(3)=line([ 4.00  5.00],[6.25 6.25],'linewidth',1,'color',[0 0 1]);
block.v(1)=line([ 7.50  8.00],[6.50 6.25],'linewidth',1,'color',[1 0 0]);
block.v(2)=line([ 7.50  8.00],[6.00 6.25],'linewidth',1,'color',[1 0 0]);
block.v(3)=line([ 7.00  8.00],[6.25 6.25],'linewidth',1,'color',[1 0 0]);
block.z(1)=line([11.50 12.00],[6.75 6.50],'linewidth',1,'color',[0 0 0]);
block.z(2)=line([11.50 12.00],[6.25 6.50],'linewidth',1,'color',[0 0 0]);
block.z(3)=line([10.00 12.00],[6.50 6.50],'linewidth',1,'color',[0 0 0]);
block.y(1)=line([ 1.50  2.00],[6.25 6.00],'linewidth',1,'color',[0 0 0]);
block.y(2)=line([ 1.50  2.00],[5.75 6.00],'linewidth',1,'color',[0 0 0]);
block.y(3)=line([10.00 10.50 10.50 1.25 1.25 2.00],...
       [ 6.00  6.00  4.50 4.50 6.00 6.00],'linewidth',1,'color',[0 0 0]);
% rectangle('position',[9.625 6.625 0.75 0.75],'Curvature',[1,1], ...
%     'linewidth',1) 
line([11,11],[6.5,8],'linewidth',1,'color',[0 0 0])
% rectangle('position',[2.625 5.25 0.75 0.75],'Curvature',[1,1], ...
%     'linewidth',1,'EdgeColor',[1 0 0]) 
line([7.25,7.25,2],[6.25,4,3],'linewidth',1,'color',[1 0 0])
% rectangle('position',[7.625 6.125 0.75 0.75],'Curvature',[1,1], ...
%     'linewidth',1,'EdgeColor',[0 0 1]) 
line([4.25,4.25,3],[6.25,7.5,8],'linewidth',1,'color',[0 0 1])

function block=create_fboq_block
block.P=rectangle('position',[8 6 2 1.5],'facecolor',[0.7 0.3 1.0]);
block.K=rectangle('position',[2 6 2 1.5],'facecolor',[0.0 0.7 0.3]);
block.Q=rectangle('position',[5 4.25 2 1.5],'facecolor',[1.0 1.0 0.0]);
block.textP=text(8.5,6.75,'$P$','fontsize',14,'interpreter','latex','color',[1 1 1]);
block.textK=text(2.5,6.75,'$K$','fontsize',14,'interpreter','latex','color',[1 1 1]);
block.textQ=text(5.5,5.00,'$Q$','fontsize',14,'interpreter','latex','color',[0 0 0]);
block.r(1)=line([ 1.50  2.00],[7.25 7.00],'linewidth',1,'color',[0 0 0]);
block.r(2)=line([ 1.50  2.00],[6.75 7.00],'linewidth',1,'color',[0 0 0]);
block.r(3)=line([ 0.00  2.00],[7.00 7.00],'linewidth',1,'color',[0 0 0]);
block.u(1)=line([ 7.00  7.50],[5.00 5.25],'linewidth',1,'color',[0 0 1]);
block.u(2)=line([ 7.00  7.50],[5.00 4.75],'linewidth',1,'color',[0 0 1]);
block.u(3)=line([10.00 10.50 10.50  7.00],...
                [ 6.50  6.50  5.00  5.00],'linewidth',1,'color',[0 0 1]);
block.v(1)=line([ 1.50  2.00],[6.75 6.50],'linewidth',1,'color',[1 0 0]);
block.v(2)=line([ 1.50  2.00],[6.25 6.50],'linewidth',1,'color',[1 0 0]);
block.v(3)=line([ 5.00  1.25  1.25  2.00],...
                 [5.00  5.00  6.50  6.50],'linewidth',1,'color',[1 0 0]);
block.z(1)=line([11.50 12.00],[7.25 7.00],'linewidth',1,'color',[0 0 0]);
block.z(2)=line([11.50 12.00],[6.75 7.00],'linewidth',1,'color',[0 0 0]);
block.z(3)=line([10.00 12.00],[7.00 7.00],'linewidth',1,'color',[0 0 0]);
block.w(1)=line([ 7.50  8.00],[7.00 6.75],'linewidth',1,'color',[0 0 0]);
block.w(2)=line([ 7.50  8.00],[6.50 6.75],'linewidth',1,'color',[0 0 0]);
block.w(3)=line([ 4.00  8.00],[6.75 6.75],'linewidth',1,'color',[0 0 0]);
rectangle('Position',[10.625 6.625 0.75 0.75],'Curvature',[1,1], ...
    'linewidth',1) 
line([11,11],[7.375,8],'linewidth',1,'color',[0 0 0])
rectangle('position',[2.625 4.625 0.75 0.75],'Curvature',[1,1], ...
    'linewidth',1,'EdgeColor',[1 0 0]) 
line([2.8125,2],[4.6752,3],'linewidth',1,'color',[1 0 0])
rectangle('position',[8.625 4.625 0.75 0.75],'Curvature',[1,1], ...
    'linewidth',1,'EdgeColor',[0 0 1]) 
line([8.7348,4],[5.2652,8],'linewidth',1,'color',[0 0 1])

function block=create_GQ_block
block.G=rectangle('position',[5 6 2 1.5],'facecolor',[0.0 0.7 0.3]);
block.Q=rectangle('position',[5 4.25 2 1.5],'facecolor',[1.0 1.0 0.0]);
block.textG=text(5.7,6.75,'$G$','fontsize',12,'interpreter','latex','color',[1 1 1]);
block.textQ=text(5.7,5.00,'$Q$','fontsize',12,'interpreter','latex','color',[0 0 0]);
block.r(1)=line([ 4.50  5.00],[7.25 7.00],'linewidth',1,'color',[0 0 0]);
block.r(2)=line([ 4.50  5.00],[6.75 7.00],'linewidth',1,'color',[0 0 0]);
block.r(3)=line([ 1.00  5.00],[7.00 7.00],'linewidth',1,'color',[0 0 0]);
block.u(1)=line([ 7.00  7.50],[5.00 5.25],'linewidth',1,'color',[0 0 1]);
block.u(2)=line([ 7.00  7.50],[5.00 4.75],'linewidth',1,'color',[0 0 1]);
block.u(3)=line([7.00 9.00 9.00 7.00],...
                [ 6.50  6.50  5.00  5.00],'linewidth',1,'color',[0 0 1]);
block.v(1)=line([ 4.50  5.00],[6.75 6.50],'linewidth',1,'color',[1 0 0]);
block.v(2)=line([ 4.50  5.00],[6.25 6.50],'linewidth',1,'color',[1 0 0]);
block.v(3)=line([ 5.00  3.00  3.00  5.00],...
                 [5.00  5.00  6.50  6.50],'linewidth',1,'color',[1 0 0]);
block.z(1)=line([10.50 11.00],[7.25 7.00],'linewidth',1,'color',[0 0 0]);
block.z(2)=line([10.50 11.00],[6.75 7.00],'linewidth',1,'color',[0 0 0]);
block.z(3)=line([7.00 11.00],[7.00 7.00] ,'linewidth',1,'color',[0 0 0]);
rectangle('position',[9.625 6.625 0.75 0.75],'Curvature',[1,1], ...
    'linewidth',1) 
line([10.2652,11],[7.2652,8],'linewidth',1,'color',[0 0 0])
rectangle('position',[2.625 5.25 0.75 0.75],'Curvature',[1,1], ...
    'linewidth',1,'EdgeColor',[1 0 0]) 
line([2.8215,2],[5.25,3],'linewidth',1,'color',[1 0 0])
rectangle('position',[7.625 6.125 0.75 0.75],'Curvature',[1,1], ...
    'linewidth',1,'EdgeColor',[0 0 1]) 
line([8,8,5],[6.825,7.5,8],'linewidth',1,'color',[0 0 1])
