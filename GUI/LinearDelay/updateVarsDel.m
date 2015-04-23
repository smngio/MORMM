function out = updateVarsDel(handles)


vars = handles.data;
spec = handles.spec;

try
    
    h = waitbar(0,'Loading data...');
    
    vars.T = 10;   %default
    
    [vars.db,vars.wn] = findMoments(vars.sys.delayS,vars.sig_gen);
    
    waitbar(0.25,h,'Loading data...');
   
    [vars.mag_sys,vars.phase_sys]=bode(vars.sys.delayS,vars.omega);
    
    [vars.Acl, vars.Bcl] = buildInterSystem(vars.sys,vars.Sa,vars.La);
    
    vars.delay = getXLag(vars.sys,1);
    
    waitbar(0.45,h,'Building systems...');
    
    sol = dde23(@ddex,vars.delay,[vars.w0;vars.x0],[0,vars.T],[],vars.sys,vars.Acl,vars.Bcl);
    
    if(vars.tau_j(2)~=0)
        
        vars.xint = linspace(0,vars.T,(vars.T/(2*vars.tau_j(2))));
        f = dfilt.delay(2);
        
    else
        
        vars.xint = linspace(0,vars.T,(vars.T/(0.333)));
        f = dfilt.delay(0);
        
    end
    
    x = deval(vars.xint, sol);   
        
    waitbar(0.65,h,'Processing data...');
    
    [vars.red_mod,vars.dim_red_mod] = buildRedModDel(vars,vars.Sa,vars.La,spec);
    
    if(isempty(vars.red_mod))
        
        close(h);
        out = handles.figure1;
        return
        
    else
        
        x1 = filter(f,x,2);
        
        vars.y_sys = [zeros(1,vars.dim_red_mod) vars.sys.Cj{1}]*x + [zeros(1,vars.dim_red_mod) vars.sys.Cj{2}]*x1;
        
        waitbar(0.75,h,'Processing data...');
        
        
        
        [vars.mag_red_mod,vars.phase_red_mod]=bode(vars.red_mod.delayS,vars.omega);
        
        [vars.AclR, vars.BclR] = buildInterSystem(vars.red_mod,vars.Sa,vars.La);
        
        vars.error_db = errorBode(vars.mag_sys,vars.mag_red_mod);
        
        vars.error_phase = vars.phase_sys-vars.phase_red_mod;
        
        waitbar(0.99,h,'Processing data...');
        
        vars.xi0 = zeros(vars.dim_red_mod,1);
        
        solr = dde23(@ddex,vars.delay,[vars.w0; vars.xi0],[0,vars.T],[],vars.red_mod,vars.AclR,vars.BclR);
        
        xi = deval(vars.xint, solr);
        
        xi1 = filter(f,xi,2);
        
        vars.y_red_mod = [zeros(1,vars.dim_red_mod) vars.red_mod.Cj{1}]*xi + [zeros(1,vars.dim_red_mod) vars.red_mod.Cj{2}]*xi1;
        
        assignin('base', 'red_mod', vars.red_mod);
        
        waitbar(1,h,'Processing data...');
        
        close(h);
        
    end
    
catch err
    
    set(handles.figure1, 'Visible', 'on');
    close(h);
    errordlg(err.message,'Error')
    error(err.message);
    
end

handles.data = vars;

out = handles;

end