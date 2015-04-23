function [] = resetAxes(handles)

h = waitbar(0,'Resetting..');
axes(handles.axes1)
cla reset;
waitbar(0.20,h);
axes(handles.axes2)
cla reset;
waitbar(0.40,h);
axes(handles.axes3)
cla reset;
waitbar(0.60,h);
axes(handles.axes4)
cla reset;
waitbar(0.80,h);
axes(handles.axes5)
cla reset;
waitbar(1,h);
axes(handles.axes6)
cla reset;
close(h);
end