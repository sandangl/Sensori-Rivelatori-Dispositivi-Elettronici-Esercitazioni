classdef App < handle
    %APP Classe principale dell'applicazione
    %   Gestisce la finestra principale e coordina Model, View e Controller

    properties
        Figure(:, 1) matlab.ui.Figure
        Modello(:, 1) Model
        Layout(:, 1)
        VistaGrafici(:, 1) PlotView
        Controller(:, 1) Controller
        TabController(:, 1) TabController
        % ponytail: minimal properties for draggable splitter
        Splitter(:, 1)
        IsDragging(1, 1) logical = false
    end

    methods
        function obj = App()

            modello = Model();
            obj.Modello = modello;

            %% Configurazione finestra principale
            obj.Figure = uifigure("Visible", "off");
            obj.Figure.Name = "Sensori-Rivelatori-Dispositivi-Elettronici-2024-2025";
            obj.Figure.Units = "normalized";
            obj.Figure.Position = [0,0,1,1];
            obj.Figure.WindowState = "maximized";
            obj.Figure.Theme = 'light';

            %% Configurazione layout

            obj.Layout = uigridlayout("Parent", obj.Figure);
            obj.Layout.RowHeight = {'0.65x', 8, '0.35x'};
            obj.Layout.ColumnWidth = {'1x'};

            %% Configurazione controlli
            obj.TabController = TabController();
            
            obj.Controller = Controller("Parent", obj.Layout);
            obj.Controller.Layout.Row = 3;
            obj.Controller.Layout.Column = 1;
            
            obj.Splitter = uipanel("Parent", obj.Layout, "BorderType", "none", "BackgroundColor", [0.94 0.94 0.94]);
            obj.Splitter.Layout.Row = 2;
            obj.Splitter.Layout.Column = 1;
            
            sg = uigridlayout(obj.Splitter, "RowHeight", {'1x', 1, '1x'}, "ColumnWidth", {'1x', 'fit', '1x'}, "Padding", 0, "RowSpacing", 0, "ColumnSpacing", 0);
            
            linePanel = uipanel(sg, "BorderType", "none", "BackgroundColor", [0.7 0.7 0.7]);
            linePanel.Layout.Row = 2;
            linePanel.Layout.Column = [1 3];
            
            gripLayout = uigridlayout(sg, "RowHeight", {'1x', 2, '1x'}, "ColumnWidth", {2, 2, 2, 2, 2}, "Padding", [12, 0, 12, 0], "RowSpacing", 0, "ColumnSpacing", 2, "BackgroundColor", [0.94 0.94 0.94]);
            gripLayout.Layout.Row = [1 3];
            gripLayout.Layout.Column = 2;
            
            p1 = uipanel(gripLayout, "BackgroundColor", [0.6 0.6 0.6], "BorderType", "none"); p1.Layout.Row = 2; p1.Layout.Column = 1;
            p2 = uipanel(gripLayout, "BackgroundColor", [0.6 0.6 0.6], "BorderType", "none"); p2.Layout.Row = 2; p2.Layout.Column = 3;
            p3 = uipanel(gripLayout, "BackgroundColor", [0.6 0.6 0.6], "BorderType", "none"); p3.Layout.Row = 2; p3.Layout.Column = 5;

            obj.TabController.App = obj;

            %% Configurazione vista

            obj.VistaGrafici = PlotView("Parent", obj.Layout);
            obj.VistaGrafici.Layout.Row = 1;
            obj.VistaGrafici.Layout.Column = 1;

            %% Dipendenze
            obj.VistaGrafici.App = obj;
            obj.Modello.App = obj;
            obj.Controller.App = obj;

            obj.VistaGrafici.Subscribe();

            obj.Figure.WindowButtonDownFcn = @obj.onMouseDown;
            obj.Figure.WindowButtonMotionFcn = @obj.onMouseMove;
            obj.Figure.WindowButtonUpFcn = @obj.onMouseUp;

            obj.Figure.Visible = "on";
        end

        function showError(obj, message)
            uialert(obj.Figure, message, "Errore", "Icon", "error");
        end

        function showInfo(obj, message)
            uialert(obj.Figure, message, "Info", "Icon", "info");
        end
        
        function onMouseDown(obj, ~, ~)
            currObj = obj.Figure.CurrentObject;
            isSplitter = false;
            while ~isempty(currObj) && isvalid(currObj)
                if currObj == obj.Splitter
                    isSplitter = true;
                    break;
                end
                if isprop(currObj, 'Parent')
                    currObj = currObj.Parent;
                else
                    break;
                end
            end
            
            if isSplitter
                if strcmp(obj.Figure.SelectionType, 'open')
                    % Double-click: toggle layout
                    obj.toggleSplitLayout();
                else
                    obj.IsDragging = true;
                    obj.Figure.Pointer = 'top';
                end
            end
        end

        function onMouseMove(obj, ~, ~)
            if obj.IsDragging
                mousePos = obj.Figure.CurrentPoint;
                figPos = obj.Figure.Position;
                frac = max(0.05, min(0.95, mousePos(2) / figPos(4)));
                obj.Layout.RowHeight = {[num2str(1-frac) 'x'], 8, [num2str(frac) 'x']};
            else
                currObj = obj.Figure.CurrentObject;
                isSplitter = false;
                while ~isempty(currObj) && isvalid(currObj)
                    if currObj == obj.Splitter
                        isSplitter = true;
                        break;
                    end
                    if isprop(currObj, 'Parent')
                        currObj = currObj.Parent;
                    else
                        break;
                    end
                end
                
                if isSplitter
                    obj.Figure.Pointer = 'top';
                else
                    obj.Figure.Pointer = 'arrow';
                end
            end
        end

        function onMouseUp(obj, ~, ~)
            if obj.IsDragging
                obj.IsDragging = false;
                obj.Figure.Pointer = 'arrow';
            end
        end

        function toggleSplitLayout(obj)
            % Parse current plot row height
            plotH = obj.Layout.RowHeight{1};
            ctrlH = obj.Layout.RowHeight{3};

            if ischar(plotH) || isstring(plotH)
                plotVal = str2double(strrep(plotH, 'x', ''));
            else
                plotVal = plotH;
            end

            if ischar(ctrlH) || isstring(ctrlH)
                ctrlVal = str2double(strrep(ctrlH, 'x', ''));
            else
                ctrlVal = ctrlH;
            end

            isDefault = abs(plotVal - 0.65) < 0.02 && abs(ctrlVal - 0.35) < 0.02;
            isCollapsed = ctrlVal < 0.01 || (isnumeric(ctrlH) && ctrlH == 0);

            if isDefault
                % Collapse: hide controller
                obj.Layout.RowHeight = {'1x', 8, 0};
                obj.Controller.Layout.Row = 3;
            else
                obj.Layout.RowHeight = {'0.65x', 8, '0.35x'};
            end
        end
    end

end