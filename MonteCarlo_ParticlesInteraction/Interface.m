function varargout = Interface(varargin)
% INTERFACE MATLAB code for Interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interface

% Last Modified by GUIDE v2.5 23-Nov-2016 21:35:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @Interface_OutputFcn, ...
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


% --- Executes just before Interface is made visible.
function Interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interface (see VARARGIN)

% Choose default command line output for Interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
TypeParticule=get(handles.edit1,'String');
set(handles.text2,'UserData',TypeParticule);



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



function edit2_Callback(hObject, eventdata, handles)
N=get(handles.edit2,'String');
set(handles.text3,'UserData',N);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
E=get(handles.edit3,'String');
set(handles.text4,'UserData',E);


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
Emin=get(handles.edit4,'String');
set(handles.text5,'UserData',Emin);


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

A=18;
ro=1000;
Navo=6.23E23;
sigmaTotElectrons=1;
sigmaTotPhotons=1;
numIteration=1;
contrainte=1;

%tailleMatrice=50;
tailleBoite=10;%taille en cm
%Inputs
%TypeParticule=input('Type de particule');%0-Photon, 1-Electron  
%N=input('Nombre de particules');
%E=input('Energie incidente');
%Emin=input('Energie de seuil');
TypeParticule=get(handles.text2,'UserData');
N=get(handles.text3,'UserData');
E=get(handles.text4,'UserData');
Emin=get(handles.text5,'UserData');
tailleMatrice=get(handles.text7,'UserData');
tailleBoite=get(handles.text8,'UserData');
tailleBoite=str2num(tailleBoite);
tailleMatrice=str2num(tailleMatrice);
TypeParticule=str2num(TypeParticule);
N=str2num(N);
E=str2num(E);
Emin=str2num(Emin);

MatriceParticules=zeros(N,6);%Definition matrice de donnees
variableNaN=0;
%Initialisation matrice
MatriceParticules(:,1)=MatriceParticules(:,1)+ones(N,1)*E;
MatriceParticules(:,7)=TypeParticule*ones(N,1);

Inputs=[MatriceParticules(:,1) MatriceParticules(:,3) MatriceParticules(:,7)];


while(contrainte)

for ii=1:size(Inputs,1)

if (Inputs(ii,3))%==1
Outputs(2*ii-1-variableNaN:2*ii-variableNaN,:)=FonctionElectron(Inputs(ii,1));
if (sum(sum(isnan(Outputs(2*ii-1-variableNaN:2*ii-variableNaN,:)),2)==3)==1)
Outputs([zeros(2*ii-variableNaN-2) sum(isnan(Outputs(2*ii-1-variableNaN:2*ii-variableNaN,:)),2)==3],:)=[];
variableNaN=variableNaN+1;
end

MatriceParticules(N*2^numIteration-N+2*ii-1-variableNaN:N*2^numIteration-N+2*ii-variableNaN,4)=-A*log(rand(2,1));%/ro*Navo*sigmaTotElectrons;

else
Outputs(2*ii-1-variableNaN:2*ii-variableNaN,:)=FonctionPhoton(Inputs(ii,1));
if (sum(sum(isnan(Outputs(2*ii-1-variableNaN:2*ii-variableNaN,:)),2)==3)==1)
Outputs([zeros(2*ii-variableNaN-2) sum(isnan(Outputs(2*ii-1-variableNaN:2*ii-variableNaN,:)),2)==3],:)=[];
variableNaN=variableNaN+1;
end
MatriceParticules(N*2^numIteration-N+2*ii-1-variableNaN:N*2^numIteration-N+2*ii-variableNaN,4)=-A*log(rand(2,1));%/ro*Navo*sigmaTotPhotons;

end

end
Inputs=[Inputs(:,1) Inputs(:,1)]';
MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,2)=Inputs(:)-Outputs(:,1);

MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,1)=Outputs(:,1);
MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,3)=Outputs(:,2);
MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,7)=Outputs(:,3);
MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,5)=MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,4).*cos(MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,3));
MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,6)=MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,4).*sin(MatriceParticules(N*2^numIteration-N+1-variableNaN:N*(2*2^numIteration-1)-variableNaN,3));
Outputs(E(:,1)<Emin,:)=[];
Inputs=Outputs;
numIteration=numIteration+1;

if (numIteration>6)
  contrainte=0;
end

end

axes(handles.axes1);%se placer sur axe1
plot_dose(MatriceParticules,Emin,tailleMatrice,tailleBoite);



function edit5_Callback(hObject, eventdata, handles)
tailleMatrice=get(handles.edit5,'String');
set(handles.text7,'UserData',tailleMatrice);





% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
tailleBoite=get(handles.edit6,'String');
set(handles.text8,'UserData',tailleBoite);


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
