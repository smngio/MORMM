function out = updatePlots(handles)

vars = handles.data;

axes(handles.axes4);
vars.target = semilogx(vars.omega,mag2db(vars.mag_sys(1,:)));
hold on;
semilogx(vars.omega,mag2db(vars.mag_red_mod(1,:)),'r--');
plot(vars.wn(:,1),vars.db(1,:),'rs','LineWidth',1.5)
grid on;
legend('system','reduced model','moments')
ylabel('Magnitude (dB)')
title('Bode diagram')

axes(handles.axes5);
semilogx(vars.omega,vars.phase_sys(1,:));
hold on;
semilogx(vars.omega,vars.phase_red_mod(1,:),'r--');
grid on;
legend('system','reduced model')
ylabel('phase (deg)')
xlabel('Frequency (rad/s)')

axes(handles.axes1);
vars.sim_sys = plot(vars.t_sys,vars.y_sys);
hold on;
vars.sim_red_mod = plot(vars.t_red_mod,vars.y_red_mod,'r--');
grid on;
legend('system','reduced model')
xlim([0, vars.T]);

axes(handles.axes6);
T = unique([vars.t_sys; vars.t_red_mod]);
vars.y_sys_interp =interp1(vars.t_sys,vars.y_sys,T);
vars.y_red_mod_interp =interp1(vars.t_red_mod,vars.y_red_mod,T);
vars.sim_err = plot(T,abs(vars.y_sys_interp - vars.y_red_mod_interp),'r');
hold on;
grid on;
xlabel('Time (sec)');
ylabel('Absolute error')
xlim([0, vars.T]);

axes(handles.axes2);
semilogx(vars.omega,vars.error_db,'r')
hold on;
grid on;
title('Plot Bode error')
ylabel('Magnitude error (dB)')

axes(handles.axes3);
semilogx(vars.omega,vars.error_phase(1,:),'r')
hold on;
grid on;
ylabel('Phase error')
xlabel('Frequency (rad/s)');

handles.data = vars;
out = handles;


end