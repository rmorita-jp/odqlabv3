classdef odqlab_App_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        odq_design              matlab.ui.Figure
        MessageTextAreaLabel_2  matlab.ui.control.Label
        Quantizer_reduction     matlab.ui.container.Panel
        re_design_button        matlab.ui.control.Button
        edit_sv                 matlab.ui.control.EditField
        Quantizer_Dimention     matlab.ui.control.Label
        uipanel9                matlab.ui.container.Panel
        uipanel5                matlab.ui.container.Panel
        edit_d                  matlab.ui.control.EditField
        excute_button           matlab.ui.control.Button
        uipanel11               matlab.ui.container.Panel
        wvLabel                 matlab.ui.control.Label
        uvLabel                 matlab.ui.control.Label
        edit_wv                 matlab.ui.control.EditField
        edit_uv                 matlab.ui.control.EditField
        uipanel4                matlab.ui.container.Panel
        edit_T                  matlab.ui.control.EditField
        solvers                 matlab.ui.container.ButtonGroup
        radiobutton_gurobi      matlab.ui.control.RadioButton
        radiobutton_sedumi      matlab.ui.control.RadioButton
        radiobutton_sdpt3       matlab.ui.control.RadioButton
        radiobutton_cplex       matlab.ui.control.RadioButton
        radiobutton_linprog     matlab.ui.control.RadioButton
        text10                  matlab.ui.control.Label
        connection              matlab.ui.container.ButtonGroup
        plant_table             matlab.ui.control.Table
        import_G                matlab.ui.control.Button
        import_K                matlab.ui.control.Button
        import_P                matlab.ui.control.Button
        radiobutton_fboq        matlab.ui.control.RadioButton
        radiobutton_GQ          matlab.ui.control.RadioButton
        radiobutton_fbiq        matlab.ui.control.RadioButton
        radiobutton_ff          matlab.ui.control.RadioButton
        axes_ff                 matlab.ui.control.UIAxes
        axes_fboq               matlab.ui.control.UIAxes
        axes_GQ                 matlab.ui.control.UIAxes
        axes_fbiq               matlab.ui.control.UIAxes
    end

    
    methods (Access = private)
        function block = create_GQ_block(app)
            block.G=rectangle(app.axes_GQ,'position',[5 6 2 1.5],'facecolor',[0.0 0.7 0.3]);
            block.Q=rectangle(app.axes_GQ,'position',[5 4.25 2 1.5],'facecolor',[1.0 1.0 0.0]);
            block.textG=text(app.axes_GQ,5.6,6.75,'$G$','fontsize',16,'interpreter','latex','color',[1 1 1]);
            block.textQ=text(app.axes_GQ,5.6,5.00,'$Q$','fontsize',16,'interpreter','latex','color',[0 0 0]);
            block.r(1)=line(app.axes_GQ,[ 4.50  5.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
            block.r(2)=line(app.axes_GQ,[ 4.50  5.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
            block.r(3)=line(app.axes_GQ,[ 1.00  5.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
            block.u(1)=line(app.axes_GQ,[ 7.00  7.50],[5.00 5.25],'linewidth',2,'color',[0 0 1]);
            block.u(2)=line(app.axes_GQ,[ 7.00  7.50],[5.00 4.75],'linewidth',2,'color',[0 0 1]);
            block.u(3)=line(app.axes_GQ,[7.00 9.00 9.00 7.00],[ 6.50  6.50  5.00  5.00],'linewidth',2,'color',[0 0 1]);
            block.v(1)=line(app.axes_GQ,[ 4.50  5.00],[6.75 6.50],'linewidth',2,'color',[1 0 0]);
            block.v(2)=line(app.axes_GQ,[ 4.50  5.00],[6.25 6.50],'linewidth',2,'color',[1 0 0]);
            block.v(3)=line(app.axes_GQ,[ 5.00  3.00  3.00  5.00],[5.00  5.00  6.50  6.50],'linewidth',2,'color',[1 0 0]);
            block.z(1)=line(app.axes_GQ,[10.50 11.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
            block.z(2)=line(app.axes_GQ,[10.50 11.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
            block.z(3)=line(app.axes_GQ,[7.00 11.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
        end
        
        function block = create_fbiq_block(app)
            block.P=rectangle(app.axes_fbiq,'position',[8 6 2 1.5],'facecolor',[0.7 0.3 1.0]);
            block.K=rectangle(app.axes_fbiq,'position',[2 6 2 1.5],'facecolor',[0.0 0.7 0.3]);
            block.Q=rectangle(app.axes_fbiq,'position',[5 6 2 1.5],'facecolor',[1.0 1.0 0.0]);
            block.textP=text(app.axes_fbiq,8.6,6.75,'$P$','fontsize',16,'interpreter','latex','color',[1 1 1]);
            block.textK=text(app.axes_fbiq,2.6,6.75,'$K$','fontsize',16,'interpreter','latex','color',[1 1 1]);
            block.textQ=text(app.axes_fbiq,5.6,6.75,'$Q$','fontsize',16,'interpreter','latex','color',[0 0 0]);
            block.r(1)=line(app.axes_fbiq,[ 1.50  2.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
            block.r(2)=line(app.axes_fbiq,[ 1.50  2.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
            block.r(3)=line(app.axes_fbiq,[ 0.00  2.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
            block.u(1)=line(app.axes_fbiq,[ 4.50  5.00],[7.00 6.75],'linewidth',2,'color',[0 0 1]);
            block.u(2)=line(app.axes_fbiq,[ 4.50  5.00],[6.50 6.75],'linewidth',2,'color',[0 0 1]);
            block.u(3)=line(app.axes_fbiq,[ 4.00  5.00],[6.75 6.75],'linewidth',2,'color',[0 0 1]);
            block.v(1)=line(app.axes_fbiq,[ 7.50  8.00],[7.00 6.75],'linewidth',2,'color',[1 0 0]);
            block.v(2)=line(app.axes_fbiq,[ 7.50  8.00],[6.50 6.75],'linewidth',2,'color',[1 0 0]);
            block.v(3)=line(app.axes_fbiq,[ 7.00  8.00],[6.75 6.75],'linewidth',2,'color',[1 0 0]);
            block.z(1)=line(app.axes_fbiq,[11.50 12.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
            block.z(2)=line(app.axes_fbiq,[11.50 12.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
            block.z(3)=line(app.axes_fbiq,[10.00 12.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
            block.y(1)=line(app.axes_fbiq,[ 1.50  2.00],[6.75 6.50],'linewidth',2,'color',[0 0 0]);
            block.y(2)=line(app.axes_fbiq,[ 1.50  2.00],[6.25 6.50],'linewidth',2,'color',[0 0 0]);
            block.y(3)=line(app.axes_fbiq,[10.00 10.50 10.50 1.25 1.25 2.00],[ 6.50  6.50  5.00 5.00 6.50 6.50],'linewidth',2,'color',[0 0 0]);
        end
        
        function block = create_fboq_block(app)
            block.P=rectangle(app.axes_fboq,'position',[8 6 2 1.5],'facecolor',[0.7 0.3 1.0]);
            block.K=rectangle(app.axes_fboq,'position',[2 6 2 1.5],'facecolor',[0.0 0.7 0.3]);
            block.Q=rectangle(app.axes_fboq,'position',[5 4.25 2 1.5],'facecolor',[1.0 1.0 0.0]);
            block.textP=text(app.axes_fboq,8.6,6.75,'$P$','fontsize',16,'interpreter','latex','color',[1 1 1]);
            block.textK=text(app.axes_fboq,2.6,6.75,'$K$','fontsize',16,'interpreter','latex','color',[1 1 1]);
            block.textQ=text(app.axes_fboq,5.6,5.00,'$Q$','fontsize',16,'interpreter','latex','color',[0 0 0]);
            block.r(1)=line(app.axes_fboq,[ 1.50  2.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
            block.r(2)=line(app.axes_fboq,[ 1.50  2.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
            block.r(3)=line(app.axes_fboq,[ 0.00  2.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
            block.u(1)=line(app.axes_fboq,[ 7.00  7.50],[5.00 5.25],'linewidth',2,'color',[0 0 1]);
            block.u(2)=line(app.axes_fboq,[ 7.00  7.50],[5.00 4.75],'linewidth',2,'color',[0 0 1]);
            block.u(3)=line(app.axes_fboq,[10.00 10.50 10.50  7.00],[ 6.50  6.50  5.00  5.00],'linewidth',2,'color',[0 0 1]);
            block.v(1)=line(app.axes_fboq,[ 1.50  2.00],[6.75 6.50],'linewidth',2,'color',[1 0 0]);
            block.v(2)=line(app.axes_fboq,[ 1.50  2.00],[6.25 6.50],'linewidth',2,'color',[1 0 0]);
            block.v(3)=line(app.axes_fboq,[ 5.00  1.25  1.25  2.00],[5.00  5.00  6.50  6.50],'linewidth',2,'color',[1 0 0]);
            block.z(1)=line(app.axes_fboq,[11.50 12.00],[7.25 7.00],'linewidth',2,'color',[0 0 0]);
            block.z(2)=line(app.axes_fboq,[11.50 12.00],[6.75 7.00],'linewidth',2,'color',[0 0 0]);
            block.z(3)=line(app.axes_fboq,[10.00 12.00],[7.00 7.00],'linewidth',2,'color',[0 0 0]);
            block.w(1)=line(app.axes_fboq,[ 7.50  8.00],[7.00 6.75],'linewidth',2,'color',[0 0 0]);
            block.w(2)=line(app.axes_fboq,[ 7.50  8.00],[6.50 6.75],'linewidth',2,'color',[0 0 0]);
            block.w(3)=line(app.axes_fboq,[ 4.00  8.00],[6.75 6.75],'linewidth',2,'color',[0 0 0]);
        end
        
        function block = create_ff_block(app)
            block.P=rectangle(app.axes_ff,'position',[7 6 2 1.5],'facecolor',[0.7 0.3 1.0]);
            block.Q=rectangle(app.axes_ff,'position',[3 6 2 1.5],'facecolor',[1.0 1.0 0.0]);
            block.textP=text(app.axes_ff,7.6,6.75,'$P$','fontsize',16,'interpreter','latex','color',[1 1 1]);
            block.textQ=text(app.axes_ff,3.6,6.75,'$Q$','fontsize',16,'interpreter','latex','color',[0 0 0]);
            block.z(1)=line(app.axes_ff,[10.5 11.0],[7.00 6.75],'linewidth',2,'color',[0 0 0]);
            block.z(2)=line(app.axes_ff,[10.5 11.0],[6.50 6.75],'linewidth',2,'color',[0 0 0]);
            block.z(3)=line(app.axes_ff,[9.0 11.0],[6.75 6.75],'linewidth',2,'color',[0 0 0]);
            block.v(1)=line(app.axes_ff,[6.5 7.0],[7.00 6.75],'linewidth',2,'color',[1 0 0]);
            block.v(2)=line(app.axes_ff,[6.5 7.0],[6.50 6.75],'linewidth',2,'color',[1 0 0]);
            block.v(3)=line(app.axes_ff,[5.0 7.0],[6.75 6.75],'linewidth',2,'color',[1 0 0]);
            block.u(1)=line(app.axes_ff,[2.5 3.0],[7.00 6.75],'linewidth',2,'color',[0 0 1]);
            block.u(2)=line(app.axes_ff,[2.5 3.0],[6.50 6.75],'linewidth',2,'color',[0 0 1]);
            block.u(3)=line(app.axes_ff,[1.0 3.0],[6.75 6.75],'linewidth',2,'color',[0 0 1]);
        end

        


        
        % Update components that require runtime configuration
        function addRuntimeConfigurations(app)
            
            % Load data for component configuration
            componentData = load('odqlab_App.mat');
            
            % Set component properties that require runtime configuration
            app.connection.UserData = componentData.connection.UserData;
            app.axes_ff.UserData = componentData.axes_ff.UserData;
            app.axes_fbiq.UserData = componentData.axes_fbiq.UserData;
            app.axes_GQ.UserData = componentData.axes_GQ.UserData;
            app.axes_fboq.UserData = componentData.axes_fboq.UserData;
            app.plant_table.BackgroundColor = [1 1 1;0.9608 0.9608 0.9608];
            app.plant_table.ColumnFormat = {[] [] []};
            app.solvers.UserData = componentData.solvers.UserData;
            app.edit_T.UserData = componentData.edit_T.UserData;
            app.edit_uv.UserData = componentData.edit_uv.UserData;
            app.edit_wv.UserData = componentData.edit_wv.UserData;
            app.edit_d.UserData = componentData.edit_d.UserData;
        end
        
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function odqlab_OpeningFcn(app, varargin)
            % --- Executes just before odqlab is made visible.
            
            % Add runtime required configuration - Added by Migration Tool
            addRuntimeConfigurations(app);
            
            % Ensure that the app appears on screen when run
            movegui(app.odq_design, 'onscreen');
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app); %#ok<ASGLU>
            
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





            % Set axis limits
            app.axes_ff.XLim = [1 11];
            app.axes_ff.YLim = [4 9];
            
            % Draw initial block diagram
            app.create_ff_block();

            % Set axis limits
            app.axes_fbiq.XLim = [0 12];
            app.axes_fbiq.YLim = [3 8];
            
            % Draw initial block diagram
            app.create_fbiq_block();

            % Set axis limits
            app.axes_fboq.XLim = [0 12];
            app.axes_fboq.YLim = [3 8];
            
            % Draw initial block diagram
            app.create_fboq_block();

            % Set axis limits
            app.axes_GQ.XLim = [1 11];
            app.axes_GQ.YLim = [3 8];
            
            % Draw initial block diagram
            app.create_GQ_block();
        end

        % Selection changed function: connection
        function connection_SelectionChangeFcn(app, event)
            % --- Executes when selected object is changed in connection.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
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
        end

        % Value changed function: edit_T
        function edit_T_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to edit_T (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hints: get(hObject,'String') returns contents of edit_T as text
            %        str2double(get(hObject,'String')) returns contents of edit_T as a double
            T=str2double(get(hObject,'String'));
            %set(handles.slider_T,'Value',T)
            set(hObject,'UserData',T)
        end

        % Value changed function: edit_d
        function edit_d_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to edit_d (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hints: get(hObject,'String') returns contents of edit_d as text
            %        str2double(get(hObject,'String')) returns contents of edit_d as a double
            d=str2double(get(hObject,'String'));
            %set(handles.slider_d,'Value',d)
            set(hObject,'UserData',d)
        end

        % Value changed function: edit_sv
        function edit_sv_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to edit_sv (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hints: get(hObject,'String') returns contents of edit_sv as text
            %        str2double(get(hObject,'String')) returns contents of edit_sv as a double
            dim=str2double(get(hObject,'string'));
            set(hObject,'UserData',dim);
        end

        % Value changed function: edit_uv
        function edit_uv_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to edit_uv (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hints: get(hObject,'String') returns contents of edit_uv as text
            %        str2double(get(hObject,'String')) returns contents of edit_uv as a double
            gamma.uv=str2double(get(hObject,'String'));
            set(hObject,'UserData',gamma.uv)
        end

        % Value changed function: edit_wv
        function edit_wv_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to edit_wv (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            
            % Hints: get(hObject,'String') returns contents of edit_wv as text
            %        str2double(get(hObject,'String')) returns contents of edit_wv as a double
            gamma.wv=str2double(get(hObject,'String'));
            set(hObject,'UserData',gamma.wv)
        end

        % Button pushed function: excute_button
        function excute_button_Callback(app, event)
            % --- Executes on button press in excute_button.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to excute_button (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            odqdata=get(handles.odq_design,'UserData');
            
            flg=odqdata.flg
            
            if isfield(flg,'DQopen')==1
                if flg.DQopen==1
                    delete(handles.DQ)
                    flg.DQopen=0;
                end
            end
            %{
            if isfield(flg, 'DQopen') && flg.DQopen == 1
                if isvalid(handles.DQ)
                    delete(handles.DQ); % App Designerのアプリを削除
                end
                flg.DQopen = 0;
            end

            % DQ_Appを起動し、必要な引数を渡す
            handles.DQ = DQ_App('ODQ_Designer', handles.odq_design); 
            flg.DQopen = 1;
            %}
            
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
            gamma.uv=get(handles.edit_uv,'UserData');
            gamma.wv=get(handles.edit_wv,'UserData');
            solver=get(handles.solvers,'UserData');
            if size(G.c1*G.b2,2)<size(G.c1*G.b2,1) && T==inf
                % hint=textwrap(handles.message_area,{'Could not derive analytic solution.',...
                %     'Please set Evaluation time for numerical optimization'});
                % set(handles.message_area,'string',hint);
            else
                if isnan(dim)
                [Q E Hk gain]=odq(G,T,d,gamma,[],solver,con);
                else
                [Q E Hk gain]=odq(G,T,d,gamma,dim,solver,con);
                end
                stb=odqstb(Q);
                odqdata.Q=Q;
                odqdata.E=E;
                odqdata.Hk=Hk;
                odqdata.gain=gain;
                odqdata.G=G;
                odqdata.d=d;
                odqdata.con=con;
                set(handles.odq_design,'UserData',odqdata)
            
                %{
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
                %}
                if stb == 0
                    % メッセージ: NOT stable
                    % hint = sprintf(['Optimal quantizer is NOT stable.\n', ...
                    %                 'Please set Evaluation time for numerical optimization.']);
                    % app.message_area.Value = hint; % TextAreaのValueプロパティに設定
                elseif size(Q.a,1) > size(G.a,1)
                    % メッセージ: Dimension too large
                    % hint = sprintf(['The Dimension of the quantizer is maybe too large.\n', ...
                    %                 'The following two approaches are useful to reduce dimension:\n', ...
                    %                 '1. Set small evaluation time OR\n', ...
                    %                 '2. Truncate small singular values.']);
                    % app.message_area.Value = hint; % TextAreaのValueプロパティに設定
                end
            
                handles.DQ=DQ('ODQ_Designer',handles.odq_design);
                flg.DQopen=1;
            end
            odqdata.flg=flg;
            set(handles.odq_design,'UserData',odqdata)
            guidata(hObject,handles);
        end

        % Button pushed function: import_G
        function import_G_Callback(app, event)
            % --- Executes on button press in import_G.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
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
                    plantdata(3,1)=size(G.a,1);
                    plantdata(3,2)=size(G.b1,2);
                    plantdata(3,3)=size(G.c1,1);
                    set(handles.plant_table,'DATA',plantdata)
                end
            end
        end

        % Button pushed function: import_K
        function import_K_Callback(app, event)
            % --- Executes on button press in import_K.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
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
                    plantdata(2,1)=size(K.a,1);
                    plantdata(2,2)=size(K.b1,2);
                    plantdata(2,3)=size(K.c,1);
                    set(handles.plant_table,'DATA',plantdata)
                end
            end
        end

        % Button pushed function: import_P
        function import_P_Callback(app, event)
            % --- Executes on button press in import_P.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
            % hObject    handle to import_P (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            handles.systemP=system_setup_P('ODQ_Designer',handles.odq_design);
            %uiwait(handles.systemP)
            guidata(hObject, handles);
            odqdata=get(handles.odq_design,'UserData');
            if isfield(odqdata,'P')
                P=odqdata.P;
                if isstruct(P)
                    plantdata=get(handles.plant_table,'DATA');
                    plantdata(1,1)=size(P.a,1);
                    plantdata(1,2)=size(P.b,2);
                    plantdata(1,3)=size(P.c1,1);
                    set(handles.plant_table,'DATA',plantdata)
                end
            end
        end

        % Button pushed function: re_design_button
        function re_design_button_Callback(app, event)
            % --- Executes on button press in re_design_button.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
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
            %gamma.wv = get(handles.edit_wv,'UserData');
            Hk = odqdata.Hk;
            [Q, Hk] = odqreal(G,Hk,dim);
            E = odqcost(G,Q,d,T);
            gain = odqgain(Q,T);
            stb=odqstb(Q);
            %{
            if stb==0
                hint=textwrap(handles.message_area,{'Please set T and gamma',...
                    'for numerical optimization'});
                set(handles.message_area,'string',hint)
            end
            %}
            if stb == 0
                    % hint = sprintf(['Please set T and gamma',...
                    % 'for numerical optimization']);
                    % app.message_area.Value = hint; % TextAreaのValueプロパティに設定
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
        end

        % Selection changed function: solvers
        function solvers_SelectionChangeFcn(app, event)
            % --- Executes when selected object is changed in solvers.
            
            % Create GUIDE-style callback args - Added by Migration Tool
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            
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
                    solver='sdpt3';
                case 'radiobutton_sedumi'
                    solver='sedumi';
                case 'radiobutton_gurobi'
                    solver='gurobi';
                  
                % Continue with more cases as necessary.
            %     otherwise
            %        con='null';
            end
            set(handles.solvers,'UserData',solver) %remove the case "hObject=radiobuttonx"
        end

        % Button down function: axes_ff
        function axes_ffButtonDown(app, event)
            %{
            % UIAxesのスケール設定
            app.axes_ff.XLim = [1 11];
            app.axes_ff.YLim = [4 9];
        
            % Draw initial block diagram
            app.create_ff_block();
            %}
        
           %{
            [hObject, eventdata, handles] = convertToGUIDECallbackArguments(app, event); %#ok<ASGLU>
            % Hint: place code in OpeningFcn to populate axes_ff
            axis([1 11 4 9]);
            block=create_ff_block(app, event);
            set(hObject,'UserData',block,'Visible','off')
           %}
             % Clear existing content and redraw
            cla(app.axes_ff);
            app.create_ff_block();
        end

        % Button down function: axes_GQ
        function axes_GQButtonDown(app, event)
            cla(app.axes_GQ);
            app.create_GQ_block();
        end

        % Button down function: axes_fbiq
        function axes_fbiqButtonDown(app, event)
            cla(app.axes_fbiq);
            app.create_fbiq_block();
        end

        % Button down function: axes_fboq
        function axes_fboqButtonDown(app, event)
            cla(app.axes_fboq);
            app.create_fboq_block();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create odq_design and hide until all components are created
            app.odq_design = uifigure('Visible', 'off');
            colormap(app.odq_design, 'parula');
            app.odq_design.Position = [582 238 828 552];
            app.odq_design.Name = 'Design Window';
            app.odq_design.HandleVisibility = 'callback';
            app.odq_design.Tag = 'odq_design';

            % Create connection
            app.connection = uibuttongroup(app.odq_design);
            app.connection.SelectionChangedFcn = createCallbackFcn(app, @connection_SelectionChangeFcn, true);
            app.connection.Title = 'System description';
            app.connection.Tag = 'connection';
            app.connection.FontSize = 12;
            app.connection.Position = [11 126 511 392];

            % Create axes_fbiq
            app.axes_fbiq = uiaxes(app.connection);
            app.axes_fbiq.FontName = 'MS UI Gothic';
            app.axes_fbiq.XLim = [0 12];
            app.axes_fbiq.YLim = [3 8];
            app.axes_fbiq.XTick = zeros(1,0);
            app.axes_fbiq.XTickLabel = '';
            app.axes_fbiq.YTick = zeros(1,0);
            app.axes_fbiq.YTickLabel = '';
            app.axes_fbiq.ZTick = zeros(1,0);
            app.axes_fbiq.ZTickLabel = '';
            app.axes_fbiq.XGrid = 'on';
            app.axes_fbiq.YGrid = 'on';
            app.axes_fbiq.FontSize = 12;
            app.axes_fbiq.NextPlot = 'replace';
            app.axes_fbiq.ButtonDownFcn = createCallbackFcn(app, @axes_fbiqButtonDown, true);
            app.axes_fbiq.Tag = 'axes_fbiq';
            app.axes_fbiq.Visible = 'off';
            app.axes_fbiq.Position = [251 257 235 111];

            % Create axes_GQ
            app.axes_GQ = uiaxes(app.connection);
            app.axes_GQ.FontName = 'MS UI Gothic';
            app.axes_GQ.XLim = [1 11];
            app.axes_GQ.YLim = [3 8];
            app.axes_GQ.XTick = zeros(1,0);
            app.axes_GQ.XTickLabel = '';
            app.axes_GQ.YTick = zeros(1,0);
            app.axes_GQ.YTickLabel = '';
            app.axes_GQ.ZTick = zeros(1,0);
            app.axes_GQ.ZTickLabel = '';
            app.axes_GQ.XGrid = 'on';
            app.axes_GQ.FontSize = 12;
            app.axes_GQ.NextPlot = 'replace';
            app.axes_GQ.ButtonDownFcn = createCallbackFcn(app, @axes_GQButtonDown, true);
            app.axes_GQ.Tag = 'axes_GQ';
            app.axes_GQ.Visible = 'off';
            app.axes_GQ.Position = [27 139 207 111];

            % Create axes_fboq
            app.axes_fboq = uiaxes(app.connection);
            app.axes_fboq.FontName = 'MS UI Gothic';
            app.axes_fboq.XLim = [0 12];
            app.axes_fboq.YLim = [3 8];
            app.axes_fboq.XTick = zeros(1,0);
            app.axes_fboq.XTickLabel = '';
            app.axes_fboq.YTick = zeros(1,0);
            app.axes_fboq.YTickLabel = '';
            app.axes_fboq.ZTick = zeros(1,0);
            app.axes_fboq.ZTickLabel = '';
            app.axes_fboq.XGrid = 'on';
            app.axes_fboq.YGrid = 'on';
            app.axes_fboq.FontSize = 12;
            app.axes_fboq.NextPlot = 'replace';
            app.axes_fboq.ButtonDownFcn = createCallbackFcn(app, @axes_fboqButtonDown, true);
            app.axes_fboq.Tag = 'axes_fboq';
            app.axes_fboq.Visible = 'off';
            app.axes_fboq.Position = [251 139 235 111];

            % Create axes_ff
            app.axes_ff = uiaxes(app.connection);
            app.axes_ff.FontName = 'MS UI Gothic';
            app.axes_ff.XLim = [1 11];
            app.axes_ff.YLim = [4 9];
            app.axes_ff.XTick = [];
            app.axes_ff.XTickLabel = '';
            app.axes_ff.YTick = [];
            app.axes_ff.YTickLabel = '';
            app.axes_ff.ZTick = [];
            app.axes_ff.ZTickLabel = '';
            app.axes_ff.FontSize = 12;
            app.axes_ff.NextPlot = 'replace';
            app.axes_ff.ButtonDownFcn = createCallbackFcn(app, @axes_ffButtonDown, true);
            app.axes_ff.Tag = 'axes_ff';
            app.axes_ff.Visible = 'off';
            app.axes_ff.Position = [27 257 207 111];

            % Create radiobutton_ff
            app.radiobutton_ff = uiradiobutton(app.connection);
            app.radiobutton_ff.Tag = 'radiobutton_ff';
            app.radiobutton_ff.Text = 'Feedforward connection';
            app.radiobutton_ff.FontSize = 12;
            app.radiobutton_ff.Position = [42 257 154 25];
            app.radiobutton_ff.Value = true;

            % Create radiobutton_fbiq
            app.radiobutton_fbiq = uiradiobutton(app.connection);
            app.radiobutton_fbiq.Tag = 'radiobutton_fbiq';
            app.radiobutton_fbiq.Text = 'Feedback connection with input quantizer';
            app.radiobutton_fbiq.FontSize = 12;
            app.radiobutton_fbiq.Position = [247 257 245.466666666667 25];

            % Create radiobutton_GQ
            app.radiobutton_GQ = uiradiobutton(app.connection);
            app.radiobutton_GQ.Tag = 'radiobutton_GQ';
            app.radiobutton_GQ.Text = 'LFT connection';
            app.radiobutton_GQ.FontSize = 12;
            app.radiobutton_GQ.Position = [65 142 107.333333333333 25];

            % Create radiobutton_fboq
            app.radiobutton_fboq = uiradiobutton(app.connection);
            app.radiobutton_fboq.Tag = 'radiobutton_fboq';
            app.radiobutton_fboq.Text = 'Feedback connection with output quantizer';
            app.radiobutton_fboq.FontSize = 12;
            app.radiobutton_fboq.Position = [247 142 251.066666666667 25];

            % Create import_P
            app.import_P = uibutton(app.connection, 'push');
            app.import_P.ButtonPushedFcn = createCallbackFcn(app, @import_P_Callback, true);
            app.import_P.Tag = 'import_P';
            app.import_P.FontSize = 12;
            app.import_P.Position = [372 78 76.5333333333333 22];
            app.import_P.Text = 'Set P';

            % Create import_K
            app.import_K = uibutton(app.connection, 'push');
            app.import_K.ButtonPushedFcn = createCallbackFcn(app, @import_K_Callback, true);
            app.import_K.Tag = 'import_K';
            app.import_K.FontSize = 12;
            app.import_K.Position = [372 55 76.5333333333333 22];
            app.import_K.Text = 'Set K';

            % Create import_G
            app.import_G = uibutton(app.connection, 'push');
            app.import_G.ButtonPushedFcn = createCallbackFcn(app, @import_G_Callback, true);
            app.import_G.Tag = 'import_G';
            app.import_G.FontSize = 12;
            app.import_G.Position = [372 32 76.5333333333333 22];
            app.import_G.Text = 'Set G';

            % Create plant_table
            app.plant_table = uitable(app.connection);
            app.plant_table.ColumnName = {'Dimention'; 'Inputs'; 'Outputs'};
            app.plant_table.RowName = {'P'; 'K'; 'G'};
            app.plant_table.ColumnEditable = [false false false];
            app.plant_table.Tag = 'plant_table';
            app.plant_table.FontSize = 12;
            app.plant_table.Position = [27 12 285 117];

            % Create text10
            app.text10 = uilabel(app.odq_design);
            app.text10.Tag = 'text10';
            app.text10.HorizontalAlignment = 'center';
            app.text10.VerticalAlignment = 'top';
            app.text10.WordWrap = 'on';
            app.text10.FontSize = 24;
            app.text10.FontWeight = 'bold';
            app.text10.Position = [332 521 168.933333333333 32];
            app.text10.Text = 'ODQLab';

            % Create uipanel9
            app.uipanel9 = uipanel(app.odq_design);
            app.uipanel9.Title = 'Quantizer specification';
            app.uipanel9.Tag = 'uipanel9';
            app.uipanel9.FontSize = 12;
            app.uipanel9.Position = [530 239 289 279];

            % Create solvers
            app.solvers = uibuttongroup(app.uipanel9);
            app.solvers.SelectionChangedFcn = createCallbackFcn(app, @solvers_SelectionChangeFcn, true);
            app.solvers.Title = 'LP solver';
            app.solvers.Tag = 'solvers';
            app.solvers.FontSize = 12;
            app.solvers.Position = [157 98 124 151];

            % Create radiobutton_linprog
            app.radiobutton_linprog = uiradiobutton(app.solvers);
            app.radiobutton_linprog.Tag = 'radiobutton_linprog';
            app.radiobutton_linprog.Text = 'linprog';
            app.radiobutton_linprog.FontSize = 12;
            app.radiobutton_linprog.Position = [26 107 58.8 23];
            app.radiobutton_linprog.Value = true;

            % Create radiobutton_cplex
            app.radiobutton_cplex = uiradiobutton(app.solvers);
            app.radiobutton_cplex.Tag = 'radiobutton_cplex';
            app.radiobutton_cplex.Text = 'cplex';
            app.radiobutton_cplex.FontSize = 12;
            app.radiobutton_cplex.Position = [27 86 58.8 23];

            % Create radiobutton_sdpt3
            app.radiobutton_sdpt3 = uiradiobutton(app.solvers);
            app.radiobutton_sdpt3.Tag = 'radiobutton_sdpt3';
            app.radiobutton_sdpt3.Text = 'SDPT3';
            app.radiobutton_sdpt3.FontSize = 12;
            app.radiobutton_sdpt3.Position = [28 64 58.8 23];

            % Create radiobutton_sedumi
            app.radiobutton_sedumi = uiradiobutton(app.solvers);
            app.radiobutton_sedumi.Tag = 'radiobutton_sdpt3';
            app.radiobutton_sedumi.Text = 'SEDUMI';
            app.radiobutton_sedumi.FontSize = 12;
            app.radiobutton_sedumi.Position = [27 42 69 23];

            % Create radiobutton_gurobi
            app.radiobutton_gurobi = uiradiobutton(app.solvers);
            app.radiobutton_gurobi.Tag = 'radiobutton_sdpt3';
            app.radiobutton_gurobi.Text = 'Gurobi';
            app.radiobutton_gurobi.FontSize = 12;
            app.radiobutton_gurobi.Position = [27 16 69 23];

            % Create uipanel4
            app.uipanel4 = uipanel(app.uipanel9);
            app.uipanel4.Title = 'Evaluation period';
            app.uipanel4.Tag = 'uipanel4';
            app.uipanel4.FontSize = 12;
            app.uipanel4.Position = [19 126 113 51];

            % Create edit_T
            app.edit_T = uieditfield(app.uipanel4, 'text');
            app.edit_T.ValueChangedFcn = createCallbackFcn(app, @edit_T_Callback, true);
            app.edit_T.Tag = 'edit_T';
            app.edit_T.FontSize = 12;
            app.edit_T.Position = [17 10 74.6666666666667 19];
            app.edit_T.Value = 'Inf';

            % Create uipanel11
            app.uipanel11 = uipanel(app.uipanel9);
            app.uipanel11.Title = 'Quantizer gain';
            app.uipanel11.Tag = 'uipanel11';
            app.uipanel11.FontSize = 12;
            app.uipanel11.Position = [20 15 112 92];

            % Create edit_uv
            app.edit_uv = uieditfield(app.uipanel11, 'text');
            app.edit_uv.ValueChangedFcn = createCallbackFcn(app, @edit_uv_Callback, true);
            app.edit_uv.Tag = 'edit_uv';
            app.edit_uv.FontSize = 12;
            app.edit_uv.Position = [61 45 38 19];
            app.edit_uv.Value = 'Inf';

            % Create edit_wv
            app.edit_wv = uieditfield(app.uipanel11, 'text');
            app.edit_wv.ValueChangedFcn = createCallbackFcn(app, @edit_wv_Callback, true);
            app.edit_wv.Tag = 'edit_wv';
            app.edit_wv.FontSize = 12;
            app.edit_wv.Position = [61 14 38 19];
            app.edit_wv.Value = 'Inf';

            % Create uvLabel
            app.uvLabel = uilabel(app.uipanel11);
            app.uvLabel.Position = [13 43 35 22];
            app.uvLabel.Text = 'u -> v';

            % Create wvLabel
            app.wvLabel = uilabel(app.uipanel11);
            app.wvLabel.Position = [12 12 37 22];
            app.wvLabel.Text = 'w -> v';

            % Create excute_button
            app.excute_button = uibutton(app.uipanel9, 'push');
            app.excute_button.ButtonPushedFcn = createCallbackFcn(app, @excute_button_Callback, true);
            app.excute_button.Tag = 'excute_button';
            app.excute_button.FontSize = 12;
            app.excute_button.Position = [188 55 77 23];
            app.excute_button.Text = 'Design';

            % Create uipanel5
            app.uipanel5 = uipanel(app.uipanel9);
            app.uipanel5.Title = 'Quantization interval';
            app.uipanel5.Tag = 'uipanel5';
            app.uipanel5.FontSize = 12;
            app.uipanel5.Position = [19 197 122 52];

            % Create edit_d
            app.edit_d = uieditfield(app.uipanel5, 'text');
            app.edit_d.ValueChangedFcn = createCallbackFcn(app, @edit_d_Callback, true);
            app.edit_d.Tag = 'edit_d';
            app.edit_d.FontSize = 12;
            app.edit_d.Position = [16 10 74.6666666666667 19];
            app.edit_d.Value = '1';

            % Create Quantizer_reduction
            app.Quantizer_reduction = uipanel(app.odq_design);
            app.Quantizer_reduction.Title = 'Quantizer reduction';
            app.Quantizer_reduction.Tag = 'uipanel10';
            app.Quantizer_reduction.FontSize = 12;
            app.Quantizer_reduction.Position = [530 126 289 91];

            % Create Quantizer_Dimention
            app.Quantizer_Dimention = uilabel(app.Quantizer_reduction);
            app.Quantizer_Dimention.Tag = 'text8';
            app.Quantizer_Dimention.HorizontalAlignment = 'center';
            app.Quantizer_Dimention.VerticalAlignment = 'top';
            app.Quantizer_Dimention.WordWrap = 'on';
            app.Quantizer_Dimention.FontSize = 12;
            app.Quantizer_Dimention.Position = [9.4 26.1428571428571 84 31];
            app.Quantizer_Dimention.Text = {'Quantizer'; 'Dimension'};

            % Create edit_sv
            app.edit_sv = uieditfield(app.Quantizer_reduction, 'text');
            app.edit_sv.ValueChangedFcn = createCallbackFcn(app, @edit_sv_Callback, true);
            app.edit_sv.Tag = 'edit_sv';
            app.edit_sv.FontSize = 12;
            app.edit_sv.Position = [98.0666666666667 32.1428571428571 70 19];

            % Create re_design_button
            app.re_design_button = uibutton(app.Quantizer_reduction, 'push');
            app.re_design_button.ButtonPushedFcn = createCallbackFcn(app, @re_design_button_Callback, true);
            app.re_design_button.Tag = 're_design_button';
            app.re_design_button.FontSize = 12;
            app.re_design_button.Position = [186.733333333333 31.1428571428571 76.5333333333333 22];
            app.re_design_button.Text = 'Reduce';

            % Create MessageTextAreaLabel_2
            app.MessageTextAreaLabel_2 = uilabel(app.odq_design);
            app.MessageTextAreaLabel_2.HorizontalAlignment = 'right';
            app.MessageTextAreaLabel_2.Position = [23 72 54 22];
            app.MessageTextAreaLabel_2.Text = 'Message';

            % Show the figure after all components are created
            app.odq_design.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = odqlab_App_exported(varargin)

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.odq_design)

                % Execute the startup function
                runStartupFcn(app, @(app)odqlab_OpeningFcn(app, varargin{:}))
            else

                % Focus the running singleton app
                figure(runningApp.odq_design)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.odq_design)
        end
    end
end