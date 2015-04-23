function out = updateSim(handles)

vars = handles.data;

if(isfield(vars,'sim_sys'))
    
    delete(vars.sim_sys);
    delete(vars.sim_red_mod);
    delete(vars.sim_err);
    
end


h = waitbar(0,'Processing data..');
[vars.y_red_mod,vars.t_red_mod,~]=initial(vars.int_red_mod,[vars.w0; vars.xi0],vars.T);
waitbar(0.5,h);
[vars.y_sys,vars.t_sys,~]=initial(vars.int_sys,[vars.w0; vars.x0],vars.T);

T = unique([vars.t_sys;vars.t_red_mod]);
vars.y_sys_interp =interp1(vars.t_sys,vars.y_sys,T);
vars.y_red_mod_interp =interp1(vars.t_red_mod,vars.y_red_mod,T);

waitbar(1,h);


axes(handles.axes1);
vars.sim_sys = plot(vars.t_sys,vars.y_sys);
hold on;
vars.sim_red_mod = plot(vars.t_red_mod,vars.y_red_mod,'r--');
legend('system','reduced model')
grid on;
xlim([0, vars.T]);

axes(handles.axes6);
vars.sim_err = plot(T,abs(vars.y_sys_interp - vars.y_red_mod_interp),'r');
hold on;
grid on;
xlim([0, vars.T]);

if(isfield(vars,'tmp_red_mod'))
    
    delete(vars.tmp_plots{6});
    delete(vars.tmp_plots{7});
    
    tmp_dim_red_mod = vars.tmp_dim_red_mod;
    tmp_diff_dim = tmp_dim_red_mod - vars.dim_red_mod;
    tmp_xi0 = [vars.xi0;zeros(tmp_diff_dim,1)];
    tmp_w0 = [vars.w0;zeros(tmp_diff_dim,1)];
    
    [tmp_y_red_mod,tmp_t_red_mod,~]=initial(vars.tmp_int_red_mod,[tmp_w0; tmp_xi0],vars.T);
    
    axes(handles.axes1);
    vars.tmp_plots{6} = plot(tmp_t_red_mod,tmp_y_red_mod,'k--');
    legend('system','reduced model','new reduced model')
    
    T = unique([vars.t_sys;tmp_t_red_mod]);
    tmp_y_sys_interp =interp1(vars.t_sys,vars.y_sys,T);
    tmp_y_red_mod_interp =interp1(tmp_t_red_mod,tmp_y_red_mod,T);  
    
    axes(handles.axes6);
    vars.tmp_plots{7} = plot(T,abs(tmp_y_sys_interp - tmp_y_red_mod_interp),'k--');
    legend('error','new error');

end


close(h);





handles.data = vars;
out = handles;

end