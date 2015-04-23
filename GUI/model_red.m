function varargout = model_red(varargin)
% model_red MATLAB code for model_red.fig
%      model_red, by itself, creates a new model_red or raises the existing
%      singleton*.
%
%      H = model_red returns the handle to a new model_red or the handle to
%      the existing singleton*.
%
%      model_red('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in model_red.M with the given input arguments.
%
%      model_red('Property','Value',...) creates a new model_red or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before model_red_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to model_red_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help model_red

% Last Modified by GUIDE v2.5 15-Dec-2014 11:40:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_red_OpeningFcn, ...
                   'gui_OutputFcn',  @model_red_OutputFcn, ...
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


% --- Executes just before model_red is made visible.
function model_red_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model_red (see VARARGIN)

% Choose default command line output for model_red
handles.output = hObject;
addpath('./Linear','./LinearDelay')
handles.spec = 1;
handles.type = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes model_red wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = model_red_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- LOAD DATA LINEAR.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[var, varnames] = uigetvariables({'S','L','x0','w0','A','B','C','D'}, ...
    'Introduction','Please, select data from workspace',...
    'InputTypes',{'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'},...
    'InputDimensions',[2 1 1 1 2 1 1 0]);

if(~isempty(var))
    var = circshift(var,[0,4]);
    varnames = circshift(varnames,[0,4]);
    for j=1:length(var)
        
        if(isempty(var{j}))
            errordlg('Missing data, please insert all the required data','Error data')
            return
        end
    end
    
    set(handles.popupmenu1, 'Enable', 'off');
    
    vars = loadData(var);
    
    handles.data = vars;
    
    set(handles.listbox1, 'string', varnames);
    
    
end


guidata(hObject, handles);
    
% --- RESET DATA.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1, 'string', '[]');
set(handles.edit2, 'string', '[]');
set(handles.edit3, 'string', '[]');
set(handles.edit4, 'string', '[]');
set(handles.listbox1, 'string', '');
set(handles.uipanel13,'selectedobject', handles.radiobutton1);
set(handles.uipanel14,'selectedobject', handles.radiobutton8);

if(handles.type==0)

    handles.spec = 1;
    
elseif(handles.type==1)
    
    handles.spec = -1;
    
end

if(isfield(handles,'data'))
    
    resetAxes(handles);
    handles = rmfield(handles,'data');
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.popupmenu1,'Enable','on');
    set(handles.pushbutton1,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.radiobutton1, 'Enable', 'on');
    set(handles.radiobutton2, 'Enable', 'on');
    set(handles.radiobutton3, 'Enable', 'on');
    set(handles.radiobutton4, 'Enable', 'on');
    set(handles.radiobutton5, 'Enable', 'on');
    set(handles.radiobutton6, 'Enable', 'on');
    set(handles.radiobutton7, 'Enable', 'on');
    set(handles.radiobutton8, 'Enable', 'on');
    set(handles.radiobutton9, 'Enable', 'on');
    
end
guidata(hObject, handles);

% --- START LINEAR.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if(~isfield(handles,'data'))
    errordlg('Data not found','Error Data')
    return
else
    figure = handles.figure1;
    set(figure, 'Visible', 'off');
    handles = updateVars(handles);
    
    if(~isequal(handles,figure))
        
        vars = handles.data;
        
        set(handles.edit1, 'string', mat2str(vars.w0));
        set(handles.edit2, 'string', vars.T);
        set(handles.edit3, 'string', mat2str(vars.x0));
        set(handles.edit4, 'string', mat2str(vars.xi0));
        set(handles.pushbutton1,'Enable','off');
        set(handles.pushbutton3,'Enable','off');
        set(handles.radiobutton1, 'Enable', 'off');
        set(handles.radiobutton2, 'Enable', 'off');
        set(handles.radiobutton3, 'Enable', 'off');
        set(handles.radiobutton4, 'Enable', 'off');
        set(handles.radiobutton5, 'Enable', 'off');
        set(handles.radiobutton6, 'Enable', 'off');
        set(handles.radiobutton7, 'Enable', 'off');
        handles = updatePlots(handles);
        
    else

        set(handles, 'Visible', 'on');
        return
    end
    
    set(handles.figure1, 'Visible', 'on');
    helpdlg('Reduced model generated and successfully saved in workspace! You can match more moments by means of the data cursor and the assigned button.',...
        'Help dialog');
    guidata(hObject,handles);
    
end




% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- .
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- EDIT.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

