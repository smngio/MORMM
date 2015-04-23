function out = updateMoMeDel(handles)

vars = handles.data;
spec = handles.spec;

if(isfield(vars,'tmp_sig_gen'))
    
    tmp_sig_gen = vars.tmp_sig_gen;
    S = tmp_sig_gen.a;
    L = tmp_sig_gen.c;
    
else
    
    S = vars.Sa;
    L = vars.La;
    
end

xi0 = vars.xi0;

w0 = vars.w0;

newM = vars.newMoment;
tmp = [0 newM;
       -newM 0];

newS = blkdiag(S,tmp);

tmp_sig_gen = ss(newS,[],[L rand(1,2)],0);

try
    
    [tmp_red_mod,tmp_dim_red_mod] = buildRedModDel(vars,tmp_sig_gen.a,tmp_sig_gen.c,spec);
    
    if(isempty(tmp_red_mod))
        
        error('cancel');
        
    else
    tmp_diff_dim = tmp_dim_red_mod - vars.dim_red_mod;
    
    tmp_xi0 = [xi0;zeros(tmp_diff_dim,1)];
    tmp_w0 = [w0;zeros(tmp_diff_dim,1)];
    
    [tmp_mag_red_mod,tmp_phase_red_mod]=bode(tmp_red_mod.delayS,vars.omega);
    
    if(isfield(vars,'tmp_sig_gen'))
        
        vars.tmp_plots = clearLastPlot(vars.tmp_plots);
        
    end
    
    vars.tmp_sig_gen = tmp_sig_gen;
    axes(handles.axes4);
    vars.tmp_plots{1} = plot(vars.moments(:,1),vars.moments(:,2),'kd','LineWidth',2);
    vars.tmp_plots{2} = semilogx(vars.omega,mag2db(tmp_mag_red_mod(1,:)),'k--');
    legend('system','reduced model','moments','new moments','new reduced model');
    
    axes(handles.axes5);
    vars.tmp_plots{3} = semilogx(vars.omega,tmp_phase_red_mod(1,:),'k--');
    legend('system','reduced model','new reduced model');
    
    
    tmp_error_db = errorBode(vars.mag_sys,tmp_mag_red_mod);
    tmp_error_phase = vars.phase_sys-tmp_phase_red_mod;
    
    axes(handles.axes2);
    vars.tmp_plots{4} = semilogx(vars.omega,tmp_error_db,'k--');
    legend('error','new error');
    
    axes(handles.axes3);
    vars.tmp_plots{5} = semilogx(vars.omega,tmp_error_phase(1,:),'k--');
    legend('error','new error');
    
    [tmp_AclR, tmp_BclR] = buildInterSystem(tmp_red_mod,tmp_sig_gen.a,tmp_sig_gen.c);
    
    solr = dde23(@ddex,vars.delay,[tmp_w0;tmp_xi0],[0,vars.T],[], tmp_red_mod, tmp_AclR, tmp_BclR);

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
    
    vars.tmp_red_mod = tmp_red_mod;
    vars.tmp_int_red_mod= {tmp_AclR,tmp_BclR};
    vars.tmp_dim_red_mod = tmp_dim_red_mod;
    
    end
    
catch err
    
    msg = err.message;
    if(~strcmp(msg,'cancel'))
        
        errordlg(msg,'Error')
        vars.tmp_plots = clearLastPlot(vars.tmp_plots);
        vars = rmfield(vars,{'moments','newMoment','tmp_plots'});
        try
            
            vars = rmfield(vars,{'tmp_sig_gen','tmp_red_mod','tmp_int_red_mod','tmp_dim_red_mod'}); 
            
        end
        
    else
        
        vars.moments = vars.moments(1:end-1,:);
        
    end
    
end

set(handles.uipushtool6,'Enable','on');
handles.data = vars;
out = handles;

end