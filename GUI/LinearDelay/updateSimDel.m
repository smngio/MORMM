function out = updateSimDel(handles)

vars = handles.data;

if(isfield(vars,'sim_sys'))
    
    delete(vars.sim_sys);
    delete(vars.sim_red_mod);
    delete(vars.sim_err);
    
end


h = waitbar(0,'Processing data..');

sol = dde23(@ddex,vars.delay,[vars.w0;vars.x0],[0,vars.T],[],vars.sys,vars.Acl,vars.Bcl);

if(vars.tau_j(2)~=0)
    
    vars.xint = linspace(0,vars.T,(vars.T/(2*vars.tau_j(2))));
    f = dfilt.delay(2);
    
else
    
    vars.xint = linspace(0,vars.T,(vars.T/(0.333)));
    f = dfilt.delay(0);
    
end

x = deval(vars.xint, sol);

x1 = filter(f,x,2);
    
vars.y_sys = [zeros(1,vars.dim_red_mod) vars.sys.Cj{1}]*x + [zeros(1,vars.dim_red_mod) vars.sys.Cj{2}]*x1;

solr = dde23(@ddex,vars.delay,[vars.w0; vars.xi0],[0,vars.T],[],vars.red_mod,vars.AclR,vars.BclR);

xi = deval(vars.xint, solr);
    
xi1 = filter(f,xi,2);
    
vars.y_red_mod = [zeros(1,vars.dim_red_mod) vars.red_mod.Cj{1}]*xi + [zeros(1,vars.dim_red_mod) vars.red_mod.Cj{2}]*xi1;

waitbar(1,h);


axes(handles.axes1);
vars.sim_sys = plot(vars.xint,vars.y_sys);
hold on;
vars.sim_red_mod = plot(vars.xint,vars.y_red_mod,'r--');
grid on;
legend('system','reduced model')
xlim([0, vars.T]);

axes(handles.axes6);
vars.sim_err = plot(vars.xint,abs(vars.y_sys - vars.y_red_mod),'r');
hold on;
grid on;
xlabel('Time (sec)');
ylabel('Absolute error')
xlim([0, vars.T]);


if(isfield(vars,'tmp_red_mod'))
    
    delete(vars.tmp_plots{6});
    delete(vars.tmp_plots{7});
    
    tmp_red_mod = vars.tmp_red_mod;
    tmp_dim_red_mod = vars.tmp_dim_red_mod;
    tmp_diff_dim = tmp_dim_red_mod - vars.dim_red_mod;
    tmp_xi0 = [vars.xi0;zeros(tmp_diff_dim,1)];
    tmp_w0 = [vars.w0;zeros(tmp_diff_dim,1)];
    tmp_int_red_mod = vars.tmp_int_red_mod;
    solr = dde23(@ddex,vars.delay,[tmp_w0;tmp_xi0],[0,vars.T],[], vars.tmp_red_mod, tmp_int_red_mod{1}, tmp_int_red_mod{2});

    if(vars.tau_j(2)~=0)
        
        xint = linspace(0,vars.T,(vars.T/(2*vars.tau_j(2))));
        f = dfilt.delay(2);
        
    else
        
        xint = linspace(0,vars.T,(vars.T/(0.333)));
        f = dfilt.delay(0);
        
    end
    
    tmp_xi = deval(xint, solr);
    
    tmp_xi1 = filter(f,tmp_xi,2);
    
    tmp_y_red_mod = [zeros(1,tmp_dim_red_mod) tmp_red_mod.Cj{1}]*tmp_xi + [zeros(1,tmp_dim_red_mod) tmp_red_mod.Cj{2}]*tmp_xi1;
    
    axes(handles.axes1);
    
    vars.tmp_plots{6} = plot(xint,tmp_y_red_mod,'k--');
    
    legend('system','reduced model','new reduced model');  
    
    axes(handles.axes6);
    
    vars.tmp_plots{7} = plot(xint,abs(vars.y_sys - tmp_y_red_mod),'k--');
    legend('error','new error');
    

end


close(h);





handles.data = vars;
out = handles;

end