w0 = str2num(get(handles.edit1,'string'));
time = str2num(get(handles.edit2,'string'));
x0 = str2num(get(handles.edit3,'string'));
xi0 = str2num(get(handles.edit4,'string'));

if(isfield(handles,'data'))
    
    vars = handles.data;
    
    if(~isempty(w0) && ~isempty(x0) && ~isempty(xi0) && ~isempty(time))
        if(length(w0)==vars.dim_red_mod)
            
            vars.w0 = w0;
            handles.data = vars;
            
        else
            errordlg('The length of the initial condition w0 must match the number of states of the signal generator','Error w0')
            return
        end
        
        if(length(x0)==length(vars.x0))
            
            vars.x0 = x0;
            handles.data = vars;
            
        else
            errordlg('The length of the initial condition x0 must match the number of states of the system','Error x0')
            return
        end
        if(length(xi0)==vars.dim_red_mod)
            
            vars.xi0 = xi0;
            handles.data = vars;
            
        else
            errordlg('The length of the initial condition xi0 must match the number of states of the signal generator','Error xi0')
            return
        end
        
        vars.T = time;
        handles.data = vars;
        if(handles.type==0)
            
            handles = updateSim(handles);
            
        elseif(handles.type==1)
            
            handles = updateSimDel(handles);
            
        end
        
        
        
    end
    guidata(hObject,handles);
    
end  



% --- LIST BOX.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

vars = handles.data;
contents = cellstr(get(hObject,'String'));
val = contents{get(hObject,'Value')};
vars.(val)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ADD MOMENT
function uipushtool6_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.uipushtool6,'Enable','off');
h = waitbar(0,'Processing data...');
pause(0.01);

if(isfield(handles,'data'))
    
    vars = handles.data;
    
    
    dcm_obj = datacursormode(handles.figure1);
    info_struct = getCursorInfo(dcm_obj);
    waitbar(0.25,h);
    if(~isempty(info_struct))
        
        target = info_struct.Target;
        
        if(isequal(target,vars.target))
        
            point = info_struct.Position;
            vars.newMoment = point(1);
            waitbar(0.45,h);
            if(isfield(vars,'tmp_sig_gen'))
                
                vars.moments = [vars.moments; point];
                
            else
                
                vars.moments = point;
                vars.tmp_plots = {};
                
            end
            waitbar(0.75,h);
            handles.data = vars;
            
            if(handles.type==0)
                
                handles = updateMoMe(handles);
                
            elseif(handles.type==1)
                
                handles = updateMoMeDel(handles);
                
            end
            waitbar(0.95,h);
        end
    end
end
waitbar(1,h);
close(h);
guidata(hObject,handles);
set(handles.uipushtool6,'Enable','on');


% CLEAR
function uipushtool7_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(isfield(handles,'data'))
    
    vars = handles.data;
    
    if(isfield(vars,'tmp_sig_gen'))
        
        vars.tmp_plots = clearLastPlot(vars.tmp_plots);
        vars = rmfield(vars,{'moments','newMoment','tmp_sig_gen','tmp_plots','tmp_red_mod','tmp_int_red_mod','tmp_dim_red_mod'});
        handles.data = vars;
        
    end
    
end

set(handles.uipushtool6,'Enable','on');
guidata(hObject,handles);



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% SAVE
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(isfield(handles,'data'))
    
    vars=handles.data;
    
    if(isfield(vars,'tmp_red_mod'))
        
        prompt = {'Enter a name:'};
        title = 'Save';
        lines = 1;
        def = {'new_red_mod'};
        answer = inputdlg(prompt, title, lines, def);
        if(~isempty(answer))
            assignin('base', answer{1}, vars.tmp_red_mod);
            msgbox('Reduced model saved successfully!')
        end
        
    end
    
end
        


% --- PANEL LINEAR.
function uipanel13_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel13 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.type=0;
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    
    case 'radiobutton1'
        handles.spec = 1;
    case 'radiobutton2'
        handles.spec = 2;
    case 'radiobutton3'
        handles.spec = 3;
    case 'radiobutton4'
        handles.spec = 4;
    case 'radiobutton5'
        handles.spec = 5;
    case 'radiobutton6'
        handles.spec = 6;
    case 'radiobutton7'
        handles.spec = 7;
end
guidata(hObject,handles);


% --- RESET SPECIFIC.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1, 'string', '[]');
set(handles.edit2, 'string', '[]');
set(handles.edit3, 'string', '[]');
set(handles.edit4, 'string', '[]');
set(handles.uipanel13,'selectedobject', handles.radiobutton1);
set(handles.uipanel14,'selectedobject', handles.radiobutton8);
if(handles.type==0)

    handles.spec = 1;
    
