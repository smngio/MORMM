function out = clearLastPlot(tmp_plots)

if(~isempty(tmp_plots))
    
    for j = 1:length(tmp_plots)
        
        delete(tmp_plots{j});
        tmp_plots{j} = [];
        
    end

end

out = tmp_plots;

end