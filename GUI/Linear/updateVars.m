function out = updateVars(handles)


vars = handles.data;
spec = handles.spec;

try
    
    h = waitbar(0,'Loading data...');
    vars.sys=ss(vars.A,vars.B,vars.C,vars.D);
    if(isstable(vars.sys)==0)
        error('The system is unstable');
    end
    vars.sig_gen=ss(vars.S,[],vars.L,0);
    
    waitbar(0.25,h,'Loading data...');
    vars.T = 50;   %default
    
    [vars.db,vars.wn] = findMoments(vars.sys,vars.sig_gen);
    
    waitbar(0.45,h,'Building systems...');
    [vars.mag_sys,vars.phase_sys]=bode(vars.sys,vars.omega);
    vars.int_sys = interSys(vars.sys,vars.sig_gen);
    
    waitbar(0.65,h,'Processing data...');
    [vars.y_sys,vars.t_sys,~]=initial(vars.int_sys,[vars.w0; vars.x0],vars.T);
    
    waitbar(0.75,h,'Processing data...');
    
    [vars.red_mod,vars.dim_red_mod] = buildRedMod(vars.sys,vars.sig_gen,spec);
    
    if(isempty(vars.red_mod))
        
        close(h);
        out = handles.figure1;
        return
        
    else
        
        [vars.mag_red_mod,vars.phase_red_mod]=bode(vars.red_mod,vars.omega);
        vars.int_red_mod = interSys(vars.red_mod,vars.sig_gen);
        vars.error_db = errorBode(vars.mag_sys,vars.mag_red_mod);
        vars.error_phase = vars.phase_sys-vars.phase_red_mod;
        
        waitbar(0.99,h,'Processing data...');
        vars.xi0 = zeros(vars.dim_red_mod,1);
        [vars.y_red_mod,vars.t_red_mod,~]=initial(vars.int_red_mod,[vars.w0; vars.xi0],vars.T);
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