function varargout = gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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
 % --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for gui
handles.output = hObject;
 % Update handles structure
guidata(hObject, handles);
 % --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
%  (EDIT TEXT  <==  SELECTED IMAGE ROW)
[filename,pathname,filterindex] = uigetfile({'*.*'},'Select the Hazy image');
Browsestring = 'Browse ';
set(hObject, 'String', Browsestring);
final_path=strcat(pathname,filename);
I = imresize(imread(final_path), 0.5);
for i = 7 : 12
    subplot(2,6, i) ;
    cla;
    axis image off;
end
handles.hazy_image=I;
subplot(2, 6, 7), imshow(I), title('Hazy image');
set(hObject, 'String',final_path);
set(handles.editor_airlight,'String', '---');
set(handles.status,'String', 'Image selected');
guidata(hObject,handles);
disp(get(hObject, 'String'));
return;
% --- Executes on button press in dark_channel.
function dark_channel_Callback(hObject, eventdata, handles)
set(handles.status,'String','Computing Dark channel');
I = handles.hazy_image;
J = find_darkchannel(I);
handles.darkchannel = J;
subplot(2, 6, 8), imshow(J), title('Dark channel');
guidata(hObject,handles);
set(handles.status,'String','Dark channel computed') 
% --- Executes during object creation, after setting all properties.
function name_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 % --- Executes on button press in est_airlight.
function est_airlight_Callback(hObject, eventdata, handles)
% find_airlight function
set(handles.status,'String', 'Computing Airlight');
DC = handles.darkchannel;
I = handles.hazy_image;
dims = size(I);
 disp(dims);
 dims = size(DC);
 disp(dims);
 brightest_pixel = find_airlight(DC, I);
 A_matrix = zeros(dims(1), dims(2), 3);
 A_matrix(:,:,1) = brightest_pixel(1);
 A_matrix(:,:,2) = brightest_pixel(2);
 A_matrix(:,:,3) = brightest_pixel(3);
 handles.airlight = double(A_matrix) ./255;
 set(handles.editor_airlight,'String', num2str(brightest_pixel));
 guidata(hObject,handles);
set(handles.status,'String', 'Airlight Computed');
% --- Executes on button press in trans_map.
function trans_map_Callback(hObject, eventdata, handles)
set(handles.status,'String', 'Computing Transmission map');
I = double(handles.hazy_image) ./ 255;
A_matrix = handles.airlight;
transmission_map = find_transmission_map(I,A_matrix );
subplot(2, 6, 9),imshow(transmission_map), title('Transmission Map');
handles.transmission_map = transmission_map;
handles.hazy_image = I;
guidata(hObject, handles);
set(handles.status,'String', 'Transmission map Computed');
% --- Executes on button press in refined_trans.
function refined_trans_Callback(hObject, eventdata, handles)
set(handles.status,'String', 'Computing Refined Transmission map');
trans_est = handles.transmission_map;
im = handles.hazy_image;
handles.ref_trans_map = find_refined_transmission_map(im, trans_est);
subplot(2, 6, 10),imshow(handles.ref_trans_map),  title('Refined Transmission Map');
guidata(hObject, handles);
set(handles.status,'String', 'Refined Transmission map computed');
% Following code is associated with the push buttom "Dehazed Image"
set(handles.status,'String', 'Obtaining Scene Radiance');
I = handles.hazy_image;
A_matrix = handles.airlight;
transmission_map = handles.ref_trans_map;
final_image = find_SceneRadiance(I, A_matrix, transmission_map);
subplot(2, 6, 11), imshow(final_image),  title('Dehazed image');
handles.dehazed_image = final_image;
imshow(handles.hazy_image), title('Hazy Image');
imsave;
imshow(handles.dehazed_image), title('Dehazed Image');
imsave;
guidata(hObject, handles);
set(handles.status,'String', 'Scene Radiance Recovered');
