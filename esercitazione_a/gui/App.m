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
            obj.Layout.RowHeight = {'0.65x', 6, '0.35x'};
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
            
            lbl = uilabel(sg, "Text", "⣿", "HorizontalAlignment", "center", "VerticalAlignment", "center", "FontColor", [0.6 0.6 0.6], "BackgroundColor", [0.94 0.94 0.94]);
            lbl.Layout.Row = [1 3];
            lbl.Layout.Column = 2;

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
                obj.IsDragging = true;
                obj.Figure.Pointer = 'top';
            end
        end

        function onMouseMove(obj, ~, ~)
            if obj.IsDragging
                mousePos = obj.Figure.CurrentPoint;
                figPos = obj.Figure.Position;
                frac = max(0.05, min(0.95, mousePos(2) / figPos(4)));
                obj.Layout.RowHeight = {[num2str(1-frac) 'x'], 6, [num2str(frac) 'x']};
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
    end

end