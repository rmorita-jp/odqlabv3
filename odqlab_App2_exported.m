classdef odqlab_App2_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        odq_design                   matlab.ui.Figure
        ODQLabLabel                  matlab.ui.control.Label
        MessageTextArea              matlab.ui.control.TextArea
        MessageTextAreaLabel         matlab.ui.control.Label
        quantizer_deduction          matlab.ui.container.Panel
        re_design_button             matlab.ui.control.Button
        edit_sv                      matlab.ui.control.EditField
        QuantizerDementionEditFieldLabel  matlab.ui.control.Label
        QuantizerspecificationPanel  matlab.ui.container.Panel
        DesignButton                 matlab.ui.control.Button
        solvers                      matlab.ui.container.ButtonGroup
        radiobutton_mosek            matlab.ui.control.RadioButton
        radiobutton_gurobi           matlab.ui.control.RadioButton
        radiobutton_sedumi           matlab.ui.control.RadioButton
        radiobutton_sdpt3            matlab.ui.control.RadioButton
        radiobutton_cplex            matlab.ui.control.RadioButton
        radiobutton_linprog          matlab.ui.control.RadioButton
        QuantizergainPanel           matlab.ui.container.Panel
        edit_wv                      matlab.ui.control.EditField
        wvLabel                      matlab.ui.control.Label
        edit_uv                      matlab.ui.control.EditField
        uvEditFieldLabel             matlab.ui.control.Label
        EvaluationperiodPanel        matlab.ui.container.Panel
        edit_T                       matlab.ui.control.EditField
        QuantizationintervalPanel    matlab.ui.container.Panel
        edit_d                       matlab.ui.control.EditField
        connection                   matlab.ui.container.ButtonGroup
        import_P                     matlab.ui.control.Button
        plant_table                  matlab.ui.control.Table
        import_G                     matlab.ui.control.Button
        import_K                     matlab.ui.control.Button
        radiobutton_fboq             matlab.ui.control.RadioButton
        radiobutton_GQ               matlab.ui.control.RadioButton
        radiobutton_fbiq             matlab.ui.control.RadioButton
        radiobutton_ff               matlab.ui.control.RadioButton
        axes_GQ                      matlab.ui.control.UIAxes
        axes_fboq                    matlab.ui.control.UIAxes
        axes_ff                      matlab.ui.control.UIAxes
        axes_fbiq                    matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        odqdata
        systemG
        systemP
        systemK
        selectedSolver
        DQ

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
        function odqlab_StartupFcn(app, odq_design)
            % --- Executes just before odqlab is made visible.
            
            % Add runtime required configuration - Added by Migration Tool
            addRuntimeConfigurations(app);
            
            % Ensure that the app appears on screen when run
            movegui(app.odq_design, 'onscreen');
            
            % This function has no output args, see OutputFcn.
            % hObject    handle to figure
            % eventdata  reserved - to be defined in a future version of MATLAB
            % app    structure with app and user data (see GUIDATA)
            % varargin   unrecognized PropertyName/PropertyValue pairs from the
            %            command line (see VARARGIN)
            
            % UIWAIT makes odqlab wait for user response (see UIRESUME)
            % uiwait(app.odq_design);
            app.odqdata.flg.ODQopen=1;
            app.odqdata.connection='ff';
            app.odq_design.UserData=app.odqdata;


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

            %app.plant_table.Data = double(3,1); % 空のセル配列を Data に追加
            rowNames = {'P','K','G'};
            app.plant_table.RowName = rowNames;
        end

        % Selection changed function: connection
        function connectionSelectionChanged(app, event)
            % --- Executes when selected object is changed in connection.
            
            
            %	EventName: string 'SelectionChanged' (read only)
            %	OldValue: handle of the previously selected object or empty if none was selected
            %	NewValue: handle of the currently selected object
            % app    structure with app and user data (see GUIDATA)
            
            %odqdata=get(app.odq_design,'UserData');
            selectButton=event.NewValue;

            switch selectButton.Tag % Get Tag of selected object.
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
            disp(con);
            app.odqdata.connection=con;
            app.connection.UserData=con; %remove the case "hObject=radiobuttonx"
            app.odq_design.UserData=app.odqdata;
        end

        % Value changed function: edit_T
        function edit_T_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            
            % hObject    handle to edit_T (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % app    structure with app and user data (see GUIDATA)
            
            T=str2double(app.edit_T.Value);
            app.edit_T.UserData=T;
            disp(T);
        end

        % Value changed function: edit_d
        function edit_d_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
           
            
            % hObject    handle to edit_d (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % app    structure with app and user data (see GUIDATA)
            
            % Hints: get(hObject,'String') returns contents of edit_d as text
            %        str2double(get(hObject,'String')) returns contents of edit_d as a double
            d=str2double(app.edit_d.Value);
            app.edit_d.UserData=d;
            disp(d);
        end

        % Value changed function: edit_sv
        function edit_sv_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            
            % hObject    handle to edit_sv (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % app    structure with app and user data (see GUIDATA)
            
            % Hints: get(hObject,'String') returns contents of edit_sv as text
            %        str2double(get(hObject,'String')) returns contents of edit_sv as a double
            dim=str2double(app.edit_sv.Value);
            app.edit_sv.UserData=dim;
            disp(dim);
        end

        % Value changed function: edit_uv
        function edit_uv_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            
            % Hints: get(hObject,'String') returns contents of edit_uv as text
            %        str2double(get(hObject,'String')) returns contents of edit_uv as a double
            gamma.uv=str2double(app.edit_uv.Value);
            app.edit_uv.UserData=gamma.uv;
            disp(gamma.uv);
        end

        % Value changed function: edit_wv
        function edit_wv_Callback(app, event)
            % Create GUIDE-style callback args - Added by Migration Tool
            % app    structure with app and user data (see GUIDATA)
            
            % Hints: get(hObject,'String') returns contents of edit_wv as text
            %        str2double(get(hObject,'String')) returns contents of edit_wv as a double
            gamma.wv=str2double(app.edit_wv.Value);
            app.edit_wv.UserData=gamma.wv;
            disp(gamma.wv);
        end

        % Button pushed function: DesignButton
        function DesignButton_Callback(app, event)
            % --- Executes on button press in excute_button.
            
            % hObject    handle to excute_button (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % app    structure with app and user data (see GUIDATA)
            app.odqdata=app.odq_design.UserData;           
            flg=app.odqdata.flg;
            
            if isfield(flg,'DQopen')==1
                if flg.DQopen==1
                    delete(app.DQ)
                    flg.DQopen=0;
                end
            end
            %{
            if isfield(flg, 'DQopen') && flg.DQopen == 1
                if isvalid(app.DQ)
                    delete(app.DQ); % App Designerのアプリを削除
                end
                flg.DQopen = 0;
            end

            % DQ_Appを起動し、必要な引数を渡す
            app.DQ = DQ_App('ODQ_Designer', app.odq_design); 
            flg.DQopen = 1;
            %}
            
            con=app.connection.UserData;
            if strcmp(con,'GQ')
                % G=get(app.import_G,'UserData');
                G=app.odqdata.G;

            else
                P=app.odqdata.P;
                % P=get(app.import_P,'UserData');
                if strcmp(con,'ff')
                    K=[];
                else
                    % K=get(app.import_K,'UserData');
                    K=app.odqdata.K;
                end
                G=compg(P,K,con);
            end
            T=app.edit_T.UserData;
            d=app.edit_d.UserData;
            dim=app.edit_sv.UserData;
            gamma.uv=app.edit_uv.UserData;
            gamma.wv=app.edit_wv.UserData;
            solver=app.solvers.UserData;
            if size(G.c1*G.b2,2)<size(G.c1*G.b2,1) && T==inf
                % hint=textwrap(app.message_area,{'Could not derive analytic solution.',...
                %     'Please set Evaluation time for numerical optimization'});
                % set(app.message_area,'string',hint);
                app.MessageTextArea.Value=['Could not derive analytic solution.',...
                     'Please set Evaluation time for numerical optimization'];
            else
                if isnan(dim)
                [Q, E, Hk, gain]=odq(G,T,d,gamma,[],solver,con);
                else
                [Q, E, Hk, gain]=odq(G,T,d,gamma,dim,solver,con);
                end
                stb=odqstb(Q);
                app.odqdata.Q=Q;
                app.odqdata.E=E;
                app.odqdata.Hk=Hk;
                app.odqdata.gain=gain;
                app.odqdata.G=G;
                app.odqdata.d=d;
                app.odqdata.con=con;
                app.odq_design.UserData=app.odqdata;
                
                if stb == 0
                    % メッセージ: NOT stable
                     app.MessageTextArea.Value = ['Optimal quantizer is NOT stable.\n', ...
                                     'Please set Evaluation time for numerical optimization.'];
                elseif size(Q.a,1) > size(G.a,1)
                     app.MessageTextArea.Value =['The Dimension of the quantizer is maybe too large.\n', ...
                                     'The following two approaches are useful to reduce dimension:\n', ...
                                     '1. Set small evaluation time OR\n', ...
                                     '2. Truncate small singular values.'];
                end
            
                %app.DQ=DQ('ODQ_Designer',app.odq_design);
                %flg.DQopen=1;

                if isempty(app.DQ) || ~isvalid(app.DQ)
                    app.DQ = DQ_App(app.odq_design);
                    flg.DQopen = 1;
                else
                    figure(app.DQ.UIFigure); % すでに開いているならフォーカス
                end

            end
            app.odqdata.flg=flg;
            app.odq_design.UserData=app.odqdata;
        end

        % Button pushed function: import_G
        function import_G_Callback(app, event)
            % --- Executes on button press in import_G.
            
            app.systemG=system_setup_G(app.odq_design);
            uiwait(app.systemG.odq_design);
            app.odqdata=app.odq_design.UserData;
            
            if isfield(app.odqdata,'G')
                G=app.odqdata.G;
                if isstruct(G)
                    plantdata=app.plant_table.Data;
                    plantdata(3,1)=size(G.a,1);
                    plantdata(3,2)=size(G.b1,2);
                    plantdata(3,3)=size(G.c1,1);
                    app.plant_table.Data=plantdata;
                    drawnow;
                end
            end
        end

        % Button pushed function: import_K
        function import_K_Callback(app, event)
            % --- Executes on button press in import_K.
            
            app.systemK=system_setup_K(app.odq_design);
            uiwait(app.systemK.odq_design);
            app.odqdata=app.odq_design.UserData;

            if isfield(app.odqdata,'K')
                K=app.odqdata.K;
                if isstruct(K)
                    plantdata=app.plant_table.Data;
                    plantdata(2,1)=size(K.a,1);
                    plantdata(2,2)=size(K.b1,2);
                    plantdata(2,3)=size(K.c,1);
                    app.plant_table.Data=plantdata;
                    drawnow;
                end
            end
        end

        % Button pushed function: import_P
        function import_P_Callback(app, event)
            % --- Executes on button press in import_P.
            
            app.systemP=system_setup_P(app.odq_design);
            uiwait(app.systemP.odq_design);
            app.odqdata=app.odq_design.UserData;

            if isfield(app.odqdata,'P')
                P=app.odqdata.P;
                if isstruct(P)
                    plantdata=app.plant_table.Data;
                    plantdata(1,1)=size(P.a,1);
                    plantdata(1,2)=size(P.b,2);
                    plantdata(1,3)=size(P.c1,1);
                    app.plant_table.Data=plantdata;
                    drawnow;
                end
            end
        end

        % Button pushed function: re_design_button
        function re_design_button_Callback(app, event)
            % --- Executes on button press in re_design_button.
            
            % hObject    handle to re_design_button (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % app    structure with app and user data (see GUIDATA)
            %global Q E Hk gain G d
            app.odqdata=app.odq_design.UserData;
            flg=app.odqdata.flg;
            if isfield(flg,'DQopen')==1
                if flg.DQopen==1
                    delete(app.DQ)
                    flg.DQopen=0;
                end
            end

            con=app.connection.UserData;
            if strcmp(con,'GQ')
                % G=get(app.import_G,'UserData');
                G=app.odqdata.G;
            else
                P=app.odqdata.P;
                % P=get(app.import_P,'UserData');
                if strcmp(con,'ff')
                    K=[];
                else
                    % K=get(app.import_K,'UserData');
                    K=app.odqdata.K;
                end
                G=compg(P,K,con);
            end
            T = app.edit_T.UserData;
            d = app.edit_d.UserData;
            dim = app.edit_sv.UserData;
            %gamma.wv = get(app.edit_wv,'UserData');
            Hk = app.odqdata.Hk;
            [Q, Hk] = odqreal(G,Hk,dim);
            E = odqcost(G,Q,d,T);
            gain = odqgain(Q,T);
            stb=odqstb(Q);
            %{
            if stb==0
                hint=textwrap(app.message_area,{'Please set T and gamma',...
                    'for numerical optimization'});
                set(app.message_area,'string',hint)
            end
            %}
            if stb == 0
                     hint = sprintf(['Please set T and gamma',...
                     'for numerical optimization']);
                     app.message_area.Value = hint; % TextAreaのValueプロパティに設定
            end
            app.odqdata.Q=Q;
            app.odqdata.E=E;
            app.odqdata.Hk=Hk;
            app.odqdata.gain=gain;
            app.odqdata.G=G;
            app.odqdata.d=d;
            app.odq_design.UserData=app.odqdata;
            app.DQ=app.DQ('ODQ_Designer',app.odq_design);
            flg.DQopen=1;
            app.odqdata.flg=flg;
            app.odq_design.UserData=app.odqdata;
        end

        % Selection changed function: solvers
        function solversSelectionChanged(app, event)
            selectedButton = event.NewValue;
        
            switch selectedButton.Tag  % Tagプロパティを設定することを推奨
                case 'radiobutton_linprog'
                    app.selectedSolver = 'linprog';
                case 'radiobutton_cplex'
                    app.selectedSolver = 'cplex';
                case 'radiobutton_sdpt3'
                    app.selectedSolver = 'sdpt3';
                case 'radiobutton_sedumi'
                    app.selectedSolver = 'sedumi';
                case 'radiobutton_gurobi'
                    app.selectedSolver = 'gurobi';
                case 'radiobutton_mosek'
                    app.selectedSolver = 'mosek';
                otherwise
                    app.selectedSolver = 'unknown';
            end
        
            disp(['solver: ', app.selectedSolver]);
            app.odqdata.solvers=app.selectedSolver;
            app.solvers.UserData=app.selectedSolver; %remove the case "hObject=radiobuttonx"
            app.odq_design.UserData=app.odqdata;
        end

        % Button down function: axes_ff
        function axes_ffButtonDown(app, event)
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
            app.odq_design.Position = [100 100 859 516];
            app.odq_design.Name = 'MATLAB App';

            % Create connection
            app.connection = uibuttongroup(app.odq_design);
            app.connection.SelectionChangedFcn = createCallbackFcn(app, @connectionSelectionChanged, true);
            app.connection.Title = 'System description';
            app.connection.Position = [11 94 511 392];

            % Create axes_fbiq
            app.axes_fbiq = uiaxes(app.connection);
            app.axes_fbiq.FontName = 'MS UI Gothic';
            app.axes_fbiq.XTick = [];
            app.axes_fbiq.YTick = [];
            app.axes_fbiq.ButtonDownFcn = createCallbackFcn(app, @axes_fbiqButtonDown, true);
            app.axes_fbiq.Tag = 'axes_fbiq';
            app.axes_fbiq.Visible = 'off';
            app.axes_fbiq.Position = [251 257 235 111];

            % Create axes_ff
            app.axes_ff = uiaxes(app.connection);
            app.axes_ff.FontName = 'MS UI Gothic';
            app.axes_ff.XLim = [1 11];
            app.axes_ff.YLim = [4 9];
            app.axes_ff.XTick = [];
            app.axes_ff.XTickLabel = '';
            app.axes_ff.YTick = [];
            app.axes_ff.YTickLabel = '';
            app.axes_ff.NextPlot = 'replace';
            app.axes_ff.ButtonDownFcn = createCallbackFcn(app, @axes_ffButtonDown, true);
            app.axes_ff.Tag = 'axes_ff';
            app.axes_ff.Visible = 'off';
            app.axes_ff.Position = [27 257 207 111];

            % Create axes_fboq
            app.axes_fboq = uiaxes(app.connection);
            app.axes_fboq.FontName = 'MS UI Gothic';
            app.axes_fboq.XTick = [];
            app.axes_fboq.YTick = [];
            app.axes_fboq.ButtonDownFcn = createCallbackFcn(app, @axes_fboqButtonDown, true);
            app.axes_fboq.Visible = 'off';
            app.axes_fboq.Position = [251 139 235 111];

            % Create axes_GQ
            app.axes_GQ = uiaxes(app.connection);
            app.axes_GQ.FontName = 'MS UI Gothic';
            app.axes_GQ.XTick = [];
            app.axes_GQ.YTick = [];
            app.axes_GQ.ButtonDownFcn = createCallbackFcn(app, @axes_GQButtonDown, true);
            app.axes_GQ.Tag = 'axes_GQ';
            app.axes_GQ.Visible = 'off';
            app.axes_GQ.Position = [27 139 207 111];

            % Create radiobutton_ff
            app.radiobutton_ff = uiradiobutton(app.connection);
            app.radiobutton_ff.Tag = 'radiobutton_ff';
            app.radiobutton_ff.Text = 'Feedforward connection';
            app.radiobutton_ff.Position = [53 257 151 22];
            app.radiobutton_ff.Value = true;

            % Create radiobutton_fbiq
            app.radiobutton_fbiq = uiradiobutton(app.connection);
            app.radiobutton_fbiq.Tag = 'radiobutton_fbiq';
            app.radiobutton_fbiq.Text = 'Feedback connection with input quantizer';
            app.radiobutton_fbiq.Position = [246 258 245 22];

            % Create radiobutton_GQ
            app.radiobutton_GQ = uiradiobutton(app.connection);
            app.radiobutton_GQ.Tag = 'radiobutton_GQ';
            app.radiobutton_GQ.Text = 'LFT connection';
            app.radiobutton_GQ.Position = [75 142 105 22];

            % Create radiobutton_fboq
            app.radiobutton_fboq = uiradiobutton(app.connection);
            app.radiobutton_fboq.Tag = 'radiobutton_fboq';
            app.radiobutton_fboq.Text = 'Feedback connection with output quantizer';
            app.radiobutton_fboq.Position = [246 142 252 22];

            % Create import_K
            app.import_K = uibutton(app.connection, 'push');
            app.import_K.ButtonPushedFcn = createCallbackFcn(app, @import_K_Callback, true);
            app.import_K.Position = [372 55 77 22];
            app.import_K.Text = 'Set K';

            % Create import_G
            app.import_G = uibutton(app.connection, 'push');
            app.import_G.ButtonPushedFcn = createCallbackFcn(app, @import_G_Callback, true);
            app.import_G.Position = [372 32 77 22];
            app.import_G.Text = 'Set G';

            % Create plant_table
            app.plant_table = uitable(app.connection);
            app.plant_table.ColumnName = {'Dimention'; 'Inputs'; 'Outputs'};
            app.plant_table.RowName = {};
            app.plant_table.Position = [27 12 285 117];

            % Create import_P
            app.import_P = uibutton(app.connection, 'push');
            app.import_P.ButtonPushedFcn = createCallbackFcn(app, @import_P_Callback, true);
            app.import_P.Position = [372 78 77 22];
            app.import_P.Text = 'Set P';

            % Create QuantizerspecificationPanel
            app.QuantizerspecificationPanel = uipanel(app.odq_design);
            app.QuantizerspecificationPanel.Title = 'Quantizer specification';
            app.QuantizerspecificationPanel.Position = [532 207 289 279];

            % Create QuantizationintervalPanel
            app.QuantizationintervalPanel = uipanel(app.QuantizerspecificationPanel);
            app.QuantizationintervalPanel.Title = 'Quantization interval';
            app.QuantizationintervalPanel.Position = [10 197 120 52];

            % Create edit_d
            app.edit_d = uieditfield(app.QuantizationintervalPanel, 'text');
            app.edit_d.ValueChangedFcn = createCallbackFcn(app, @edit_d_Callback, true);
            app.edit_d.Position = [16 10 75 19];
            app.edit_d.Value = '1';

            % Create EvaluationperiodPanel
            app.EvaluationperiodPanel = uipanel(app.QuantizerspecificationPanel);
            app.EvaluationperiodPanel.Title = 'Evaluation period';
            app.EvaluationperiodPanel.Position = [10 136 120 51];

            % Create edit_T
            app.edit_T = uieditfield(app.EvaluationperiodPanel, 'text');
            app.edit_T.ValueChangedFcn = createCallbackFcn(app, @edit_T_Callback, true);
            app.edit_T.Position = [17 10 75 19];
            app.edit_T.Value = 'Inf';

            % Create QuantizergainPanel
            app.QuantizergainPanel = uipanel(app.QuantizerspecificationPanel);
            app.QuantizergainPanel.Title = 'Quantizer gain';
            app.QuantizergainPanel.Position = [10 34 120 92];

            % Create uvEditFieldLabel
            app.uvEditFieldLabel = uilabel(app.QuantizergainPanel);
            app.uvEditFieldLabel.HorizontalAlignment = 'right';
            app.uvEditFieldLabel.Position = [15 40 35 22];
            app.uvEditFieldLabel.Text = 'u -> v';

            % Create edit_uv
            app.edit_uv = uieditfield(app.QuantizergainPanel, 'text');
            app.edit_uv.ValueChangedFcn = createCallbackFcn(app, @edit_uv_Callback, true);
            app.edit_uv.Tag = 'edit_uv';
            app.edit_uv.Position = [65 40 33 22];
            app.edit_uv.Value = 'Inf';

            % Create wvLabel
            app.wvLabel = uilabel(app.QuantizergainPanel);
            app.wvLabel.HorizontalAlignment = 'right';
            app.wvLabel.Position = [13 10 37 22];
            app.wvLabel.Text = 'w -> v';

            % Create edit_wv
            app.edit_wv = uieditfield(app.QuantizergainPanel, 'text');
            app.edit_wv.ValueChangedFcn = createCallbackFcn(app, @edit_wv_Callback, true);
            app.edit_wv.Tag = 'edit_wv';
            app.edit_wv.Position = [65 10 33 22];
            app.edit_wv.Value = 'Inf';

            % Create solvers
            app.solvers = uibuttongroup(app.QuantizerspecificationPanel);
            app.solvers.SelectionChangedFcn = createCallbackFcn(app, @solversSelectionChanged, true);
            app.solvers.Title = 'LP solvers';
            app.solvers.Position = [141 85 139 164];

            % Create radiobutton_linprog
            app.radiobutton_linprog = uiradiobutton(app.solvers);
            app.radiobutton_linprog.Tag = 'radiobutton_linprog';
            app.radiobutton_linprog.Text = 'linprog';
            app.radiobutton_linprog.Position = [29 119 65 22];
            app.radiobutton_linprog.Value = true;

            % Create radiobutton_cplex
            app.radiobutton_cplex = uiradiobutton(app.solvers);
            app.radiobutton_cplex.Tag = 'radiobutton_cplex';
            app.radiobutton_cplex.Text = 'CPLEX';
            app.radiobutton_cplex.Position = [29 97 65 22];

            % Create radiobutton_sdpt3
            app.radiobutton_sdpt3 = uiradiobutton(app.solvers);
            app.radiobutton_sdpt3.Tag = 'radiobutton_sdpt3';
            app.radiobutton_sdpt3.Text = 'SDPT3';
            app.radiobutton_sdpt3.Position = [29 75 65 22];

            % Create radiobutton_sedumi
            app.radiobutton_sedumi = uiradiobutton(app.solvers);
            app.radiobutton_sedumi.Tag = 'radiobutton_sedumi';
            app.radiobutton_sedumi.Text = 'SeDuMi';
            app.radiobutton_sedumi.Position = [29 51 65 22];

            % Create radiobutton_gurobi
            app.radiobutton_gurobi = uiradiobutton(app.solvers);
            app.radiobutton_gurobi.Tag = 'radiobutton_gurobi';
            app.radiobutton_gurobi.Text = 'Gurobi';
            app.radiobutton_gurobi.Position = [29 29 65 22];

            % Create radiobutton_mosek
            app.radiobutton_mosek = uiradiobutton(app.solvers);
            app.radiobutton_mosek.Tag = 'radiobutton_mosek';
            app.radiobutton_mosek.Text = 'MOSEK';
            app.radiobutton_mosek.Position = [29 8 65 22];

            % Create DesignButton
            app.DesignButton = uibutton(app.QuantizerspecificationPanel, 'push');
            app.DesignButton.ButtonPushedFcn = createCallbackFcn(app, @DesignButton_Callback, true);
            app.DesignButton.Position = [190 12 77 23];
            app.DesignButton.Text = 'Design';

            % Create quantizer_deduction
            app.quantizer_deduction = uipanel(app.odq_design);
            app.quantizer_deduction.Title = 'Panel5';
            app.quantizer_deduction.Position = [533 94 289 91];

            % Create QuantizerDementionEditFieldLabel
            app.QuantizerDementionEditFieldLabel = uilabel(app.quantizer_deduction);
            app.QuantizerDementionEditFieldLabel.HorizontalAlignment = 'right';
            app.QuantizerDementionEditFieldLabel.Position = [15 23 63 30];
            app.QuantizerDementionEditFieldLabel.Text = {'Quantizer '; 'Demention'};

            % Create edit_sv
            app.edit_sv = uieditfield(app.quantizer_deduction, 'text');
            app.edit_sv.ValueChangedFcn = createCallbackFcn(app, @edit_sv_Callback, true);
            app.edit_sv.Position = [106 26 63 24];

            % Create re_design_button
            app.re_design_button = uibutton(app.quantizer_deduction, 'push');
            app.re_design_button.ButtonPushedFcn = createCallbackFcn(app, @re_design_button_Callback, true);
            app.re_design_button.Position = [188 27 77 22];
            app.re_design_button.Text = 'Reduce';

            % Create MessageTextAreaLabel
            app.MessageTextAreaLabel = uilabel(app.odq_design);
            app.MessageTextAreaLabel.HorizontalAlignment = 'right';
            app.MessageTextAreaLabel.Position = [12 58 54 22];
            app.MessageTextAreaLabel.Text = 'Message';

            % Create MessageTextArea
            app.MessageTextArea = uitextarea(app.odq_design);
            app.MessageTextArea.Position = [152 8 669 74];

            % Create ODQLabLabel
            app.ODQLabLabel = uilabel(app.odq_design);
            app.ODQLabLabel.HorizontalAlignment = 'center';
            app.ODQLabLabel.FontSize = 24;
            app.ODQLabLabel.FontWeight = 'bold';
            app.ODQLabLabel.Position = [333 485 169 32];
            app.ODQLabLabel.Text = 'ODQLab';

            % Show the figure after all components are created
            app.odq_design.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = odqlab_App2_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.odq_design)

            % Execute the startup function
            runStartupFcn(app, @(app)odqlab_StartupFcn(app, varargin{:}))

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