elseif(handles.type==1)
    
    handles.spec = -1;
    
end

if(isfield(handles,'data'))
    
    vars = handles.data;
    f = fieldnames(vars);
    toremove = f(~ismember(f,vars.tokeep));
    vars = rmfield(vars,toremove);
    resetAxes(handles);
    set(handles.pushbutton3,'Enable','on');
    set(handles.pushbutton1,'Enable','on');
    set(handles.pushbutton9,'Enable','on');
    set(handles.pushbutton10,'Enable','on');
    set(handles.radiobutton1, 'Enable', 'on');
    set(handles.radiobutton2, 'Enable', 'on');
    set(handles.radiobutton3, 'Enable', 'on');
    set(handles.radiobutton4, 'Enable', 'on');
    set(handles.radiobutton5, 'Enable', 'on');
    set(handles.radiobutton6, 'Enable', 'on');
    set(handles.radiobutton7, 'Enable', 'on');
    set(handles.radiobutton8, 'Enable', 'on');
    set(handles.radiobutton9, 'Enable', 'on');
    handles.data = vars;
    
end
guidata(hObject, handles);


% --- POPMENU LINEAR - TIME-DELAY.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
contents = cellstr(get(hObject,'String'));
select = contents{get(hObject,'Value')};
if strcmp(select,'Linear time-delay system')
    
    set(handles.uipanel13,'Visible','off');
    set(handles.uipanel14,'Visible','on');
    set(handles.pushbutton1,'Visible','off');
    set(handles.pushbutton3,'Visible','off');
    set(handles.pushbutton9,'Visible','on');
    set(handles.pushbutton10,'Visible','on');
    handles.spec = -1;
    handles.type = 1;
    
elseif strcmp(select,'Linear system')
    
    
    set(handles.pushbutton9,'Visible','off');
    set(handles.pushbutton10,'Visible','off');
    set(handles.uipanel14,'Visible','off');
    set(handles.uipanel13,'Visible','on');
    set(handles.pushbutton1,'Visible','on');
    set(handles.pushbutton3,'Visible','on');
    set(handles.radiobutton1,'Value',1);
    handles.spec = 1;
    handles.type = 0;
    
end

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- LOAD DATA TD.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[var, varnames] = uigetvariables({'S','L','tau_j','tau_u','w0','x0','A0','A1','B0','B1','C0','C1'}, ...
    'Introduction','Please, select data from workspace',...
    'InputTypes',{'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'},...
    'InputDimensions',[2 1 0 1 1 1 2 2 1 1 1 1]);

if(~isempty(var))
    var = circshift(var,[0,6]);
    varnames = circshift(varnames,[0,6]);
    for j=1:length(var)
        
        if(isempty(var{j}))
            errordlg('Missing data, please insert all the required data','Error data')
            return
        end
        
    end
    
    try
        
        vars = loadDataDel(var);
        
        set(handles.popupmenu1, 'Enable', 'off');
    
        handles.data = vars;
    
        set(handles.listbox1, 'string', varnames);
        
    catch err
        
        errordlg(err.message);
        return
        
    end
    
end


guidata(hObject, handles);


% --- START TD.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isfield(handles,'data'))
    errordlg('Data not found','Error Data')
    return
else
    figure = handles.figure1;
    set(figure, 'Visible', 'off');
    handles = updateVarsDel(handles);
    
    if(~isequal(handles,figure))
        
        vars = handles.data;
        
        set(handles.edit1, 'string', mat2str(vars.w0));
        set(handles.edit2, 'string', vars.T);
        set(handles.edit3, 'string', mat2str(vars.x0));
        set(handles.edit4, 'string', mat2str(vars.xi0));
        set(handles.pushbutton9,'Enable','off');
        set(handles.pushbutton10,'Enable','off');
        set(handles.radiobutton8, 'Enable', 'off');
        set(handles.radiobutton9, 'Enable', 'off');

        handles = updatePlotsDel(handles);
        
    else

        set(handles, 'Visible', 'on');
        return
    end
    
    set(handles.figure1, 'Visible', 'on');
    helpdlg('Reduced model generated and successfully saved in workspace! You can match more moments by means of the data cursor and the assigned button.',...
        'Help dialog');
    guidata(hObject,handles);
    
end


% --- PANEL TD.
function uipanel14_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel14 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.type=1;
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    
    
    case 'radiobutton8'
        handles.spec = -1;
    case 'radiobutton9'
        handles.spec = -2;
end
guidata(hObject,handles);
